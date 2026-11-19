import '../../core/constants/triage_enums.dart';

/// Duration range of reported symptoms.
enum SymptomDuration {
  /// Symptoms began today (< 24 hours).
  today('today', 'আজ শুরু হয়েছে · Started today'),

  /// Symptoms have persisted for 1 to 2 days.
  oneToTwoDays('1-2 days', '১-২ দিন ধরে · 1-2 days'),

  /// Symptoms have persisted for 3 or more days (prolonged course).
  threePlusDays('3+ days', '৩ দিন বা তার বেশি · 3+ days');

  const SymptomDuration(this.key, this.label);

  /// Normalized storage key.
  final String key;

  /// Bilingual display label.
  final String label;

  /// Parses a string key into [SymptomDuration], defaulting to [today].
  static SymptomDuration fromKey(String? key) {
    return switch (key) {
      '1-2 days' => SymptomDuration.oneToTwoDays,
      '3+ days' => SymptomDuration.threePlusDays,
      _ => SymptomDuration.today,
    };
  }
}

/// Subjective severity tier of reported symptoms.
enum SymptomSeverity {
  /// Mild symptoms, does not impede daily activity or feeding.
  mild('mild', 'হালকা · Mild'),

  /// Moderate symptoms, causes noticeable distress or discomfort.
  moderate('moderate', 'মাঝারি · Moderate'),

  /// Severe symptoms, incapacitating or distressing.
  severe('severe', 'তীব্র · Severe');

  const SymptomSeverity(this.key, this.label);

  /// Normalized storage key.
  final String key;

  /// Bilingual display label.
  final String label;

  /// Parses a string key into [SymptomSeverity], defaulting to [mild].
  static SymptomSeverity fromKey(String? key) {
    return switch (key) {
      'moderate' => SymptomSeverity.moderate,
      'severe' => SymptomSeverity.severe,
      _ => SymptomSeverity.mild,
    };
  }
}

/// Model representing a selectable symptom option in the intake grid.
class SymptomOption {
  /// Creates a [SymptomOption].
  const SymptomOption({
    required this.id,
    required this.iconKey,
    required this.labelBn,
    required this.labelEn,
  });

  /// Unique identifier for the symptom (e.g. 'chest_pain', 'fever').
  final String id;

  /// Icon identifier mapped to UI icons.
  final String iconKey;

  /// Localized Bangla label.
  final String labelBn;

  /// Localized English label.
  final String labelEn;
}

/// Model encapsulating user responses to clinical follow-up questions.
class FollowUpAnswers {
  /// Creates a [FollowUpAnswers] instance.
  const FollowUpAnswers({
    this.duration = SymptomDuration.today,
    this.severity = SymptomSeverity.mild,
    this.dangerSigns = const <String>{},
  });

  /// How long the symptoms have persisted.
  final SymptomDuration duration;

  /// The reported severity tier of the symptoms.
  final SymptomSeverity severity;

  /// Identifiers of any danger signs or red flags confirmed by the user.
  final Set<String> dangerSigns;

  /// Returns a copy of this object with updated fields.
  FollowUpAnswers copyWith({
    SymptomDuration? duration,
    SymptomSeverity? severity,
    Set<String>? dangerSigns,
  }) {
    return FollowUpAnswers(
      duration: duration ?? this.duration,
      severity: severity ?? this.severity,
      dangerSigns: dangerSigns ?? this.dangerSigns,
    );
  }

  /// Whether any danger signs were flagged during follow-up.
  bool get hasDangerSigns => dangerSigns.isNotEmpty;
}

/// Outcome of the clinical triage evaluation.
///
/// Contains the determined [TriageLevel], plain-language rationale,
/// WHO guideline citations, and conservative non-medicinal self-care guidance.
class TriageResult {
  /// Creates a [TriageResult].
  const TriageResult({
    required this.level,
    required this.reasonBn,
    required this.reasonEn,
    required this.guidelineSource,
    required this.sectionCitation,
    this.selfCareSteps = const <String>[],
    this.needsClinicianReview = false,
  });

  /// The determined triage urgency level.
  final TriageLevel level;

  /// Plain-language clinical rationale in Bangla.
  final String reasonBn;

  /// Plain-language clinical rationale in English.
  final String reasonEn;

  /// Authoritative guideline document (e.g., "WHO IMCI Chart Booklet 2024").
  final String guidelineSource;

  /// Specific chapter/section citation grounding this decision.
  final String sectionCitation;

  /// Safe, non-pharmacological supportive care steps (safe hydration, resting).
  ///
  /// Strictly contains NO medication names or dosages per rules.md.
  final List<String> selfCareSteps;

  /// Flag indicating this case should be highlighted for clinician dashboard review.
  final bool needsClinicianReview;
}

/// Facility classification tier.
enum FacilityType {
  /// Primary village-level clinic (e.g., Community Clinic).
  clinic,

  /// Secondary or tertiary medical facility (e.g., Upazila Health Complex, District Hospital).
  hospital,

  /// Local certified medicine store or first-aid post.
  pharmacy,
}

/// Item representing a healthcare facility in the offline nearest-facility list.
class FacilityItem {
  /// Creates a [FacilityItem].
  const FacilityItem({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.type,
    required this.distanceKm,
    required this.travelTimeMin,
    required this.phone,
    required this.isOpenNow,
  });

  /// Unique facility identifier.
  final String id;

  /// Facility name in Bangla.
  final String nameBn;

  /// Facility name in English.
  final String nameEn;

  /// Facility categorization tier.
  final FacilityType type;

  /// Straight-line or road distance from current location in kilometers.
  final double distanceKm;

  /// Estimated transit time in minutes.
  final int travelTimeMin;

  /// Local emergency telephone or contact number.
  final String phone;

  /// Whether the facility currently provides emergency or active services.
  final bool isOpenNow;
}
