# ROADMAP — MAGI 开发路线与进度

规则：按序推进；每个里程碑验收命令真实通过后才可勾选并打 tag。验收未过的项禁止进入下一里程碑。

> 编号约定：**S = 开发里程碑**（本文件），**M = 功能模块**（PRD.md）。二者刻意分开，避免混淆。

## 当前状态

- 进行中：S0（未开始）
- 待人工确认：PRD.md 第 5 节剩余假设（课程批量导入的列映射 / 默认提醒时间值）；识图模型、域名 HTTPS、截图隐私、三端、日期制、桌面右侧便签形态与小组件均已确认

## 里程碑

### [ ] S0 · 脚手架
范围：Flutter 三端工程（Windows/Linux/Android）与主题 tokens、五 Tab 骨架（今日/课程表/任务/截图/设置）；FastAPI 空壳 + /healthz；uvicorn 本地起服务。
验收：`flutter analyze` 0 issue；`uvicorn` 起后 `curl -f http://localhost:8001/healthz` 返回 200；三端均能启动到首页骨架。
Tag：`s0-scaffold`

### [ ] S1 · 课程表（本地，日期制）
范围：drift 建表（semester/course/textbook）、课程与教材 CRUD、周/月视图、日期范围与 weekday 过滤、冲突检测、课程表格导入（CSV/iCalendar 基础解析为日期制课程）。
验收：`dart test`：日期范围过滤、weekday 匹配、冲突检测、导入解析四组单测全绿（分支覆盖 ≥90%）。
Tag：`s1-local-courses`

### [ ] S2 · 任务与日程（本地）
范围：任务 CRUD 与状态流转、四象限字段与手动改象限、DDL 72h 红色警示、排序；事件 CRUD（每天/每周/每两周）与日视图。
验收：`dart test`：状态流转、象限排序、DDL 阈值单测全绿。
Tag：`s2-local-tasks`

### [ ] S3 · 今日简报 + 常驻可见层（本地）
范围：简报页聚合（课程/事件时间轴、带书清单勾选与自定义物品、今日任务四象限分组、MAGI 建议位预留）、无课空态；桌面右侧便签（桌面层、任务+待办，Windows + MX Linux）；Android 小组件（home_widget，今日课程 + 任务 + 最急 DDL）。
验收：`dart run tools/seed.dart` 后人工核对四区块渲染正确；桌面右侧便签显示今日任务/待办与简报一致、点击可唤起主窗；Android 小组件（Redmi K70 Ultra）显示今日课程/任务并可点击跳转；学期未设置的降级路径可用。
Tag：`s3-local-briefing`
（此处为首个可日常使用的版本：手动录课即可每天用，且桌面/手机桌面均无需打开 App 即可看当日安排）

### [ ] S4 · 后端与同步
范围：全部 REST 端点、Token 认证、同步引擎（push/pull、last-write-wins）、设置页服务器配置与登录。
验收：`pytest` 全绿；`bash tools/smoke.sh`（登录→建课→建任务→拉取）通过。
Tag：`s4-backend-sync`

### [ ] S5 · 截图识别
范围：`/vision/extract`（Qwen-VL 识图）、截图/剪贴板入口（三端）、候选任务结构化展示、逐条确认/编辑/丢弃后入库。
验收：`pytest` Mock Qwen-VL 返回的解析与落库全绿；真机走查：微信/QQ 聊天截图识别并可编辑入库。
Tag：`s5-vision-capture`

### [ ] S6 · 智能安排
范围：/ai/plan、DeepSeek 集成（Prompt 模板+四步校验+重试 1 次）、四象限首判（AI+规则兜底）、贪心降级、建议列表 UI（接受/拒绝）、时间块落库。
验收：`pytest` 贪心纯函数固定输入输出比对 + Mock DeepSeek 三异常路径（超时/非法 JSON/越界时间）+ 四象限规则兜底单测全绿。
Tag：`s6-ai-plan`

### [ ] S7 · 提醒推送
范围：本地通知（出击提醒/截止催办，移动端）+ 桌面端系统通知或 ntfy 客户端；ntfy 容器接入、晨报 07:00 与到期汇总 09:00 定时任务、通知权限与电池白名单引导。
验收：adb 真机手动清单通过 + 桌面端通知弹出验证；`POST /healthz?trigger=briefing` 触发推送实际送达。
Tag：`s7-notify`

### [ ] S8 · 部署打磨（MVP 完成）
范围：Nginx 子域名 + certbot 扩签上线（复用博客反代，`api.`/`ntfy.` 子域名）、三端打包（Android APK / Windows / Linux）、JSON 导出/导入、空态错误态全量走查、EVA 文案层（作战简报/出击提醒/待机）、应用图标。
验收：真机完成度走查清单 100%；导出→清空→导入逐字段一致；三端任一端变更可在另一端经同步看到。
Tag：`s8-mvp`

## P2 备选（用户明确提出才立项）

- 自然语言快速添加任务（“明天下午交高数作业 P162”）
- Microsoft To Do 双向同步（当前已判定取舍：不做；仅记录在案）
- 周报统计（四象限时间分配复盘）
- 桌面小组件、iOS 适配验收
- 课程临时调课/停课的例外机制（MVP 用「日程事件」覆盖）

## 变更记录

| 日期 | 变更 | 依据 |
|---|---|---|
| 2026-09-07 | 初版（M0-M7） | 项目文档 v1.0 |
| 2026-09-07 | v1.1：三端全功能、课程日期制、四象限、截图识别、AI 双模型、删 To Do；里程碑改为 S0-S8 | 用户两轮需求确认 |
| 2026-09-07 | v1.2：识图=Qwen-VL、部署复用博客 Nginx（弃 Caddy/Docker）、课程批量导入、AI 瘦代理（不用 DeepSeek Harness）、确认域名与截图隐私 | 用户第三轮确认（含 qzldeblog 部署现状） |
| 2026-09-07 | v1.3：新增常驻可见层（桌面右侧便签 + Android 小组件），并入 S3；便签固定屏幕右侧、置于桌面层 | 用户提出便签/小组件需求并确认形态 |