import 'package:flutter/material.dart';

import '../../core/widgets/feature_scaffold.dart';
import '../../core/widgets/module_placeholder.dart';

/// 课程表页（底部 Tab「课程表」）—— M2 课程表（日期制）。
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
          title: '课程表（日期制）',
          description: '课程 = 星期几 + 起止时间 + 起止日期 [start_date, end_date]（无周次 / 奇偶周）；周视图与月视图、冲突检测、表格批量导入（CSV / iCalendar）。',
          landing: '落地于 S1 · 本地课程表',
        ),
      ],
    );
  }
}
