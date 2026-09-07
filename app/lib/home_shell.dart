import 'package:flutter/material.dart';

import 'core/theme/app_tokens.dart';
import 'features/briefing/briefing_page.dart';
import 'features/capture/capture_page.dart';
import 'features/courses/courses_page.dart';
import 'features/settings/settings_page.dart';
import 'features/tasks/tasks_page.dart';

/// 底部五 Tab 主壳（今日 / 课程表 / 任务 / 截图 / 设置）。
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const List<Widget> _pages = <Widget>[
    BriefingPage(),
    CoursesPage(),
    TasksPage(),
    CapturePage(),
    SettingsPage(),
  ];

  void _onSelect(int index) {
    if (index == _index) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: AppBorder.hairline)),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _onSelect,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.today_outlined),
              selectedIcon: Icon(Icons.today),
              label: '今日',
            ),
            NavigationDestination(
              icon: Icon(Icons.view_week_outlined),
              selectedIcon: Icon(Icons.view_week),
              label: '课程表',
            ),
            NavigationDestination(
              icon: Icon(Icons.check_circle_outlined),
              selectedIcon: Icon(Icons.check_circle),
              label: '任务',
            ),
            NavigationDestination(
              icon: Icon(Icons.photo_camera_outlined),
              selectedIcon: Icon(Icons.photo_camera),
              label: '截图',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }
}
