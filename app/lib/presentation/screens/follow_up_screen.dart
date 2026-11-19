import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/triage_models.dart';
import '../state/language_provider.dart';
import '../state/triage_provider.dart';
import '../widgets/outpost_app_bar.dart';

/// Screen presenting clinical follow-up questions (duration, severity, danger signs).
///
/// Evaluates whether danger signs or prolonged high severity trigger immediate
/// emergency or same-day clinical escalation.
class FollowUpScreen extends ConsumerStatefulWidget {
  /// Creates the [FollowUpScreen].
  const FollowUpScreen({super.key});

  @override
  ConsumerState<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends ConsumerState<FollowUpScreen> {
  SymptomDuration _duration = SymptomDuration.today;
  SymptomSeverity _severity = SymptomSeverity.mild;
  bool _hasDangerSign = false;

  @override
  void initState() {
    super.initState();
    final triageState = ref.read(triageProvider);
    _duration = triageState.followUpAnswers.duration;
    _severity = triageState.followUpAnswers.severity;
    _hasDangerSign = triageState.followUpAnswers.hasDangerSigns;
  }

  void _onProceed() {
    final dangerSigns = <String>{};
    if (_hasDangerSign) {
      // Add a general danger sign identifier based on patient category
      final forWhom = ref.read(triageProvider).forWhom;
      if (forWhom == ForWhom.child) {
        dangerSigns.add('unable_to_drink_or_breastfeed');
      } else if (forWhom == ForWhom.pregnant) {
        dangerSigns.add('pregnancy_severe_abdominal_pain_or_bleeding');
      } else {
        dangerSigns.add('severe_difficulty_breathing');
      }
    }

    ref.read(triageProvider.notifier).setFollowUpAnswers(
          FollowUpAnswers(
            duration: _duration,
            severity: _severity,
            dangerSigns: dangerSigns,
          ),
        );

    // Run deterministic triage pipeline
    ref.read(triageProvider.notifier).evaluateTriage();
    Navigator.of(context).pushNamed(AppRoutes.triageResult);
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);

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
                strings.followUpTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.followUpSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Question 1: Duration
              Text(
                '১. কতদিন ধরে এই সমস্যা হচ্ছে? · Duration',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: SymptomDuration.values.map((d) {
                  final isSelected = _duration == d;
                  return ChoiceChip(
                    label: Text(d.label),
                    selected: isSelected,
                    selectedColor: AppColors.primaryLight,
                    backgroundColor: AppColors.surfaceCard,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primaryTeal
                          : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _duration = d);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Question 2: Severity
              Text(
                '২. সমস্যাটির তীব্রতা কেমন? · Severity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                children: SymptomSeverity.values.map((s) {
                  final isSelected = _severity == s;
                  return ChoiceChip(
                    label: Text(s.label),
                    selected: isSelected,
                    selectedColor: s == SymptomSeverity.severe
                        ? AppColors.emergencyRedLight
                        : AppColors.primaryLight,
                    backgroundColor: AppColors.surfaceCard,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? (s == SymptomSeverity.severe
                              ? AppColors.emergencyRed
                              : AppColors.primaryTeal)
                          : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _severity = s);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Question 3: Red-flag danger sign check
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: _hasDangerSign
                      ? AppColors.emergencyRedLight
                      : AppColors.surfaceCard,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(
                    color: _hasDangerSign
                        ? AppColors.emergencyRed
                        : AppColors.outlineBorder,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: _hasDangerSign
                              ? AppColors.emergencyRed
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            '৩. কোনো জরুরি বিপদচিহ্ন আছে কি?',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _hasDangerSign
                                      ? AppColors.emergencyRed
                                      : AppColors.textPrimary,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'যেমন: প্রচণ্ড শ্বাসকষ্ট, বুকে তীব্র ব্যথা, খিঁচুনি, অজ্ঞান হওয়া, বা তরল পান করতে না পারা।',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: _hasDangerSign
                                  ? AppColors.emergencyRed
                                  : AppColors.surfaceWhite,
                              foregroundColor: _hasDangerSign
                                  ? AppColors.surfaceWhite
                                  : AppColors.textPrimary,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            onPressed: () =>
                                setState(() => _hasDangerSign = true),
                            child: Text(
                              '${strings.answerYes} (বিপদচিহ্ন আছে)',
                              style: TextStyle(
                                fontSize: 14,
                                color: _hasDangerSign
                                    ? AppColors.surfaceWhite
                                    : AppColors.emergencyRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: !_hasDangerSign
                                  ? AppColors.primaryTeal
                                  : AppColors.surfaceWhite,
                              foregroundColor: !_hasDangerSign
                                  ? AppColors.surfaceWhite
                                  : AppColors.textPrimary,
                              minimumSize: const Size.fromHeight(48),
                            ),
                            onPressed: () =>
                                setState(() => _hasDangerSign = false),
                            child: Text(
                              '${strings.answerNo} (নেই)',
                              style: TextStyle(
                                fontSize: 14,
                                color: !_hasDangerSign
                                    ? AppColors.surfaceWhite
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Proceed button
              ElevatedButton(
                onPressed: _onProceed,
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
