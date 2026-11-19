import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/triage/triage_engine.dart';
import '../../l10n/app_strings.dart';
import '../state/language_provider.dart';
import '../state/triage_provider.dart';
import '../widgets/offline_status_banner.dart';
import '../widgets/outpost_app_bar.dart';
import '../widgets/triage_badge.dart';

/// Screen presenting the clinical urgency classification and next steps.
///
/// Implements Figma frames 07 (Emergency), 08 (Clinician today), 09 (Home care),
/// and 17 (Emergency 999 call sheet). Features:
/// - Distinct [TriageBadge] header.
/// - Plain-language clinical rationale.
/// - WHO guideline citation card (source + specific section).
/// - Non-medicinal home care supportive steps (if home care).
/// - Prominent Call Emergency (999) action + Find Nearest Clinic action.
/// - "Start New Check" demo reset action.
class TriageResultScreen extends ConsumerWidget {
  /// Creates the [TriageResultScreen].
  const TriageResultScreen({super.key});

  void _showEmergencyCallSheet(BuildContext context, AppStrings strings) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusCard),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: const BoxDecoration(
                        color: AppColors.emergencyRedLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone_in_talk_rounded,
                        color: AppColors.emergencyRed,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        strings.emergencyCallSheetTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  strings.emergencyCallSheetNotice,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emergencyRed,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Simulated opening tel:999 in device dialer'),
                        backgroundColor: AppColors.emergencyRed,
                      ),
                    );
                  },
                  child: Text(
                    strings.emergencyCallConfirm,
                    style: const TextStyle(color: AppColors.surfaceWhite),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(strings.emergencyCallDismiss),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
              const SizedBox(height: AppSpacing.xs),
              const Center(child: OfflineStatusBanner(compact: true)),
              const SizedBox(height: AppSpacing.base),

              // Urgency Badge Header Card (Figma 07, 08, 09)
              TriageBadge(level: result.level),

              const SizedBox(height: AppSpacing.lg),

              // Clinical Rationale Section
              Text(
                strings.reasonHeading,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                        height: 1.4,
                      ),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // WHO Guideline Citation Card (per rules.md safety boundary 5)
              Text(
                strings.guidelineSourceHeading,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                      Icons.menu_book_rounded,
                      size: 22,
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
                          const SizedBox(height: 3),
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

              // Safe Home Care Guidance (if Home Care)
              if (result.level == TriageLevel.homeCare) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  strings.selfCareStepsHeading,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                    children: [
                      ...result.selfCareSteps.map(
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
                      ),
                      const Divider(height: 16),
                      Text(
                        strings.warningSignsWatchHeading,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.homeCareGreen,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isBangla
                            ? 'তীব্র শ্বাসকষ্ট, খাওয়ায় অক্ষমতা বা অতিরিক্ত দুর্বলতা দেখা দিলে সাথে সাথে হাসপাতালে যান।'
                            : 'If breathing difficulty, inability to drink, or severe weakness develops, seek emergency care immediately.',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),

              // Emergency 999 Button (Prominent for Emergency, also accessible for others)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emergencyRed,
                ),
                onPressed: () => _showEmergencyCallSheet(context, strings),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.phone_in_talk_rounded,
                      color: AppColors.surfaceWhite,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      strings.btnCallEmergency,
                      style: const TextStyle(
                        color: AppColors.surfaceWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Find Nearest Clinic Button
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.nearestFacility);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_hospital_outlined,
                      color: AppColors.primaryTeal,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(strings.btnFindFacility),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              // Reset / Start New Check Button
              TextButton(
                onPressed: () {
                  ref.read(triageProvider.notifier).reset();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.splash,
                    (route) => false,
                  );
                },
                child: Text(
                  strings.startNewCheck,
                  style: const TextStyle(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              // Safety Disclaimer per rules.md
              Text(
                strings.triageDisclaimer,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }
}
