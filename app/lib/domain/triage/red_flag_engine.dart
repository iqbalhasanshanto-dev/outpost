import '../../core/constants/triage_enums.dart';
import '../entities/triage_models.dart';

/// Specification for a deterministic red-flag danger sign.
class RedFlagRule {
  const RedFlagRule({
    required this.id,
    required this.titleBn,
    required this.titleEn,
    required this.guidelineSource,
    required this.sectionCitation,
    this.applicableForWhom,
  });

  /// Unique identifier of the red flag.
  final String id;

  /// Clinical danger description in Bangla.
  final String titleBn;

  /// Clinical danger description in English.
  final String titleEn;

  /// Authoritative WHO guideline source document.
  final String guidelineSource;

  /// Specific chapter/section citation.
  final String sectionCitation;

  /// Target patient category, or null if applicable universally.
  final ForWhom? applicableForWhom;
}

/// Deterministic red-flag safety engine.
///
/// Implements Safety Layer Rule 1 per Architecture.md and rules.md:
/// - Runs first in the triage pipeline.
/// - Evaluates 9 deterministic danger signs across adult, child, and pregnancy.
/// - If any red flag triggers, returns [TriageLevel.emergency] immediately.
/// - Nothing downstream may ever downgrade or override this emergency status.
class RedFlagEngine {
  const RedFlagEngine();

  /// The 9 hardcoded WHO-aligned danger sign rules.
  static const List<RedFlagRule> rules = [
    // 1. Adult/General cardiovascular danger sign
    RedFlagRule(
      id: 'chest_pain_or_pressure',
      titleBn: 'বুকে তীব্র ব্যথা বা প্রচণ্ড চাপ অনুভব করা (হৃদরোগের জরুরি লক্ষণ)',
      titleEn: 'Severe chest pain, tightness, or pressure radiating to arm or jaw',
      guidelineSource: 'WHO Package of Essential NCD Interventions (PEN)',
      sectionCitation: 'Protocol 1: Acute Coronary Syndrome and Chest Pain',
    ),

    // 2. Severe respiratory distress across all age groups
    RedFlagRule(
      id: 'severe_difficulty_breathing',
      titleBn: 'তীব্র শ্বাসকষ্ট, দ্রুত শ্বাস নেওয়া বা বুক অস্বাভাবিক দেবে যাওয়া',
      titleEn: 'Severe difficulty breathing, rapid breathing, or chest indrawing',
      guidelineSource: 'WHO Emergency Triage Assessment and Treatment (ETAT)',
      sectionCitation: 'Section 1: Airway and Breathing Emergencies',
    ),

    // 3. Uncontrolled or severe active bleeding
    RedFlagRule(
      id: 'uncontrolled_bleeding',
      titleBn: 'অনিয়ন্ত্রিত বা অতিরিক্ত রক্তক্ষরণ যা চেপে ধরেও থামছে না',
      titleEn: 'Uncontrolled active bleeding not stopping with direct pressure',
      guidelineSource: 'WHO Emergency Triage Assessment and Treatment (ETAT)',
      sectionCitation: 'Section 2: Circulation and Shock Management',
    ),

    // 4. Neurological danger sign (convulsions or loss of consciousness)
    RedFlagRule(
      id: 'convulsions_or_unconscious',
      titleBn: 'খিঁচুনি হওয়া, খিঁচুনির ইতিহাস বা অজ্ঞান/অচেতন হয়ে যাওয়া',
      titleEn: 'Active convulsions, seizure history during illness, or loss of consciousness',
      guidelineSource: 'WHO IMCI Chart Booklet / ETAT Guidelines',
      sectionCitation: 'General Danger Signs: Convulsions & Lethargy',
    ),

    // 5. Pediatric danger sign: unable to drink or breastfeed
    RedFlagRule(
      id: 'unable_to_drink_or_breastfeed',
      titleBn: 'শিশু কোনো তরল, পানি বা বুকের দুধ পান করতে পারছে না',
      titleEn: 'Child is completely unable to drink or breastfeed',
      guidelineSource: 'WHO Integrated Management of Childhood Illness (IMCI)',
      sectionCitation: 'Step 1: Assess General Danger Signs in Children (2m-5y)',
      applicableForWhom: ForWhom.child,
    ),

    // 6. Pediatric danger sign: vomiting everything
    RedFlagRule(
      id: 'vomiting_everything',
      titleBn: 'শিশু যা খাচ্ছে তা-ই সঙ্গে সঙ্গে বমি করে ফেলে দিচ্ছে',
      titleEn: 'Child vomits everything consumed immediately',
      guidelineSource: 'WHO Integrated Management of Childhood Illness (IMCI)',
      sectionCitation: 'Step 1: Assess General Danger Signs in Children (2m-5y)',
      applicableForWhom: ForWhom.child,
    ),

    // 7. Maternal danger sign: severe abdominal pain or bleeding during pregnancy
    RedFlagRule(
      id: 'pregnancy_severe_abdominal_pain_or_bleeding',
      titleBn: 'গর্ভাবস্থায় পেটে তীব্র অসহ্য যন্ত্রণা অথবা যোনিপথে রক্তপাত',
      titleEn: 'Severe abdominal pain or vaginal bleeding during pregnancy',
      guidelineSource: 'WHO Managing Complications in Pregnancy and Childbirth (MCPC)',
      sectionCitation: 'Section S-1: Emergency Obstetric Triage and Haemorrhage',
      applicableForWhom: ForWhom.pregnant,
    ),

    // 8. Maternal danger sign: severe headache with blurred vision (Pre-eclampsia)
    RedFlagRule(
      id: 'pregnancy_headache_blurred_vision',
      titleBn: 'গর্ভাবস্থায় তীব্র মাথা ব্যথার সাথে চোখে ঝাপসা দেখা (এক্লাম্পশিয়ার লক্ষণ)',
      titleEn: 'Severe headache with blurred vision during pregnancy (Pre-eclampsia)',
      guidelineSource: 'WHO Managing Complications in Pregnancy and Childbirth (MCPC)',
      sectionCitation: 'Section S-5: Elevated Blood Pressure and Severe Pre-eclampsia',
      applicableForWhom: ForWhom.pregnant,
    ),

    // 9. Infectious neurological danger sign: high fever with stiff neck or confusion
    RedFlagRule(
      id: 'fever_with_stiff_neck_or_confusion',
      titleBn: 'তীব্র জ্বরের সাথে ঘাড় শক্ত হয়ে যাওয়া বা অসংলগ্ন প্রলাপ ও বিভ্রান্তি',
      titleEn: 'High fever accompanied by stiff neck, acute confusion, or altered mental state',
      guidelineSource: 'WHO Primary Care Pocket Book of Severe Infections',
      sectionCitation: 'Chapter 4: Acute Bacterial Meningitis & Encephalitis',
    ),
  ];

  /// Evaluates patient data against all 9 red-flag rules.
  ///
  /// Returns a [TriageResult] with [TriageLevel.emergency] if any red flag
  /// matches, or `null` if no deterministic danger signs are identified.
  TriageResult? evaluate({
    required ForWhom forWhom,
    required Set<String> symptoms,
    required FollowUpAnswers answers,
  }) {
    // Combine symptom identifiers and explicit follow-up danger signs
    final allReportedFlags = <String>{
      ...symptoms,
      ...answers.dangerSigns,
    };

    // If symptoms include chest pain or severe difficulty breathing or bleeding and severity is severe
    if (symptoms.contains('chest_pain') ||
        (symptoms.contains('chest_pain') && answers.severity == SymptomSeverity.severe)) {
      allReportedFlags.add('chest_pain_or_pressure');
    }
    if (symptoms.contains('breathing') && answers.severity == SymptomSeverity.severe) {
      allReportedFlags.add('severe_difficulty_breathing');
    }
    if (symptoms.contains('bleeding') && answers.severity == SymptomSeverity.severe) {
      allReportedFlags.add('uncontrolled_bleeding');
    }
    if (forWhom == ForWhom.pregnant) {
      if (symptoms.contains('bleeding') || (symptoms.contains('stomach') && answers.severity == SymptomSeverity.severe)) {
        allReportedFlags.add('pregnancy_severe_abdominal_pain_or_bleeding');
      }
      if (symptoms.contains('headache') && answers.severity == SymptomSeverity.severe) {
        allReportedFlags.add('pregnancy_headache_blurred_vision');
      }
    }

    // Check against each registered danger sign rule
    for (final rule in rules) {
      // Validate patient category applicability
      if (rule.applicableForWhom != null && rule.applicableForWhom != forWhom) {
        continue;
      }

      if (allReportedFlags.contains(rule.id)) {
        return TriageResult(
          level: TriageLevel.emergency,
          reasonBn: 'রেড-ফ্ল্যাগ বিপদচিহ্ন পাওয়া গেছে: ${rule.titleBn}। অবিলম্বে জরুরি স্বাস্থ্যসেবা নিশ্চিত করুন।',
          reasonEn: 'Critical danger sign identified: ${rule.titleEn}. Seek emergency medical care immediately.',
          guidelineSource: rule.guidelineSource,
          sectionCitation: rule.sectionCitation,
          selfCareSteps: const [
            'রোগীকে নিরাপদ ও শান্ত স্থানে রাখুন।',
            'কোনো খাবার বা পানীয় জোর করে খাওয়াবেন না।',
            'অবিলম্বে নিকটস্থ জরুরি স্বাস্থ্যকেন্দ্রে নিয়ে যান বা অ্যাম্বুলেন্স ডাকুন।',
          ],
          needsClinicianReview: true,
        );
      }
    }

    return null;
  }
}
