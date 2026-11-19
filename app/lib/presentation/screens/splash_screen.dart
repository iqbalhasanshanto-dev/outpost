import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';
import '../state/triage_provider.dart';
import '../widgets/offline_status_banner.dart';

/// Entry screen: Welcome and Language Selection.
///
/// Designed per Figma frame "01 · Welcome". Presents Outpost branding,
/// core one-line clinical purpose, offline-first assurance, and language choice.
class SplashScreen extends ConsumerWidget {
  /// Creates the [SplashScreen].
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);
    final activeLanguage = ref.watch(languageProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.sm),
              // Prominent offline-first indicator pill
              const OfflineStatusBanner(),
              const Spacer(),
              // Welcome hero section matching Figma 01 · Welcome
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppSpacing.heroIconBorderRadius,
                ),
                child: const Icon(
                  Icons.add,
                  size: 48,
                  color: AppColors.primaryTeal,
                ),
              ),
              const SizedBox(height: AppSpacing.mdCompact),
              Text(
                strings.appName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.appOneLineTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.appTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              // Language Selection Header
              Text(
                strings.chooseLanguageTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.mdCompact),
              // Bangla Language Selection Card
              InkWell(
                borderRadius: AppSpacing.cardBorderRadius,
                onTap: () {
                  ref.read(languageProvider.notifier).setLanguage(AppLanguage.bn);
                },
                child: Container(
                  height: AppSpacing.buttonHeight,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: activeLanguage == AppLanguage.bn
                        ? AppColors.primaryTeal
                        : AppColors.surfaceCard,
                    borderRadius: AppSpacing.cardBorderRadius,
                    border: Border.all(
                      color: activeLanguage == AppLanguage.bn
                          ? AppColors.primaryTeal
                          : AppColors.outlineBorder,
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
                              'বাংলা',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: activeLanguage == AppLanguage.bn
                                        ? AppColors.surfaceWhite
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              strings.continueInBangla,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: activeLanguage == AppLanguage.bn
                                        ? AppColors.surfaceWhite
                                            .withValues(alpha: 0.9)
                                        : AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (activeLanguage == AppLanguage.bn)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.surfaceWhite,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.mdCompact),
              // English Language Selection Card
              InkWell(
                borderRadius: AppSpacing.cardBorderRadius,
                onTap: () {
                  ref.read(languageProvider.notifier).setLanguage(AppLanguage.en);
                },
                child: Container(
                  height: AppSpacing.buttonHeight,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: activeLanguage == AppLanguage.en
                        ? AppColors.primaryTeal
                        : AppColors.surfaceCard,
                    borderRadius: AppSpacing.cardBorderRadius,
                    border: Border.all(
                      color: activeLanguage == AppLanguage.en
                          ? AppColors.primaryTeal
                          : AppColors.outlineBorder,
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
                              'English',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: activeLanguage == AppLanguage.en
                                        ? AppColors.surfaceWhite
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              strings.continueInEnglish,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: activeLanguage == AppLanguage.en
                                        ? AppColors.surfaceWhite
                                            .withValues(alpha: 0.9)
                                        : AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (activeLanguage == AppLanguage.en)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.surfaceWhite,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Start Intake Button
              ElevatedButton(
                onPressed: () {
                  ref.read(triageProvider.notifier).reset();
                  Navigator.of(context).pushNamed(AppRoutes.whoFor);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      activeLanguage == AppLanguage.bn
                          ? 'শুরু করুন · Start'
                          : 'Start Intake',
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    const Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              // Offline reassurance chip
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 14,
                    color: AppColors.primaryTeal,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    strings.securityNotice,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                strings.conceptDisclaimer,
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
