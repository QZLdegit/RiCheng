import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 功能页统一骨架：页头（标题 + 落地里程碑）+ 细分隔线 + 内容列表。
class FeatureScaffold extends StatelessWidget {
  const FeatureScaffold({
    super.key,
    required this.title,
    required this.engTag,
    required this.landing,
    required this.children,
  });

  /// 中文页名（对应底部 Tab）。
  final String title;

  /// 英文小标（如 TODAY / COURSES）。
  final String engTag;

  /// 该功能最早落地的里程碑（如 S3）。
  final String landing;

  /// 模块占位列表。
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _Header(title: title, engTag: engTag, landing: landing),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.l,
                  AppSpacing.m,
                  AppSpacing.l,
                  AppSpacing.xxl,
                ),
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.engTag, required this.landing});

  final String title;
  final String engTag;
  final String landing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.l,
        AppSpacing.xl,
        AppSpacing.l,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'MAGI · $engTag',
                  style: const TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs + 2),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    height: 1.15,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'S0 骨架 · $landing 落地',
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.muted,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
