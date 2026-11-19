import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/triage/triage_engine.dart';
import '../state/language_provider.dart';
import '../state/triage_provider.dart';
import '../widgets/outpost_app_bar.dart';

/// Screen presenting the clinical urgency classification and next steps.
///
/// Implements safety boundaries per rules.md:
/// - Displays one of three discrete triage tiers ([TriageLevel]).
/// - Shows guideline citation and deterministic reasoning.
/// - Includes mandatory disclaimer and direct "Call emergency" action.
class TriageResultScreen extends ConsumerWidget {
  /// Creates the [TriageResultScreen].
  const TriageResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final activeLanguage = ref.watch(languageProvider);
    final triageState = ref.watch(triageProvider);

    // If result was not pre-computed, evaluate on the fly safely
    final result = triageState.result ??
        const TriageEngine().evaluate(
          forWhom: triageState.forWhom,
          symptoms: triageState.selectedSymptoms,
          answers: triageState.followUpAnswers,
        );

    final (badgeBg, badgeFg, levelTitle, levelSub) = switch (result.level) {
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

    final isBangla = activeLanguage == AppLanguage.bn;
    final reasonText = isBangla ? result.reasonBn : result.reasonEn;

    return Scaffold(
      appBar: const OutpostAppBar(showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      result.level == TriageLevel.emergency
                          ? Icons.warning_amber_rounded
                          : result.level == TriageLevel.seeClinicianToday
                              ? Icons.schedule
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
                  reasonText,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.menu_book_outlined,
                      size: 20,
                      color: AppColors.primaryTeal,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.guidelineSource,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            result.sectionCitation,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Non-medicinal home care supportive steps (if home care)
              if (result.selfCareSteps.isNotEmpty &&
                  result.level == TriageLevel.homeCare) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'নিরাপদ প্রাথমিক যত্ন · Safe Self-Care Steps',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.homeCareGreenLight,
                    borderRadius: AppSpacing.cardBorderRadius,
                    border: Border.all(
                      color: AppColors.homeCareGreen.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: result.selfCareSteps
                        .map(
                          (step) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '• ',
                                  style: TextStyle(
                                    color: AppColors.homeCareGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppColors.textPrimary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.xl),

              // Emergency action button (prominent if emergency or always available for safety)
              if (result.level == TriageLevel.emergency) ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emergencyRed,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Calling National Emergency Service (999)...'),
                        backgroundColor: AppColors.emergencyRed,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.phone_in_talk,
                          color: AppColors.surfaceWhite),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        strings.btnCallEmergency,
                        style: const TextStyle(color: AppColors.surfaceWhite),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.mdCompact),
              ],

              // Find Nearest Facility button
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.nearestFacility);
                },
                child: Text(strings.btnFindFacility),
              ),

              const SizedBox(height: AppSpacing.md),

              // Safety disclaimer notice per rules.md
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
