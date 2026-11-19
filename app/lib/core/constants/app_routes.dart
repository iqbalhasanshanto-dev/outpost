/// Route constants for named-route navigation throughout Outpost.
abstract final class AppRoutes {
  /// Initial landing screen: Splash & Language selection.
  static const String splash = '/';

  /// Patient categorization screen (Myself, Child, Pregnant).
  static const String whoFor = '/who-for';

  /// Symptom intake and selection grid screen.
  static const String symptomIntake = '/intake';

  /// Deterministic red-flag and clinical follow-up questions screen.
  static const String followUp = '/follow-up';

  /// Urgency determination result screen (Emergency, See Clinician, Home Care).
  static const String triageResult = '/result';

  /// Offline cached map and nearest health facilities list screen.
  static const String nearestFacility = '/facility';
}
