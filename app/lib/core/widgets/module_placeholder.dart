import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

/// 模块占位卡：标注未来里程碑实现的功能模块（S0 仅骨架）。
class ModulePlaceholder extends StatelessWidget {
  const ModulePlaceholder({
    super.key,
    required this.code,
    required this.title,
    required this.description,
    required this.landing,
  });

  /// 模块编号（PRD，如 M1）。
  final String code;

  /// 模块名。
  final String title;

  /// 一行功能摘要。
  final String description;

  /// 落地里程碑说明。
  final String landing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: AppBorder.hairlineBox,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.m)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s - 2,
                  vertical: AppSpacing.xs - 1,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentSoft,
                  borderRadius: const BorderRadius.all(Radius.circular(AppRadius.xs)),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    height: 1.3,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            description,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 12.5,
              color: AppColors.muted,
              height: 1.6,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: AppSpacing.m - 2),
          Text(
            landing,
            style: const TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
