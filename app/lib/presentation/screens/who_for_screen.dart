import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';
import '../widgets/outpost_app_bar.dart';

/// Screen allowing the user to select who requires clinical assessment.
///
/// Corresponds to Figma frame "02 · Who needs care". Differentiates
/// triage protocols between general adults, pediatric IMCI (infant/child),
/// and maternal obstetric danger signs.
class WhoForScreen extends ConsumerStatefulWidget {
  /// Creates the [WhoForScreen].
  const WhoForScreen({super.key});

  @override
  ConsumerState<WhoForScreen> createState() => _WhoForScreenState();
}

class _WhoForScreenState extends ConsumerState<WhoForScreen> {
  ForWhom _selected = ForWhom.myself;

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
                icon: Icons.person_outline,
                title: strings.forMyself,
                subtitle: 'Myself',
                isSelected: _selected == ForWhom.myself,
                onTap: () {
                  setState(() => _selected = ForWhom.myself);
                  Navigator.of(context).pushNamed(AppRoutes.symptomIntake);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Option 2: Child (IMCI)
              _WhoForCard(
                icon: Icons.child_care_outlined,
                title: strings.forChild,
                subtitle: 'My child',
                isSelected: _selected == ForWhom.child,
                onTap: () {
                  setState(() => _selected = ForWhom.child);
                  Navigator.of(context).pushNamed(AppRoutes.symptomIntake);
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Option 3: Pregnant woman (Maternal health)
              _WhoForCard(
                icon: Icons.pregnant_woman_outlined,
                title: strings.forPregnant,
                subtitle: 'Pregnant woman',
                isSelected: _selected == ForWhom.pregnant,
                onTap: () {
                  setState(() => _selected = ForWhom.pregnant);
                  Navigator.of(context).pushNamed(AppRoutes.symptomIntake);
                },
              ),
              const Spacer(),
              // Privacy reassurance banner
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppSpacing.cardBorderRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.privacyReassurance,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      strings.privacySub,
                      style: Theme.of(context).textTheme.bodySmall,
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

/// Card component representing an individual [ForWhom] selection option.
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
      child: Container(
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
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primaryTeal : AppColors.textPrimary,
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
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
