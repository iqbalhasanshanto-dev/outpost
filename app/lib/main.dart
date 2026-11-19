import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/follow_up_screen.dart';
import 'presentation/screens/nearest_facility_screen.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/symptom_intake_screen.dart';
import 'presentation/screens/triage_result_screen.dart';
import 'presentation/screens/who_for_screen.dart';
import 'presentation/state/language_provider.dart';

/// Main application entry point for Outpost.
///
/// Initializes the root [ProviderScope] to enable Riverpod state management
/// and boots the Flutter widget hierarchy.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: OutpostApp(),
    ),
  );
}

/// Root application widget for Outpost.
///
/// Reactively adapts to the active [AppLanguage] managed by [languageProvider],
/// applies the design-system [AppTheme.lightTheme], and registers named routes
/// for the Phase 1 clinical prototype flow.
class OutpostApp extends ConsumerWidget {
  /// Creates the [OutpostApp].
  const OutpostApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLanguage = ref.watch(languageProvider);

    return MaterialApp(
      title: 'Outpost',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: Locale(activeLanguage.code),
      supportedLocales: const [
        Locale('bn'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.whoFor: (context) => const WhoForScreen(),
        AppRoutes.symptomIntake: (context) => const SymptomIntakeScreen(),
        AppRoutes.followUp: (context) => const FollowUpScreen(),
        AppRoutes.triageResult: (context) => const TriageResultScreen(),
        AppRoutes.nearestFacility: (context) => const NearestFacilityScreen(),
      },
    );
  }
}
