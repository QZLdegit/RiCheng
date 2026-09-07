import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:magi/app.dart';
import 'package:magi/core/theme/app_theme.dart';
import 'package:magi/core/theme/app_tokens.dart';

void main() {
  group('S0 主题 tokens', () {
    test('强调色为唯一强调蓝，错误色为 NERV 红', () {
      final ThemeData theme = buildAppTheme();
      expect(theme.colorScheme.primary, AppColors.accent);
      expect(theme.colorScheme.error, AppColors.nervRed);
      expect(theme.scaffoldBackgroundColor, AppColors.bg);
    });
  });

  group('S0 五 Tab 骨架', () {
    Finder navLabel(String label) => find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(label),
        );

    testWidgets('启动落在今日页且五个 Tab 齐全', (WidgetTester tester) async {
      await tester.pumpWidget(const MagiApp());
      expect(navLabel('今日'), findsOneWidget);
      expect(navLabel('课程表'), findsOneWidget);
      expect(navLabel('任务'), findsOneWidget);
      expect(navLabel('截图'), findsOneWidget);
      expect(navLabel('设置'), findsOneWidget);
      expect(find.text('今日作战简报'), findsOneWidget);
    });

    testWidgets('切到课程表页显示 M2 占位', (WidgetTester tester) async {
      await tester.pumpWidget(const MagiApp());
      await tester.tap(navLabel('课程表'));
      await tester.pumpAndSettle();
      expect(find.text('课程表（周次制）'), findsOneWidget);
    });

    testWidgets('切到任务页显示 M4 占位', (WidgetTester tester) async {
      await tester.pumpWidget(const MagiApp());
      await tester.tap(navLabel('任务'));
      await tester.pumpAndSettle();
      expect(find.text('任务管理'), findsOneWidget);
    });

    testWidgets('切到截图页显示 M5 占位', (WidgetTester tester) async {
      await tester.pumpWidget(const MagiApp());
      await tester.tap(navLabel('截图'));
      await tester.pumpAndSettle();
      expect(find.text('截图识别'), findsOneWidget);
    });

    testWidgets('切到设置页显示 M8 占位', (WidgetTester tester) async {
      await tester.pumpWidget(const MagiApp());
      await tester.tap(navLabel('设置'));
      await tester.pumpAndSettle();
      expect(find.text('数据同步与安全'), findsOneWidget);
    });
  });
}
