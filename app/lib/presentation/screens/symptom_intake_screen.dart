import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';
import '../state/triage_provider.dart';
import '../widgets/offline_status_banner.dart';
import '../widgets/outpost_app_bar.dart';
import '../widgets/symptom_card.dart';

/// Symptom intake and icon selection grid screen.
///
/// Designed per Figma frame "03 · Choose a symptom". Provides an accessible,
/// low-literacy icon grid covering the 8 primary clinical categories, with
/// multi-select support and a transparent Phase 5 Voice indicator.
class SymptomIntakeScreen extends ConsumerWidget {
  /// Creates the [SymptomIntakeScreen].
  const SymptomIntakeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final triageState = ref.watch(triageProvider);
    final selectedSymptoms = triageState.selectedSymptoms;

    // 8 core symptom categories matching Figma 03 · Symptoms
    final symptomsList = [
      (
        id: 'fever',
        label: strings.symptomFever,
        icon: Icons.thermostat_rounded,
      ),
      (
        id: 'breathing',
        label: strings.symptomCoughBreathing,
        icon: Icons.air_rounded,
      ),
      (
        id: 'chest_pain',
        label: strings.symptomChestPain,
        icon: Icons.favorite_rounded,
      ),
      (
        id: 'bleeding',
        label: strings.symptomBleeding,
        icon: Icons.water_drop_rounded,
      ),
      (
        id: 'stomach',
        label: strings.symptomStomach,
        icon: Icons.sentiment_dissatisfied_rounded,
      ),
      (
        id: 'headache',
        label: strings.symptomHeadache,
        icon: Icons.psychology_rounded,
      ),
      (
        id: 'diarrhea',
        label: strings.symptomVomitingDiarrhea,
        icon: Icons.waves_rounded,
      ),
      (
        id: 'pregnancy',
        label: strings.symptomPregnancy,
        icon: Icons.pregnant_woman_rounded,
      ),
    ];

    return Scaffold(
      appBar: const OutpostAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xs),
              const Center(child: OfflineStatusBanner(compact: true)),
              const SizedBox(height: AppSpacing.base),
              Text(
                strings.symptomsTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.symptomsSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),

              // Voice (Phase 5) disabled status chip matching Figma design
              InkWell(
                borderRadius: AppSpacing.cardBorderRadius,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(strings.voiceIntakePrompt),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: AppSpacing.cardBorderRadius,
                    border: Border.all(color: AppColors.outlineBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xs),
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mic_none_rounded,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          strings.voicePhase5Chip,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      const Icon(
                        Icons.lock_clock_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.base),

              // 8-item Icon-based Symptom Grid (2 columns for large, readable tap targets)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.mdCompact,
                    crossAxisSpacing: AppSpacing.mdCompact,
                    childAspectRatio: 1.35,
                  ),
                  itemCount: symptomsList.length,
                  itemBuilder: (context, index) {
                    final item = symptomsList[index];
                    final isSelected = selectedSymptoms.contains(item.id);

                    return SymptomCard(
                      id: item.id,
                      label: item.label,
                      icon: item.icon,
                      isSelected: isSelected,
                      onTap: () {
                        ref
                            .read(triageProvider.notifier)
                            .toggleSymptom(item.id);
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              // Next navigation button
              ElevatedButton(
                onPressed: selectedSymptoms.isEmpty
                    ? () {
                        // Nudge user or allow continuing (which safely fails safe to clinician review)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ref.watch(languageProvider).code == 'bn'
                                  ? 'অন্তত একটি লক্ষণ নির্বাচন করুন'
                                  : 'Please select at least one symptom',
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    : () {
                        Navigator.of(context).pushNamed(AppRoutes.followUp);
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(strings.btnNext),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
