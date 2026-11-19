import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';
import '../widgets/outpost_app_bar.dart';

/// Screen presenting the clinical urgency classification and next steps.
///
/// Implements safety boundaries per rules.md:
/// - Displays one of three discrete triage tiers ([TriageLevel]).
/// - Shows guideline citation and deterministic reasoning.
/// - Includes mandatory disclaimer and direct "Call emergency" action.
class TriageResultScreen extends ConsumerWidget {
  /// Creates the [TriageResultScreen].
  const TriageResultScreen({
    super.key,
    this.level = TriageLevel.emergency,
  });

  /// The determined triage urgency tier. Defaults to [TriageLevel.emergency] for fail-safe prototype.
  final TriageLevel level;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    final (badgeBg, badgeFg, levelTitle, levelSub) = switch (level) {
      TriageLevel.emergency => (
          AppColors.emergencyRedLight,
          AppColors.emergencyRed,
          strings.triageEmergency,
          'Immediate medical attention required',
        ),
      TriageLevel.seeClinicianToday => (
          AppColors.clinicianTodayAmberLight,
          AppColors.clinicianTodayAmber,
          strings.triageSeeClinicianToday,
          'Clinical assessment recommended within 24 hours',
        ),
      TriageLevel.homeCare => (
          AppColors.homeCareGreenLight,
          AppColors.homeCareGreen,
          strings.triageHomeCare,
          'Supportive care and monitoring safe at home',
        ),
    };

    return Scaffold(
      appBar: const OutpostAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.base),
              Text(
                strings.triageResultTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.lg),
              // Prominent Urgency Tier Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: badgeFg.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      level == TriageLevel.emergency
                          ? Icons.warning_amber_rounded
                          : Icons.verified_user_outlined,
                      size: 40,
                      color: badgeFg,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            levelTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: badgeFg,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            levelSub,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: badgeFg,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Clinical rationale section
              Text(
                strings.reasonHeading,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: AppColors.outlineBorder),
                ),
                child: Text(
                  'রেড-ফ্ল্যাগ পাওয়া গেছে: তীব্র শ্বাসকষ্ট ও শ্বাস নিতে সমস্যা। বিলম্ব না করে দ্রুততম সময়ে স্বাস্থ্যকেন্দ্রে নিয়ে যান।',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Guideline citation per rules.md rule 5
              Text(
                strings.guidelineSourceHeading,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: AppColors.outlineBorder),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 20,
                      color: AppColors.primaryTeal,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'WHO Pocket Book of Hospital Care for Children / IMCI Guideline 2024 (Section 3.2)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Emergency action button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emergencyRed,
                ),
                onPressed: () {
                  // Direct call simulation (e.g. 999 or regional helpline)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Calling National Emergency Service (999)...'),
                      backgroundColor: AppColors.emergencyRed,
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone_in_talk, color: AppColors.surfaceWhite),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      strings.btnCallEmergency,
                      style: const TextStyle(color: AppColors.surfaceWhite),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.mdCompact),
              // Find Nearest Facility button
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.nearestFacility);
                },
                child: Text(strings.btnFindFacility),
              ),
              const SizedBox(height: AppSpacing.sm),
              // Safety disclaimer notice
              Text(
                strings.triageDisclaimer,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
