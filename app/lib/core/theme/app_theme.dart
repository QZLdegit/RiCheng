import 'package:flutter/material.dart';

import 'app_tokens.dart';

/// 由设计令牌构建 B 风格 Material 3 主题（浅色，S0）。
ThemeData buildAppTheme() {
  const ColorScheme scheme = ColorScheme.light(
    primary: AppColors.accent,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.accentSoft,
    onPrimaryContainer: AppColors.accent,
    secondary: AppColors.muted,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.bgSoft,
    onSecondaryContainer: AppColors.ink,
    error: AppColors.nervRed,
    onError: AppColors.white,
    errorContainer: AppColors.nervRedSoft,
    onErrorContainer: AppColors.nervRed,
    surface: AppColors.bg,
    onSurface: AppColors.ink,
    onSurfaceVariant: AppColors.muted,
    outline: AppColors.rule,
    outlineVariant: AppColors.rule,
    shadow: AppColors.rule,
    scrim: AppColors.ink,
    inverseSurface: AppColors.ink,
    onInverseSurface: AppColors.bg,
  );

  final ThemeData base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: AppFonts.family,
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(
      fontFamily: AppFonts.family,
      fontFamilyFallback: AppFonts.fallback,
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.bg,
    dividerColor: AppColors.rule,
    dividerTheme: const DividerThemeData(
      color: AppColors.rule,
      thickness: 1,
      space: 1,
    ),
    splashColor: AppColors.accentSoft,
    highlightColor: AppColors.bgSoft,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: AppFonts.family,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.ink,
        letterSpacing: 0.2,
      ),
    ),
    cardTheme: const CardThemeData(
      color: AppColors.bg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.m)),
        side: AppBorder.hairline,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 64,
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      indicatorColor: AppColors.accentSoft,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        final bool selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.accent : AppColors.muted,
          size: 22,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        final bool selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontFamily: AppFonts.family,
          fontFamilyFallback: AppFonts.fallback,
          fontSize: 11,
          height: 1.2,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? AppColors.accent : AppColors.muted,
          letterSpacing: 0.6,
        );
      }),
    ),
  );
}
