import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';
import '../state/triage_provider.dart';
import '../widgets/offline_status_banner.dart';
import '../widgets/outpost_app_bar.dart';

/// Screen allowing the user to select who requires clinical assessment.
///
/// Designed per Figma frame "02 · Who needs care". Differentiates
/// triage protocols between general adults, pediatric IMCI (infant/child),
/// and maternal obstetric danger signs.
class WhoForScreen extends ConsumerWidget {
  /// Creates the [WhoForScreen].
  const WhoForScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final triageState = ref.watch(triageProvider);

    void selectCategory(ForWhom forWhom) {
      ref.read(triageProvider.notifier).setForWhom(forWhom);
      Navigator.of(context).pushNamed(AppRoutes.symptomIntake);
    }

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
              // Page Heading
              Text(
                strings.whoNeedsCareTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.whoNeedsCareSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Option 1: Myself
              _WhoForCard(
                icon: Icons.person_outline_rounded,
                title: strings.forMyself,
                subtitle: 'Myself (Adult)',
                isSelected: triageState.forWhom == ForWhom.myself,
                onTap: () => selectCategory(ForWhom.myself),
              ),
              const SizedBox(height: AppSpacing.md),

              // Option 2: Child (IMCI)
              _WhoForCard(
                icon: Icons.child_care_rounded,
                title: strings.forChild,
                subtitle: 'My child (Infant or under 5)',
                isSelected: triageState.forWhom == ForWhom.child,
                onTap: () => selectCategory(ForWhom.child),
              ),
              const SizedBox(height: AppSpacing.md),

              // Option 3: Someone Pregnant (Maternal health)
              _WhoForCard(
                icon: Icons.pregnant_woman_rounded,
                title: strings.forPregnant,
                subtitle: 'Someone pregnant (Maternal signs)',
                isSelected: triageState.forWhom == ForWhom.pregnant,
                onTap: () => selectCategory(ForWhom.pregnant),
              ),

              const Spacer(),

              // Privacy reassurance banner
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppSpacing.cardBorderRadius,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 22,
                      color: AppColors.primaryTeal,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.privacyReassurance,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.primaryTeal,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            strings.privacySub,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
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

/// Large accessible option card for [ForWhom] selection.
class _WhoForCard extends StatelessWidget {
  const _WhoForCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.cardBorderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: AppSpacing.cardHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surfaceCard,
          borderRadius: AppSpacing.cardBorderRadius,
          border: Border.all(
            color: isSelected ? AppColors.primaryTeal : AppColors.outlineBorder,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.surfaceWhite
                    : AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppColors.primaryTeal,
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.chevron_right_rounded,
              color: isSelected
                  ? AppColors.primaryTeal
                  : AppColors.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
