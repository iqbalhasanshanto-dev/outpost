import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/triage_models.dart';
import '../../domain/triage/red_flag_engine.dart';
import '../../l10n/app_strings.dart';
import '../state/language_provider.dart';
import '../state/triage_provider.dart';
import '../widgets/offline_status_banner.dart';
import '../widgets/outpost_app_bar.dart';

/// Guided 3-step clinical follow-up flow matching Figma frames 04, 05, and 06.
///
/// Steps through:
/// - Step 1: Duration (`Today`, `1–2 days`, `3+ days`)
/// - Step 2: Severity (`Mild`, `Moderate`, `Severe`)
/// - Step 3: Danger Signs Checklist (from the 9 red-flag rules, plus "Unsure" and "None" options)
class FollowUpScreen extends ConsumerStatefulWidget {
  /// Creates the [FollowUpScreen].
  const FollowUpScreen({super.key});

  @override
  ConsumerState<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends ConsumerState<FollowUpScreen> {
  int _currentStep = 0; // 0: Duration, 1: Severity, 2: Danger Signs

  late SymptomDuration _duration;
  late SymptomSeverity _severity;
  final Set<String> _selectedDangerSigns = <String>{};
  bool _isUnsure = false;

  @override
  void initState() {
    super.initState();
    final triageState = ref.read(triageProvider);
    _duration = triageState.followUpAnswers.duration;
    _severity = triageState.followUpAnswers.severity;
    _selectedDangerSigns.addAll(triageState.followUpAnswers.dangerSigns);
  }

  void _syncState() {
    ref.read(triageProvider.notifier).setFollowUpAnswers(
          FollowUpAnswers(
            duration: _duration,
            severity: _severity,
            dangerSigns: _isUnsure
                ? {..._selectedDangerSigns, 'unsure_danger_signs'}
                : _selectedDangerSigns,
          ),
        );
  }

  void _nextStep() {
    _syncState();
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      // Final step: evaluate and navigate to result
      ref.read(triageProvider.notifier).evaluateTriage();
      Navigator.of(context).pushNamed(AppRoutes.triageResult);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);
    final activeLanguage = ref.watch(languageProvider);
    final forWhom = ref.watch(triageProvider).forWhom;
    final isBangla = activeLanguage == AppLanguage.bn;

    // Filter red-flag rules applicable to current patient category
    final applicableRules = RedFlagEngine.rules.where((rule) {
      return rule.applicableForWhom == null || rule.applicableForWhom == forWhom;
    }).toList();

    return PopScope(
      canPop: _currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _currentStep > 0) {
          _previousStep();
        }
      },
      child: Scaffold(
        appBar: OutpostAppBar(
          showBackButton: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xs),
                const Center(child: OfflineStatusBanner(compact: true)),
                const SizedBox(height: AppSpacing.base),

                // Question progress track matching Figma frames 04, 05, 06
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      strings.questionProgress(_currentStep + 1, 3),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${((_currentStep + 1) / 3 * 100).toInt()}%',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                LinearProgressIndicator(
                  value: (_currentStep + 1) / 3,
                  backgroundColor: AppColors.outlineBorder.withValues(alpha: 0.5),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primaryTeal,
                  ),
                  borderRadius: AppSpacing.badgeBorderRadius,
                  minHeight: 6,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Step Content
                Expanded(
                  child: SingleChildScrollView(
                    child: switch (_currentStep) {
                      0 => _buildDurationStep(strings),
                      1 => _buildSeverityStep(strings),
                      _ => _buildDangerSignsStep(
                          strings, applicableRules, isBangla),
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Bottom Navigation (Back and Next buttons)
                Row(
                  children: [
                    if (_currentStep > 0) ...[
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          child: Text(strings.btnBack),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                    ],
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _nextStep,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentStep == 2
                                  ? (isBangla ? 'ফলাফল দেখুন' : 'See Result')
                                  : strings.btnNext,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(Icons.arrow_forward_rounded),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.base),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Step 1: Duration (Figma 04 · Duration) ---
  Widget _buildDurationStep(AppStrings strings) {
    final durationOptions = [
      (
        value: SymptomDuration.today,
        title: strings.durationToday,
        subtitle: 'Began today (< 24 hours)',
        icon: Icons.today_rounded,
      ),
      (
        value: SymptomDuration.oneToTwoDays,
        title: strings.durationOneToTwo,
        subtitle: '1 to 2 days ongoing',
        icon: Icons.calendar_view_day_rounded,
      ),
      (
        value: SymptomDuration.threePlusDays,
        title: strings.durationThreePlus,
        subtitle: '3 or more days persistent',
        icon: Icons.date_range_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.howLongHappening,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'How long has this symptom been present?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...durationOptions.map((opt) {
          final isSelected = _duration == opt.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _SelectionOptionCard(
              title: opt.title,
              subtitle: opt.subtitle,
              icon: opt.icon,
              isSelected: isSelected,
              onTap: () => setState(() => _duration = opt.value),
            ),
          );
        }),
      ],
    );
  }

  // --- Step 2: Severity (Figma 05 · Severity) ---
  Widget _buildSeverityStep(AppStrings strings) {
    final severityOptions = [
      (
        value: SymptomSeverity.mild,
        title: strings.severityMild,
        subtitle: 'Can perform daily activities and eat/drink normally',
        icon: Icons.sentiment_satisfied_rounded,
        color: AppColors.homeCareGreen,
      ),
      (
        value: SymptomSeverity.moderate,
        title: strings.severityModerate,
        subtitle: 'Noticeable discomfort, difficulty with usual routine',
        icon: Icons.sentiment_neutral_rounded,
        color: AppColors.clinicianTodayAmber,
      ),
      (
        value: SymptomSeverity.severe,
        title: strings.severitySevere,
        subtitle: 'Severe distress, bedridden or unable to cope',
        icon: Icons.sentiment_very_dissatisfied_rounded,
        color: AppColors.emergencyRed,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.howSevereFeels,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'How severe does it feel to the patient?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        ...severityOptions.map((opt) {
          final isSelected = _severity == opt.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _SelectionOptionCard(
              title: opt.title,
              subtitle: opt.subtitle,
              icon: opt.icon,
              accentColor: opt.color,
              isSelected: isSelected,
              onTap: () => setState(() => _severity = opt.value),
            ),
          );
        }),
      ],
    );
  }

  // --- Step 3: Danger Signs Checklist (Figma 06 · Danger signs) ---
  Widget _buildDangerSignsStep(
    AppStrings strings,
    List<RedFlagRule> rules,
    bool isBangla,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.areDangerSignsPresent,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          strings.dangerSignsGuidance,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.emergencyRed,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Prominent "None of these" and "Unsure" safety quick-picks
        Row(
          children: [
            Expanded(
              child: InkWell(
                borderRadius: AppSpacing.cardBorderRadius,
                onTap: () {
                  setState(() {
                    _isUnsure = false;
                    _selectedDangerSigns.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.mdCompact,
                  ),
                  decoration: BoxDecoration(
                    color: (!_isUnsure && _selectedDangerSigns.isEmpty)
                        ? AppColors.primaryLight
                        : AppColors.surfaceCard,
                    borderRadius: AppSpacing.cardBorderRadius,
                    border: Border.all(
                      color: (!_isUnsure && _selectedDangerSigns.isEmpty)
                          ? AppColors.primaryTeal
                          : AppColors.outlineBorder,
                      width: (!_isUnsure && _selectedDangerSigns.isEmpty) ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: (!_isUnsure && _selectedDangerSigns.isEmpty)
                            ? AppColors.primaryTeal
                            : AppColors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.dangerSignNoneOption,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: (!_isUnsure && _selectedDangerSigns.isEmpty)
                                  ? AppColors.primaryTeal
                                  : AppColors.textPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: InkWell(
                borderRadius: AppSpacing.cardBorderRadius,
                onTap: () {
                  setState(() {
                    _isUnsure = true;
                    _selectedDangerSigns.clear();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.mdCompact,
                  ),
                  decoration: BoxDecoration(
                    color: _isUnsure
                        ? AppColors.clinicianTodayAmberLight
                        : AppColors.surfaceCard,
                    borderRadius: AppSpacing.cardBorderRadius,
                    border: Border.all(
                      color: _isUnsure
                          ? AppColors.clinicianTodayAmber
                          : AppColors.outlineBorder,
                      width: _isUnsure ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        color: _isUnsure
                            ? AppColors.clinicianTodayAmber
                            : AppColors.textSecondary,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.dangerSignUnsureOption,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _isUnsure
                                  ? AppColors.clinicianTodayAmber
                                  : AppColors.textPrimary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.base),

        // List of specific red-flag danger signs
        ...rules.map((rule) {
          final isChecked = _selectedDangerSigns.contains(rule.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              borderRadius: AppSpacing.cardBorderRadius,
              onTap: () {
                setState(() {
                  _isUnsure = false;
                  if (isChecked) {
                    _selectedDangerSigns.remove(rule.id);
                  } else {
                    _selectedDangerSigns.add(rule.id);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isChecked
                      ? AppColors.emergencyRedLight
                      : AppColors.surfaceCard,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(
                    color: isChecked
                        ? AppColors.emergencyRed
                        : AppColors.outlineBorder,
                    width: isChecked ? 2 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isChecked
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded,
                      color: isChecked
                          ? AppColors.emergencyRed
                          : AppColors.textSecondary,
                      size: 22,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isBangla ? rule.titleBn : rule.titleEn,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: isChecked
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isChecked
                                      ? AppColors.emergencyRed
                                      : AppColors.textPrimary,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            rule.guidelineSource,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

/// Generic card widget for single-select choices (duration, severity).
class _SelectionOptionCard extends StatelessWidget {
  const _SelectionOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.accentColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final activeColor = accentColor ?? AppColors.primaryTeal;

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.cardBorderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: AppSpacing.buttonHeight + 10,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (accentColor != null
                  ? accentColor!.withValues(alpha: 0.12)
                  : AppColors.primaryLight)
              : AppColors.surfaceCard,
          borderRadius: AppSpacing.cardBorderRadius,
          border: Border.all(
            color: isSelected ? activeColor : AppColors.outlineBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? activeColor : AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: isSelected ? activeColor : AppColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: isSelected ? activeColor : AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
