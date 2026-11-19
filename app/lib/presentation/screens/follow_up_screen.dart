import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';
import '../widgets/outpost_app_bar.dart';

/// Screen presenting deterministic clinical follow-up questions.
///
/// Steps through danger signs (e.g., inability to drink, convulsions, chest indrawing)
/// to evaluate whether red-flag safety rules trigger immediate emergency escalation.
class FollowUpScreen extends ConsumerStatefulWidget {
  /// Creates the [FollowUpScreen].
  const FollowUpScreen({super.key});

  @override
  ConsumerState<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends ConsumerState<FollowUpScreen> {
  int _selectedAnswerIndex = -1;

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(stringsProvider);

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
                strings.followUpTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.followUpSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xl),
              // Sample follow-up clinical question card
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: AppSpacing.cardBorderRadius,
                  border: Border.all(color: AppColors.outlineBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: AppSpacing.badgeBorderRadius,
                      ),
                      child: Text(
                        '1 of 3',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'শ্বাস নিতে কি তীব্র কষ্ট হচ্ছে বা বুক দেবে যাচ্ছে?',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Is there severe chest indrawing or inability to speak full sentences?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              // Answer buttons (Yes, No, Unsure)
              _AnswerButton(
                labelBn: strings.answerYes,
                labelEn: 'Yes (Danger sign present)',
                isSelected: _selectedAnswerIndex == 0,
                onTap: () => setState(() => _selectedAnswerIndex = 0),
              ),
              const SizedBox(height: AppSpacing.mdCompact),
              _AnswerButton(
                labelBn: strings.answerNo,
                labelEn: 'No (None observed)',
                isSelected: _selectedAnswerIndex == 1,
                onTap: () => setState(() => _selectedAnswerIndex = 1),
              ),
              const SizedBox(height: AppSpacing.mdCompact),
              _AnswerButton(
                labelBn: strings.answerUnsure,
                labelEn: 'Not sure / Unclear',
                isSelected: _selectedAnswerIndex == 2,
                onTap: () => setState(() => _selectedAnswerIndex = 2),
              ),
              const Spacer(),
              // Navigation button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.triageResult);
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

/// Standard full-width answer option button per Outpost design guidelines.
class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.labelBn,
    required this.labelEn,
    required this.isSelected,
    required this.onTap,
  });

  final String labelBn;
  final String labelEn;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.cardBorderRadius,
      child: Container(
        height: AppSpacing.buttonHeight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surfaceWhite,
          borderRadius: AppSpacing.cardBorderRadius,
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.outlineBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelBn,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    labelEn,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryTeal)
            else
              const Icon(Icons.circle_outlined, color: AppColors.outlineBorder),
          ],
        ),
      ),
    );
  }
}
