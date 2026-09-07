import 'package:flutter/material.dart';

import '../../core/widgets/feature_scaffold.dart';
import '../../core/widgets/module_placeholder.dart';

/// 课程表页（底部 Tab「课程表」）—— M2 课程表（周次制）。
class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScaffold(
      title: '课程表',
      engTag: 'COURSES',
      landing: 'S1',
      children: <Widget>[
        ModulePlaceholder(
          code: 'M2',
          title: '课程表（周次制）',
          description: '课程 = 星期几 + 起止时间 + 起止周次 [start_week, end_week] + 单双周（all / odd / even）；由学期起止日期算出当前周次，过滤本周/本日课程；含周/月视图、冲突检测（同 weekday ∧ 周次有交集 ∧ 单双周不互斥 ∧ 时间重叠）与 CSV / iCalendar 批量导入。',
          landing: '落地于 S1 · 本地课程表（种子数据 seed/courses.json 可一键导入）',
        ),
      ],
    );
  }
}
