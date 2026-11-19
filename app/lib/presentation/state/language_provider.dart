import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/triage_enums.dart';
import '../../l10n/app_strings.dart';

/// Riverpod notifier managing the active application language state.
///
/// Defaults to Bangla ([AppLanguage.bn]) for rural and field-first usage.
/// Toggling or updating this notifier immediately re-evaluates all dependent
/// UI widgets across the application.
class LanguageNotifier extends Notifier<AppLanguage> {
  @override
  AppLanguage build() => AppLanguage.bn;

  /// Explicitly sets the active application [AppLanguage].
  void setLanguage(AppLanguage language) {
    state = language;
  }

  /// Toggles the language between Bangla and English.
  void toggleLanguage() {
    state = state == AppLanguage.bn ? AppLanguage.en : AppLanguage.bn;
  }
}

/// Global provider exposing the active [AppLanguage].
final languageProvider = NotifierProvider<LanguageNotifier, AppLanguage>(
  LanguageNotifier.new,
);

/// Convenience provider resolving localized strings for the active language.
///
/// Widgets can watch this provider using `ref.watch(stringsProvider)` to
/// retrieve reactive string translations without boilerplate.
final stringsProvider = Provider<AppStrings>((ref) {
  final language = ref.watch(languageProvider);
  return AppStrings.of(language);
});
