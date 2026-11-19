import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';

/// Prominent triage urgency header card.
///
/// Distinguishes between Emergency (red), See a clinician today (amber),
/// and Home care (green) per Figma frames 07, 08, and 09.
class TriageBadge extends ConsumerWidget {
  /// Creates a [TriageBadge].
  const TriageBadge({
    super.key,
    required this.level,
    this.actionTitle,
    this.actionSubtitle,
  });

  /// The determined triage urgency level.
  final TriageLevel level;

  /// Optional custom title overriding the default action text.
  final String? actionTitle;

  /// Optional custom subtitle overriding the default recommendation text.
  final String? actionSubtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    final (badgeBg, badgeFg, icon, defaultTitle, defaultSub, tierLabel) =
        switch (level) {
      TriageLevel.emergency => (
          AppColors.emergencyRedLight,
          AppColors.emergencyRed,
          Icons.warning_amber_rounded,
          strings.emergencyActionTitle,
          strings.emergencyActionSubtitle,
          strings.triageEmergency,
        ),
      TriageLevel.seeClinicianToday => (
          AppColors.clinicianTodayAmberLight,
          AppColors.clinicianTodayAmber,
          Icons.schedule_rounded,
          strings.clinicianTodayActionTitle,
          strings.clinicianTodayActionSubtitle,
          strings.triageSeeClinicianToday,
        ),
      TriageLevel.homeCare => (
          AppColors.homeCareGreenLight,
          AppColors.homeCareGreen,
          Icons.home_outlined,
          strings.homeCareActionTitle,
          strings.homeCareActionSubtitle,
          strings.triageHomeCare,
        ),
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: AppSpacing.cardBorderRadius,
        border: Border.all(
          color: badgeFg.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.mdCompact,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: badgeFg,
                  borderRadius: AppSpacing.badgeBorderRadius,
                ),
                child: Text(
                  tierLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.surfaceWhite,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const Spacer(),
              Icon(icon, size: 28, color: badgeFg),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            actionTitle ?? defaultTitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: badgeFg,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            actionSubtitle ?? defaultSub,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: badgeFg.withValues(alpha: 0.9),
                  height: 1.35,
                ),
          ),
        ],
      ),
    );
  }
}
