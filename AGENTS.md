# AGENTS.md — MAGI 开发常驻规范

> 本文件是所有 Agent 开发会话的常驻上下文。任何 Agent 开始工作前必须先读本文档与 `docs/ROADMAP.md`。
> 人类用户只有一人（大一学生，本人使用），无其他干系人。

## 项目是什么

MAGI：单用户个人日程管理系统。Flutter 三端全功能（Windows / MX Linux / Android）+ 用户自有服务器上的轻量后端。
核心回答四个问题：今天有什么课、要带什么书、哪件事最急、空档该干什么；并支持「截图识别」把聊天/通知截图转为任务。
详细需求见 `docs/PRD.md`，技术事实见 `docs/TECH.md`，进度与验收见 `docs/ROADMAP.md`。

## 分层文档

| 文档 | 内容 | 何时读 |
|---|---|---|
| `docs/PRD.md` | 功能需求、字段规则、业务逻辑 | 开发任何功能模块前 |
| `docs/TECH.md` | 架构、数据模型、API、AI 引擎、部署 | 涉及数据结构 / 接口 / 引擎时 |
| `docs/ROADMAP.md` | 开发里程碑 **S0-S8**、验收命令、勾选进度 | 每次会话开始与结束 |

## 硬性约定

1. **里程碑制**：只开发 ROADMAP.md 中当前未完成的最早里程碑（S 编号）；不跳步、不提前做后续里程碑的功能。
2. **验收命令必须真实通过**：每个里程碑的验收命令（flutter analyze / dart test / pytest / curl 脚本）必须实际执行并通过后才可勾选。
3. **提交规范**：`feat(S1): 课程冲突检测`、`fix(S4): 同步队列重复出队`。里程碑前缀（S 编号）强制；每个语义单元一次提交。
4. **测试先行**：纯函数（周次过滤、单双周匹配、冲突检测、象限排序、DDL 阈值、贪心算法、简报聚合）必须先写单测再实现；分支覆盖 ≥ 90%。
5. **依赖纪律**：新增第三方包必须在提交说明中给出理由；标准库 / 现有依赖能解决的不引入。PRD 与 TECH.md 中列出的包是基线。
6. **UI 纪律**：
   - 颜色、字号、间距一律引用主题 tokens，组件内禁止写死色值。
   - 基底风格：纯白背景、细 1px 分隔线、单一强调蓝 `#1A56DB`、等宽字体（JetBrains Mono + 系统黑体）、小圆角（≤10px）、无阴影。
   - NERV 红 `#D6323C` 只允许三种语义：DDL 临近（≤3 天）、课程冲突报错、服务器失联。
   - 四象限（重要紧急/重要不紧急/紧急不重要/不紧急不重要）用 tokens 中定义的 4 档视觉区分，不另造色。
   - EVA 文案层：今日简报=「今日作战简报」、课前提醒=「出击提醒」、空闲时段=「待机」。只动文案，不动版式。
7. **文档同步**：需求或架构变更时，同步更新 docs/ 下对应文档再写代码。
8. **不越界**：MVP 不做多用户、不做 iOS 验收、**不做 Microsoft To Do 同步**、不做社交分享。P2 功能只有在用户明确提出后才立项。

## 技术基线（详见 docs/TECH.md）

- 客户端：Flutter 3.x + Riverpod + drift + dio + go_router + flutter_local_notifications + window_manager（桌面右侧便签）+ home_widget（Android 小组件）（三端：Windows / Linux / Android）
- 服务端：FastAPI + SQLModel + SQLite + APScheduler；复用博客 Nginx 反代 + certbot，`uvicorn`/`ntfy` 两个 systemd 服务部署
- AI 双模型（瘦代理）：Qwen-VL 只做截图识图（`/vision/extract`）；DeepSeek 只做任务规划（`/ai/plan`）；规划失败降级贪心算法；AI 只产建议不落库
- 课程为**周次制**（星期几 + 起止时间 + 起止周次 + 单双周），学期起止日期在程序中设置

## 会话工作流

1. 读 AGENTS.md（本文件）→ 读 ROADMAP.md 确认当前里程碑（S 编号）。
2. 开发 → 测试 → 跑验收命令 → 提交。
3. 里程碑全部完成：在 ROADMAP.md 勾选对应条目、打 git tag（如 `s1-local-courses`）。
4. 会话结束前：更新 ROADMAP.md 的「进行中」状态，写清下一步入口。

## 边界情况

- 遇到需求歧义：以 docs/PRD.md 为准；仍不明确时在代码中 TODO 标注并在 ROADMAP.md 记录待确认项，选择最保守实现。
- 遇到环境不可用（无模拟器 / 无 DeepSeek key / 无视觉模型 key）：完成可测部分（单测 / mock），在 ROADMAP.md 注明待人工验证项。
- 不要修改本文件的「硬性约定」部分；如需调整，先向用户说明并获确认。