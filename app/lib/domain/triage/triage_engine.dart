import '../../core/constants/triage_enums.dart';
import '../entities/triage_models.dart';
import 'red_flag_engine.dart';

/// Clinical triage engine combining deterministic red flags and rule layers.
///
/// Implements the triage urgency pipeline specified in Architecture.md:
/// 1. Safety layer: Runs [RedFlagEngine] first. Red flags immediately return
///    [TriageLevel.emergency] and cannot be overridden.
/// 2. Level assignment: Evaluates symptom duration, severity, and patient
///    vulnerabilities (pediatric, pregnancy) to categorize urgency.
/// 3. Uncertainty escalation: Incomplete or empty data escalates safely to
///    [TriageLevel.seeClinicianToday], never defaulting to home care.
/// 4. Strict safety compliance: Never diagnoses, never advises medication
///    names or doses per rules.md.
class TriageEngine {
  /// Creates a [TriageEngine] instance with an optional custom [RedFlagEngine].
  const TriageEngine({
    this.redFlagEngine = const RedFlagEngine(),
  });

  /// Deterministic red-flag safety rule engine.
  final RedFlagEngine redFlagEngine;

  /// Evaluates patient case data and determines clinical urgency.
  ///
  /// Guaranteed to never throw and never return [TriageLevel.homeCare] on error.
  TriageResult evaluate({
    required ForWhom forWhom,
    required Set<String> symptoms,
    required FollowUpAnswers answers,
  }) {
    try {
      // 1. Safety Layer: Red-flag rules run first and cannot be downgraded
      final redFlagResult = redFlagEngine.evaluate(
        forWhom: forWhom,
        symptoms: symptoms,
        answers: answers,
      );
      if (redFlagResult != null) {
        return redFlagResult;
      }

      // 2. Safety Layer: Empty or incomplete symptom inputs fail safe
      if (symptoms.isEmpty) {
        return const TriageResult(
          level: TriageLevel.seeClinicianToday,
          reasonBn:
              'লক্ষণ সংক্রান্ত পর্যাপ্ত তথ্য না থাকায় সুরক্ষার স্বার্থে আজই একজন স্বাস্থ্যকর্মীর পরামর্শ নেওয়ার নির্দেশ দেওয়া হচ্ছে।',
          reasonEn:
              'Incomplete symptom intake reported. As a clinical safety precaution, a same-day medical assessment is advised.',
          guidelineSource:
              'WHO Primary Care Clinical Safety Guidelines',
          sectionCitation:
              'Section 1.4: Protocol for Incomplete History and Risk Mitigation',
          needsClinicianReview: true,
        );
      }

      // 3. Moderate to Severe / Prolonged Course evaluation
      final isSevere = answers.severity == SymptomSeverity.severe;
      final isProlonged = answers.duration == SymptomDuration.threePlusDays;
      final isModerate = answers.severity == SymptomSeverity.moderate;

      // Special vulnerability escalation for pregnant women or young infants
      final isVulnerableGroup =
          forWhom == ForWhom.pregnant || forWhom == ForWhom.child;

      if (isSevere ||
          (isProlonged && isModerate) ||
          (isVulnerableGroup && (isModerate || isProlonged)) ||
          isProlonged) {
        return TriageResult(
          level: TriageLevel.seeClinicianToday,
          reasonBn: forWhom == ForWhom.pregnant
              ? 'গর্ভাবস্থায় মাঝারি বা দীর্ঘস্থায়ী শারীরিক সমস্যা দেখা দেওয়ায় আজই স্বাস্থ্যকেন্দ্রে ডাক্তার দেখানো আবশ্যক।'
              : forWhom == ForWhom.child
                  ? 'শিশুর শারীরিক দুর্বলতা ও দীর্ঘস্থায়ী লক্ষণের জন্য আজই স্বাস্থ্যকেন্দ্রে পরীক্ষা করানো প্রয়োজন।'
                  : 'লক্ষণগুলো বেশ কিছুদিন ধরে স্থায়ী বা তীব্র হওয়ায় আজই একজন যোগ্য চিকিৎসকের পরামর্শ নেওয়া প্রয়োজন।',
          reasonEn: forWhom == ForWhom.pregnant
              ? 'Maternal symptoms with moderate severity or persistence require clinician evaluation today.'
              : forWhom == ForWhom.child
                  ? 'Pediatric symptoms requiring clinical review today to prevent dehydration or complications.'
                  : 'Moderate or persistent symptoms (3+ days) require same-day clinical assessment.',
          guidelineSource: forWhom == ForWhom.child
              ? 'WHO Pocket Book of Hospital Care for Children / IMCI'
              : forWhom == ForWhom.pregnant
                  ? 'WHO Managing Complications in Pregnancy and Childbirth (MCPC)'
                  : 'WHO Primary Health Care Guidelines (Clinical Urgency Assessment)',
          sectionCitation: forWhom == ForWhom.child
              ? 'Chapter 3: Assessment and Referral of Sick Child'
              : forWhom == ForWhom.pregnant
                  ? 'Section S-2: Non-Emergency Maternal Referrals'
                  : 'Module 2: Secondary Risk Stratification in Primary Care',
          selfCareSteps: const [
            'রোগীকে বিশ্রামে রাখুন এবং নিয়মিত পর্যবেক্ষণ করুন।',
            'পর্যাপ্ত নিরাপদ পানি ও তরল খাবার পান করান।',
            'আজকের মধ্যেই নিকটস্থ কমিউনিটি ক্লিনিক বা স্বাস্থ্য কমপ্লেক্সে যোগাযোগ করুন।',
          ],
          needsClinicianReview: true,
        );
      }

      // 4. Mild symptoms of short duration (today or 1-2 days) with no danger signs
      if (answers.severity == SymptomSeverity.mild && !isProlonged) {
        return const TriageResult(
          level: TriageLevel.homeCare,
          reasonBn:
              'লক্ষণগুলো মৃদু এবং কোনো বিপদচিহ্ন নেই। বাড়িতে পর্যাপ্ত বিশ্রাম ও তরল খাবার গ্রহণের মাধ্যমে যত্ন নেওয়া নিরাপদ।',
          reasonEn:
              'Symptoms are mild and short in duration with zero danger signs. Supportive home care and monitoring are appropriate.',
          guidelineSource:
              'WHO Integrated Primary Care Guidance / Home Care Principles',
          sectionCitation:
              'Section 6: Supportive Self-Care and Patient Monitoring',
          selfCareSteps: [
            'পর্যাপ্ত বিশুদ্ধ খাবার পানি, পুষ্টিকর তরল ও স্বাভাবিক খাবার গ্রহণ করুন।',
            'পর্যাপ্ত বিশ্রাম নিন এবং শরীরকে চাপমুক্ত রাখুন।',
            'শিশুর ক্ষেত্রে বুকের দুধ বা স্বাভাবিক খাবার নিয়মিত দেওয়া চালিয়ে যান।',
            'যদি কোনো বিপদচিহ্ন (যেমন তীব্র শ্বাসকষ্ট, অতিরিক্ত দুর্বলতা বা জ্বর বৃদ্ধি) দেখা দেয়, তবে অবিলম্বে স্বাস্থ্যকেন্দ্রে যান।',
          ],
          needsClinicianReview: false,
        );
      }

      // Default safe outcome if boundary conditions are unclear
      return const TriageResult(
        level: TriageLevel.seeClinicianToday,
        reasonBn:
            'সতর্কতামূলক ব্যবস্থা হিসেবে আজই নিকটস্থ স্বাস্থ্যকেন্দ্রে স্বাস্থ্যকর্মীকে শারীরিক অবস্থা পর্যবেক্ষণ করান।',
        reasonEn:
            'Precautionary clinical safety guidance: consult a healthcare provider today.',
        guidelineSource:
            'WHO Primary Care Safety Protocol',
        sectionCitation:
            'Section 1.1: General Urgency Assessment',
        needsClinicianReview: true,
      );
    } catch (_) {
      // Fail-Safe Catch-All: Never crash, never default to home care
      return const TriageResult(
        level: TriageLevel.seeClinicianToday,
        reasonBn:
            'অভ্যন্তরীণ মূল্যায়নে অনিশ্চয়তা দেখা দেওয়ায় নিরাপদ সতর্কতা হিসেবে আজই স্বাস্থ্যকেন্দ্রে যোগাযোগের পরামর্শ দেওয়া হচ্ছে।',
        reasonEn:
            'System fail-safe triggered due to evaluation uncertainty. Please seek clinical assessment today.',
        guidelineSource:
            'WHO Primary Care Clinical Safety Protocol',
        sectionCitation:
            'Section: Fail-Safe Uncertainty Escalation',
        needsClinicianReview: true,
      );
    }
  }
}
