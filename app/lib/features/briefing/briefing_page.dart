import 'package:flutter/material.dart';

import '../../core/widgets/feature_scaffold.dart';
import '../../core/widgets/module_placeholder.dart';

/// 今日页（底部 Tab「今日」）—— M1 今日简报 / M7 提醒推送。
class BriefingPage extends StatelessWidget {
  const BriefingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScaffold(
      title: '今日',
      engTag: 'TODAY',
      landing: 'S3',
      children: <Widget>[
        ModulePlaceholder(
          code: 'M1',
          title: '今日作战简报',
          description: '日期头 → 今日课程 / 日程时间轴 → 带书清单 → 今日任务（四象限分组）→ MAGI 建议卡；无课时显示「今日无课 · 待机日」。',
          landing: '落地于 S3 · 今日简报 + 常驻可见层',
        ),
        ModulePlaceholder(
          code: 'M7',
          title: '提醒推送',
          description: '晨报 07:00（作战简报浓缩）、出击提醒（课前 20min，含教室与应带教材）、任务到期汇总 09:00、截止前催办 60min。',
          landing: '落地于 S7 · 提醒推送',
        ),
      ],
    );
  }
}
