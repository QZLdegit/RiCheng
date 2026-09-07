import 'package:flutter/material.dart';

import '../../core/widgets/feature_scaffold.dart';
import '../../core/widgets/module_placeholder.dart';

/// 任务页（底部 Tab「任务」）—— M4 任务管理 / M6 智能安排引擎。
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScaffold(
      title: '任务',
      engTag: 'TASKS',
      landing: 'S2',
      children: <Widget>[
        ModulePlaceholder(
          code: 'M4',
          title: '任务管理',
          description: '任务 CRUD 与状态流转（待办 / 进行中 / 已完成 / 已放弃）、四象限优先级、DDL 72h 红色警示与过期置顶、象限内按截止时间排序。',
          landing: '落地于 S2 · 本地任务与日程',
        ),
        ModulePlaceholder(
          code: 'M6',
          title: '智能安排引擎',
          description: 'DeepSeek 规划（四象限复核 + 时间排程）→ 服务端四步校验 → 失败降级贪心算法；建议块逐条接受 / 拒绝后落库。',
          landing: '落地于 S6 · 智能安排',
        ),
      ],
    );
  }
}
