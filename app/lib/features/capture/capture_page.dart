import 'package:flutter/material.dart';

import '../../core/widgets/feature_scaffold.dart';
import '../../core/widgets/module_placeholder.dart';

/// 截图页（底部 Tab「截图」）—— M5 截图识别。
class CapturePage extends StatelessWidget {
  const CapturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScaffold(
      title: '截图',
      engTag: 'CAPTURE',
      landing: 'S5',
      children: <Widget>[
        ModulePlaceholder(
          code: 'M5',
          title: '截图识别',
          description: '粘贴剪贴板图片或选择本地图片 → Qwen-VL 识图 → 结构化候选任务（标题 / 截止 / 关联课程 / 紧迫度线索）→ 逐条确认 / 编辑 / 丢弃后入库。',
          landing: '落地于 S5 · 截图识别',
        ),
      ],
    );
  }
}
