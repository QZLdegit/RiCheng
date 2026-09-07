import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'home_shell.dart';

/// MAGI 应用根组件。
///
/// S0：三端（Windows / MX Linux / Android）共用同一入口与主题。
class MagiApp extends StatelessWidget {
  const MagiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAGI',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeShell(),
    );
  }
}
