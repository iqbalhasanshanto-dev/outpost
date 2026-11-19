import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';
import '../state/triage_provider.dart';
import '../widgets/outpost_app_bar.dart';

/// Symptom intake and selection grid screen.
///
/// Corresponds to Figma frame "03 · Symptoms". Allows clinical officers
/// or community health workers to select primary reported symptoms either
/// via interactive tiles or simulated voice input.
class SymptomIntakeScreen extends ConsumerWidget {
  /// Creates the [SymptomIntakeScreen].
  const SymptomIntakeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final triageState = ref.watch(triageProvider);
    final selectedSymptoms = triageState.selectedSymptoms;

    final symptomsList = [
      (id: 'fever', label: strings.symptomFever, icon: Icons.thermostat_outlined),
      (id: 'cough', label: strings.symptomCough, icon: Icons.masks_outlined),
      (id: 'breathing', label: strings.symptomBreathing, icon: Icons.air_outlined),
      (id: 'chest_pain', label: strings.symptomChestPain, icon: Icons.favorite_border),
      (id: 'stomach', label: strings.symptomStomach, icon: Icons.sentiment_dissatisfied_outlined),
      (id: 'headache', label: strings.symptomHeadache, icon: Icons.psychology_outlined),
      (id: 'bleeding', label: strings.symptomBleeding, icon: Icons.water_drop_outlined),
      (id: 'diarrhea', label: strings.symptomDiarrhea, icon: Icons.waves_outlined),
      (id: 'injury', label: strings.symptomInjury, icon: Icons.healing_outlined),
      (id: 'rash', label: strings.symptomRash, icon: Icons.bubble_chart_outlined),
      (id: 'dizziness', label: strings.symptomDizziness, icon: Icons.blur_on_outlined),
      (id: 'other', label: strings.symptomOther, icon: Icons.more_horiz_outlined),
    ];

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
                strings.symptomsTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.symptomsSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              // Voice intake simulation banner
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: AppColors.outlineBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceWhite,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: AppColors.primaryTeal,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        strings.voiceIntakePrompt,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryTeal,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              // Symptoms Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSpacing.mdCompact,
                    crossAxisSpacing: AppSpacing.mdCompact,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: symptomsList.length,
                  itemBuilder: (context, index) {
                    final item = symptomsList[index];
                    final isSelected = selectedSymptoms.contains(item.id);

                    return InkWell(
                      onTap: () {
                        ref.read(triageProvider.notifier).toggleSymptom(item.id);
                      },
                      borderRadius: AppSpacing.cardBorderRadius,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryLight
                              : AppColors.surfaceCard,
                          borderRadius: AppSpacing.cardBorderRadius,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryTeal
                                : AppColors.outlineBorder,
                            width: isSelected ? 2.0 : 1.0,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              size: 26,
                              color: isSelected
                                  ? AppColors.primaryTeal
                                  : AppColors.textPrimary,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              item.label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontSize: 13,
                                    color: isSelected
                                        ? AppColors.primaryTeal
                                        : AppColors.textPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Next navigation button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.followUp);
                },
                child: Text(strings.btnNext),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
