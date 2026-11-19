import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_routes.dart';
import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';

/// Initial entry screen: Splash & Language Selection.
///
/// Designed per Figma frame "01 · Welcome". Welcomes the user, explains
/// offline functionality, and allows choosing between Bangla and English
/// before beginning the triage intake flow.
class SplashScreen extends ConsumerWidget {
  /// Creates the [SplashScreen].
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),
              // Welcome Hero section matching Figma 01 · Welcome
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
                strings.appTagline,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Care, even without a signal',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              // Language selection prompt
              Text(
                strings.chooseLanguageTitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppSpacing.mdCompact),
              // Continue in Bangla button
              ElevatedButton(
                onPressed: () {
                  ref.read(languageProvider.notifier).setLanguage(AppLanguage.bn);
                  Navigator.of(context).pushNamed(AppRoutes.whoFor);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'বাংলা',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.surfaceWhite,
                          ),
                    ),
                    Text(
                      strings.continueInBangla,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.surfaceWhite.withValues(alpha: 0.9),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.mdCompact),
              // Continue in English button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.primaryLight,
                  side: BorderSide.none,
                ),
                onPressed: () {
                  ref.read(languageProvider.notifier).setLanguage(AppLanguage.en);
                  Navigator.of(context).pushNamed(AppRoutes.whoFor);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'English',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: AppColors.primaryTeal,
                          ),
                    ),
                    Text(
                      strings.continueInEnglish,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryTeal,
                          ),
                    ),
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
