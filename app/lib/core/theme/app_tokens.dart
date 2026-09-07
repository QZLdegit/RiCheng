import 'package:flutter/material.dart';

/// MAGI 设计令牌 —— 与 docs/TECH.md「UI tokens」一节同步维护。
///
/// 基底风格（AGENTS.md 硬性约定）：纯白背景、细 1px 分隔线、单一强调蓝
/// #1A56DB、等宽字体（JetBrains Mono + 系统黑体）、小圆角（≤10px）、无阴影。
/// 任何组件禁止绕过本文件写死色值 / 字号 / 间距。
abstract final class AppColors {
  /// 基底：纯白背景。
  static const Color bg = Color(0xFFFFFFFF);

  /// 次级背景（区块底色）。
  static const Color bgSoft = Color(0xFFF6F7F9);

  /// 三级背景（输入/悬停底色）。
  static const Color bgMuted = Color(0xFFEEF0F4);

  /// 主文字。
  static const Color ink = Color(0xFF17191E);

  /// 次要文字。
  static const Color muted = Color(0xFF6A7180);

  /// 细 1px 分隔线。
  static const Color rule = Color(0xFFE4E7EC);

  /// 唯一强调蓝。
  static const Color accent = Color(0xFF1A56DB);

  /// 强调蓝浅底。
  static const Color accentSoft = Color(0xFFEAF0FC);

  /// NERV 红 —— 仅允许三种语义：DDL 临近（≤3 天）/ 课程冲突 / 服务器失联。
  static const Color nervRed = Color(0xFFD6323C);

  /// NERV 红浅底。
  static const Color nervRedSoft = Color(0xFFFDEFF0);

  static const Color white = Color(0xFFFFFFFF);
}

/// 四象限视觉档位 —— 与 PRD「四象限 4 档视觉区分，不另造色」对应。
///
/// 编码规则（不引入新色相）：重要 → 蓝系，不重要 → 墨 / 灰系；
/// 紧急 → 实底高对比，不紧急 → 浅底 / 描边。
class QuadrantTheme {
  const QuadrantTheme({
    required this.code,
    required this.label,
    required this.fg,
    required this.bg,
    required this.border,
  });

  final String code;
  final String label;
  final Color fg;
  final Color bg;
  final Color border;
}

abstract final class AppQuadrants {
  static const QuadrantTheme q1 = QuadrantTheme(
    code: 'q1',
    label: '重要紧急',
    fg: AppColors.white,
    bg: AppColors.accent,
    border: AppColors.accent,
  );

  static const QuadrantTheme q2 = QuadrantTheme(
    code: 'q2',
    label: '重要不紧急',
    fg: AppColors.accent,
    bg: AppColors.accentSoft,
    border: AppColors.accent,
  );

  static const QuadrantTheme q3 = QuadrantTheme(
    code: 'q3',
    label: '紧急不重要',
    fg: AppColors.ink,
    bg: AppColors.white,
    border: AppColors.ink,
  );

  static const QuadrantTheme q4 = QuadrantTheme(
    code: 'q4',
    label: '不紧急不重要',
    fg: AppColors.muted,
    bg: AppColors.bgSoft,
    border: AppColors.rule,
  );

  static const List<QuadrantTheme> all = <QuadrantTheme>[q1, q2, q3, q4];
}

/// 小圆角（≤10px 上限）。
abstract final class AppRadius {
  static const double xs = 4;
  static const double s = 6;
  static const double m = 8;
  static const double l = 10;
}

/// 间距刻度。
abstract final class AppSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// 1px 细分隔线。
abstract final class AppBorder {
  /// 单侧 / 形状内边线（如 Border.top、RoundedRectangleBorder.side）。
  static const BorderSide hairline = BorderSide(color: AppColors.rule, width: 1);

  /// 四周边框（用于 BoxDecoration.border）。
  static const Border hairlineBox = Border.fromBorderSide(hairline);
}

/// 字体：JetBrains Mono 优先，中文回退系统黑体。
abstract final class AppFonts {
  static const String family = 'JetBrainsMono';
  static const List<String> fallback = <String>[
    'Microsoft YaHei',
    'PingFang SC',
    'Noto Sans CJK SC',
    'sans-serif',
  ];
}
