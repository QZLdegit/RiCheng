# TECH — MAGI 技术方案（v1.3）

与 `docs/PRD.md` 配套的技术事实。架构图、ER 图、Prompt 模板全文见 `magi-docs/magi-docs.html` 第 05 章。

> v1.2 变更：识图模型定为 Qwen-VL；部署由 Docker/Caddy 改为复用博客 Nginx + certbot + systemd；课程支持表格批量导入；明确 AI 走瘦代理（不用编排平台）。
> v1.3 变更：新增常驻可见层（桌面右侧便签 + Android 小组件），技术选型补齐 window_manager 与 home_widget；两者复用简报聚合数据，不新增业务实体。

## 1. 架构

```
Windows / MX Linux / Android（三端，Flutter 一套代码，drift 本地库，本地通知）
        │ HTTPS + Token
        ▼
你的服务器（阿里云 ECS，Ubuntu 22.04，1.6G + 4G swap，复用博客部署）
  ├─ Nginx（复用博客现有 :80/:443，certbot 自动续期，新增 api./ntfy. 子域名）
  ├─ FastAPI（REST API · 同步 · AI 代理 · APScheduler 定时任务，systemd `magi` 跑 uvicorn）
  │    └─ SQLite (/var/www/magi/data.db)
  └─ ntfy（推送服务，经 Nginx `ntfy.` 子域名对外，systemd `ntfy`）
服务端外呼（仅两条）：
  ├─ 通义千问 Qwen-VL（截图识图）—— M5
  └─ DeepSeek chat API（任务规划）—— M6
```

原则：服务器宕机时各端全功能可用（离线优先）；服务端承担同步中枢、AI 代理（密钥不下发）、定时推送三职。

## 2. 技术选型

| 层 | 选型 |
|---|---|
| 客户端 | Flutter 3.x + Material 3（自定义 B 风格主题；桌面用 desktop_window/平台适配） |
| 状态管理 | Riverpod |
| 本地库 | drift（SQLite，Stream 响应式查询） |
| 网络 / 路由 | dio（拦截器带 Token）+ go_router（深链） |
| 本地通知 | flutter_local_notifications（移动端）；桌面端用 notify_* / 系统通知或 ntfy 客户端 |
| 桌面便签 | window_manager（无边框方形窗口、定位屏幕右侧；置于桌面层不置顶——Windows 用 Win32 钉到桌面 WorkerW 层，Linux X11 用 EWMH desktop 类型、Wayland 降级贴边） |
| 小组件 | home_widget（Flutter ↔ Android AppWidget 桥接，数据经 SharedPreferences 序列化；定时刷新 + App 内主动更新） |
| 服务端 | FastAPI + SQLModel + SQLite + APScheduler + httpx |
| 推送 | ntfy self-hosted（topic=随机长串） |
| AI·识图 | 通义千问 Qwen-VL（服务端代理，key 不下发；可替换） |
| AI·规划 | DeepSeek chat API（temperature=0.3） |
| 部署 | 复用博客 Nginx 反代 + certbot；服务端 uvicorn/ntfy 两个 systemd 服务；服务器 1.6G + 4G swap |

## 3. 数据模型（八实体 + 同步元数据）

```
semester(id, name, start_date, end_date)                          # 仅用于视图默认范围与归档
course(id, name, weekday 1-7, start_time, end_time,
       start_date, end_date, room, teacher, group_key NULL, semester_id)  # 日期制，无周次
textbook(id, course_id→course, name)
event(id, title, start_at, end_at, all_day, location, note, remind_minutes, repeat_rule JSON)
task(id, title, course_id→course NULL, due_at NULL, quadrant q1|q2|q3|q4,
     estimate_min, status todo|doing|done|abandoned, note, created_at, updated_at)
time_block(id, task_id→task, day, start_at, end_at, source ai|manual, status suggested|accepted|rejected|done, reason)
sync_meta(entity, local_id, remote_id, dirty)
```

- 所有业务实体统一携带 `updated_at` + `deleted`（软删）供同步。
- 课程不展开存储：一条记录 = 星期几 + 起止时间 + 起止日期，代表该日期范围内每周该天的课次；「今天的课」按 `today ∈ [start_date,end_date] ∧ weekday 匹配` 实时计算。
- quadrant 四象限：q1 重要紧急 / q2 重要不紧急 / q3 紧急不重要 / q4 不紧急不重要；AI 首判，用户可覆盖。
- 常驻可见层（M9：桌面便签 / 小组件）不新增实体：直接复用简报聚合结果，数据从本地 drift 读，桌面便签走内存 Stream、小组件序列化进 SharedPreferences。

## 4. API（全部挂 `/api/v1`，Authorization: Bearer Token）

| 端点 | 方法 | 说明 |
|---|---|---|
| `/auth/token` | POST | 用户名密码 → Token（无过期，可吊销重发） |
| `/briefing?date=` | GET | 当日简报（晨报推送复用同一函数） |
| `/courses` `/courses/{id}` | GET/POST/PATCH/DELETE | 课程+教材（教材随课程整体提交） |
| `/tasks` `/tasks/{id}` | GET/POST/PATCH/DELETE | GET 支持按 quadrant / status 过滤 |
| `/events` `/events/{id}` | GET/POST/PATCH/DELETE | 日程事件 |
| `/time-blocks` | GET/POST/PATCH | 时间块与状态流转 |
| `/vision/extract` | POST（multipart 图片）→ `{items:[{title,due,course,urgency_hint}]}` | 截图识别（M5） |
| `/ai/plan` | POST `{date}` → `{engine:"deepseek"|"greedy", blocks:[]}` | 智能安排（M6） |
| `/sync/push` `/sync/pull` | POST | 增量同步：push 上送变更集；pull 按 updated_at 增量拉取 |
| `/export` `/import` | GET/POST | 全量 JSON 导出导入 |
| `/settings` | GET/PUT | 学期、作息、通知偏好、模型供应商键值 |
| `/healthz` | GET | 健康检查（含 DB 连通；`?trigger=briefing` 手动触发晨报用于验收） |

## 5. 智能安排引擎（M6）

**双模型分工**：识图在 M5 由 Qwen-VL 完成（`/vision/extract`）；M6 只用 DeepSeek 做规划。视觉模型供应商在 `/settings` 可配（默认 Qwen-VL），key 与 DeepSeek key 都存在服务端 `.env`。AI 层采用「瘦代理」：服务端两次直调模型，不引入可视化编排平台（DeepSeek Harness 仅在需要自主调度 Agent 时再评估）。

**Prompt（服务端模板，随代码版本管理）**

```
SYSTEM: 你是个人时间管理系统 MAGI 的调度模块。输入为某日课程占用时段、待安排任务清单与作息偏好。
输出必须是 JSON 数组，每项 {task_id, start, end, reason}，start/end 为 "HH:MM"。
硬约束：不与占用时段重叠；单块 ≥ 25 分钟；相邻块间隔 ≥ 10 分钟；按四象限顺序 important-urgent > important-not-urgent > not-important-urgent > not-important-not-urgent，同象限按截止近者优先；reason ≤ 20 字。
不要输出 JSON 以外的任何内容。
USER: {"date":..., "busy":[{"s","e","n"}...], "tasks":[{"id","title","due","quadrant","est","course"}...],
       "prefs":{"wake","sleep","lunch","gap_min","block_min"}}
```

四象限判定（AI 首判，离线/无 AI 时规则兜底）：
- 紧急 = 有截止且距截止 < 72h（或标题含「催/截止/明天」等紧迫语义）；
- 重要 = 有关联主干课程（高数/英语/线代/物理等）或考试/大作业类；
- 用户可在任务详情拖拽改象限，手动值优先。

**校验链**：JSON 可解析 → task_id 存在且状态合法 → 时间合法且在作息窗 → 与占用及彼此无重叠 → 不合格剔除；重试 1 次；全败转贪心。

**贪心（确定性纯函数，独立单测）**：

```python
def greedy_plan(busy, tasks, prefs):
    free = subtract(day_window, busy)
    tasks.sort(key=lambda t: (quad_rank(t.quadrant), t.due or INF))
    for task in tasks:
        for seg in free:
            dur = min(task.est, 90, seg.len)
            if dur >= 25:
                emit_block(task, seg.head(dur)); seg.shrink(dur + gap); break
```

AI 只产建议；用户逐条接受后时间块才 accepted 落库。

## 6. 部署（复用博客 Nginx，弃 Docker/Caddy）

服务器现状（qzldeblog）：阿里云 ECS `112.74.50.216`，Ubuntu 22.04，1.6G 内存 + 4G swap；Nginx 1.18 已占 80/443，certbot 自动续期，systemd 服务 `codex`（Gunicorn → Django → SQLite）。MAGI 与它共存，不另起反代。

**进程（systemd，与 `codex` 并列）**
- `magi.service`：uvicorn 跑 FastAPI，绑定 `127.0.0.1:8001`，SQLite 存 `/var/www/magi/data.db`。
- `ntfy.service`：ntfy 绑定 `127.0.0.1:8081`，数据目录 `/var/www/magi/ntfy/`。

**Nginx 新增两个 server block（certbot 扩签）**
```nginx
# api.qzldeblog.xyz → 127.0.0.1:8001（FastAPI）
server { listen 443 ssl; server_name api.qzldeblog.xyz;
  ssl_certificate /etc/letsencrypt/live/qzldeblog.xyz/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/qzldeblog.xyz/privkey.pem;
  location / { proxy_pass http://127.0.0.1:8001; proxy_set_header Host $host; proxy_set_header X-Forwarded-Proto https; } }
# ntfy.qzldeblog.xyz → 127.0.0.1:8081（ntfy，WebSocket 推送）
server { listen 443 ssl; server_name ntfy.qzldeblog.xyz;
  ssl_certificate /etc/letsencrypt/live/qzldeblog.xyz/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/qzldeblog.xyz/privkey.pem;
  location / { proxy_pass http://127.0.0.1:8081; proxy_http_version 1.1; proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection "upgrade"; } }
```

- 证书：`certbot --nginx -d api.qzldeblog.xyz -d ntfy.qzldeblog.xyz` 扩签，`certbot.timer` 自动续期。
- 密钥：`DEEPSEEK_API_KEY`、`QWEN_VL_API_KEY`、`MAGI_USER`、`MAGI_PASS` 放 `/var/www/magi/.env`（不进仓库）。
- App 固定 `https://api.qzldeblog.xyz`；ntfy 订阅地址 `https://ntfy.qzldeblog.xyz/<topic>`。
- 备份：宿主机 cron 每日复制 SQLite 保留 30 份 + 客户端 JSON 导出双保险（与博客 `/var/backups` 同机或异地）。

## 7. 目录结构

```
magi/（本仓库根）
├── AGENTS.md        # Agent 常驻规范
├── docs/            # PRD.md · TECH.md · ROADMAP.md
├── app/             # Flutter：lib/core(主题/DB/同步/通知) + lib/features(briefing/courses/events/tasks/capture/plan/settings) + test/（S0 已建）
├── api/             # FastAPI：routers/ models/ engine/ vision/ tests/（S0 已有 app/main.py 空壳 + /healthz）
├── deploy/          # magi.service · ntfy.service · magi-nginx.conf · .env.example（S4+ 引入）
├── tools/           # seed.dart · smoke.sh 等验收脚本（S3+ 引入）
└── magi-docs/       # 本项目文档（HTML 交互版）
```

## 8. UI tokens（S0 建立，客户端设计令牌）

代码出处：`app/lib/core/theme/app_tokens.dart`；主题组装在 `app/lib/core/theme/app_theme.dart`。
组件内禁止写死色值 / 字号 / 间距 —— 一律引用 tokens（AGENTS.md 硬性约定）。

| 令牌组 | 内容 |
|---|---|
| 基底色 | bg `#FFFFFF` 纯白 / bgSoft `#F6F7F9` / bgMuted `#EEF0F4` / rule `#E4E7EC`（1px 细分隔线） |
| 文字 | ink `#17191E` / muted `#6A7180` |
| 强调 | accent `#1A56DB`（唯一强调蓝）/ accentSoft `#EAF0FC` |
| NERV 红 | nervRed `#D6323C` / nervRedSoft `#FDEFF0`（仅 DDL 临近 ≤3 天 / 课程冲突 / 服务器失联三语义） |
| 四象限 | q1 重要紧急：实底蓝；q2 重要不紧急：蓝浅底描边；q3 紧急不重要：墨色描边；q4 不紧急不重要：灰浅底（重要→蓝系、不重要→墨/灰系；紧急→实底高对比、不紧急→浅底描边；不引入新色相） |
| 圆角 | xs 4 / s 6 / m 8 / l 10（上限 10px） |
| 间距 | xs 4 / s 8 / m 12 / l 16 / xl 24 / xxl 32 |
| 字体 | JetBrainsMono（`app/assets/fonts/` 内置 Regular/Bold，与 magi-docs 同源），中文回退 Microsoft YaHei / PingFang SC / Noto Sans CJK SC |
| 无阴影 | 全主题 elevation 0、surfaceTint 透明 |

深色模式随系统为 PRD 非功能需求；S0 仅交付浅色主题，深色 tokens 随后续里程碑补入。