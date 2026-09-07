import 'package:flutter/material.dart';

import '../../core/widgets/feature_scaffold.dart';
import '../../core/widgets/module_placeholder.dart';

/// 设置页（底部 Tab「设置」）—— M8 数据同步与安全 / M9 常驻可见层。
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureScaffold(
      title: '设置',
      engTag: 'SETTINGS',
      landing: 'S4',
      children: <Widget>[
        ModulePlaceholder(
          code: 'M8',
          title: '数据同步与安全',
          description: '服务器地址与登录（Token 认证）、同步队列（离线优先 / last-write-wins）、全量 JSON 导出与导入。',
          landing: '落地于 S4 · 后端与同步',
        ),
        ModulePlaceholder(
          code: 'M9',
          title: '常驻可见层',
          description: '桌面右侧便签（Windows / MX Linux，桌面层不置顶）与 Android 小组件（Redmi K70 Ultra）；均为简报数据只读投影。',
          landing: '落地于 S3 · 常驻可见层（设置入口随 S4）',
        ),
      ],
    );
  }
}
