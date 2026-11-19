/// Core enums for the Outpost clinical triage prototype.
///
/// These enums define the target patient category, triage severity levels,
/// and supported app languages across Phase 1 and beyond.
library;

/// Represents who the intake assessment is being performed for.
///
/// Maps directly to clinical risk stratifications (e.g., pediatric IMCI
/// vs. maternal danger signs vs. general adult red flags).
enum ForWhom {
  /// Intake is for the user themselves (adult/general).
  myself,

  /// Intake is for an infant or young child (triggers IMCI guidelines).
  child,

  /// Intake is for a pregnant woman (triggers maternal obstetric guidelines).
  pregnant,
}

/// Represents the triage urgency determination level.
///
/// The triage pipeline categorizes patients into exactly one of these
/// three deterministic severity tiers.
enum TriageLevel {
  /// Red-flag danger sign detected; requires immediate referral to emergency care.
  emergency,

  /// Moderate urgency or clinical uncertainty; requires clinical evaluation today.
  seeClinicianToday,

  /// Mild/self-limiting symptoms; safe for supportive home care and monitoring.
  homeCare,
}

/// Supported app localization languages.
enum AppLanguage {
  /// Bangla (Bengali) - default language for local field operations.
  bn('bn', 'বাংলা'),

  /// English - alternative language for bilingual display and review.
  en('en', 'English');

  /// Creates an [AppLanguage] with its ISO 639-1 language code and native name.
  const AppLanguage(this.code, this.nativeName);

  /// ISO 639-1 two-letter language code (e.g., 'bn', 'en').
  final String code;

  /// Native display name for the language switcher.
  final String nativeName;
}
