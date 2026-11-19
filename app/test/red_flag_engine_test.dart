import 'package:flutter_test/flutter_test.dart';
import 'package:outpost/core/constants/triage_enums.dart';
import 'package:outpost/domain/entities/triage_models.dart';
import 'package:outpost/domain/triage/red_flag_engine.dart';
import 'package:outpost/domain/triage/triage_engine.dart';

void main() {
  group('RedFlagEngine - 9 Hardcoded Danger Signs', () {
    const redFlagEngine = RedFlagEngine();

    test('1. chest_pain_or_pressure triggers emergency', () {
      final result = redFlagEngine.evaluate(
        forWhom: ForWhom.myself,
        symptoms: {'chest_pain'},
        answers: const FollowUpAnswers(
          dangerSigns: {'chest_pain_or_pressure'},
          severity: SymptomSeverity.severe,
        ),
      );

      expect(result, isNotNull);
      expect(result!.level, equals(TriageLevel.emergency));
      expect(result.guidelineSource, contains('WHO'));
      expect(result.needsClinicianReview, isTrue);
    });

    test('2. severe_difficulty_breathing triggers emergency', () {
      final result = redFlagEngine.evaluate(
        forWhom: ForWhom.myself,
        symptoms: {'breathing'},
        answers: const FollowUpAnswers(
          dangerSigns: {'severe_difficulty_breathing'},
        ),
      );

      expect(result, isNotNull);
      expect(result!.level, equals(TriageLevel.emergency));
      expect(result.sectionCitation, contains('Airway and Breathing'));
    });

    test('3. uncontrolled_bleeding triggers emergency', () {
      final result = redFlagEngine.evaluate(
        forWhom: ForWhom.myself,
        symptoms: {'bleeding'},
        answers: const FollowUpAnswers(
          dangerSigns: {'uncontrolled_bleeding'},
        ),
      );

      expect(result, isNotNull);
      expect(result!.level, equals(TriageLevel.emergency));
    });

    test('4. convulsions_or_unconscious triggers emergency', () {
      final result = redFlagEngine.evaluate(
        forWhom: ForWhom.child,
        symptoms: {'fever'},
        answers: const FollowUpAnswers(
          dangerSigns: {'convulsions_or_unconscious'},
        ),
      );

      expect(result, isNotNull);
      expect(result!.level, equals(TriageLevel.emergency));
      expect(result.guidelineSource, contains('IMCI'));
    });

    test('5. unable_to_drink_or_breastfeed triggers emergency for child', () {
      final result = redFlagEngine.evaluate(
        forWhom: ForWhom.child,
        symptoms: {'fever'},
        answers: const FollowUpAnswers(
          dangerSigns: {'unable_to_drink_or_breastfeed'},
        ),
      );

      expect(result, isNotNull);
      expect(result!.level, equals(TriageLevel.emergency));
      expect(result.reasonBn, contains('বিপদচিহ্ন'));
    });

    test('6. vomiting_everything triggers emergency for child', () {
      final result = redFlagEngine.evaluate(
        forWhom: ForWhom.child,
        symptoms: {'stomach'},
        answers: const FollowUpAnswers(
          dangerSigns: {'vomiting_everything'},
        ),
      );

      expect(result, isNotNull);
      expect(result!.level, equals(TriageLevel.emergency));
    });

    test('7. severe abdominal pain or bleeding triggers emergency in pregnancy', () {
      final result = redFlagEngine.evaluate(
        forWhom: ForWhom.pregnant,
        symptoms: {'bleeding'},
        answers: const FollowUpAnswers(
          dangerSigns: {'pregnancy_severe_abdominal_pain_or_bleeding'},
        ),
      );

      expect(result, isNotNull);
      expect(result!.level, equals(TriageLevel.emergency));
      expect(result.guidelineSource, contains('MCPC'));
    });

    test('8. headache with blurred vision triggers emergency in pregnancy', () {
      final result = redFlagEngine.evaluate(
        forWhom: ForWhom.pregnant,
        symptoms: {'headache'},
        answers: const FollowUpAnswers(
          dangerSigns: {'pregnancy_headache_blurred_vision'},
        ),
      );

      expect(result, isNotNull);
      expect(result!.level, equals(TriageLevel.emergency));
      expect(result.reasonEn, contains('Pre-eclampsia'));
    });

    test('9. high fever with stiff neck or confusion triggers emergency', () {
      final result = redFlagEngine.evaluate(
        forWhom: ForWhom.myself,
        symptoms: {'fever'},
        answers: const FollowUpAnswers(
          dangerSigns: {'fever_with_stiff_neck_or_confusion'},
        ),
      );

      expect(result, isNotNull);
      expect(result!.level, equals(TriageLevel.emergency));
      expect(result.sectionCitation, contains('Meningitis'));
    });
  });

  group('TriageEngine - Full Urgency Pipeline', () {
    const triageEngine = TriageEngine();

    test('Severe symptoms trigger seeClinicianToday when no red flag', () {
      final result = triageEngine.evaluate(
        forWhom: ForWhom.myself,
        symptoms: {'headache'},
        answers: const FollowUpAnswers(
          duration: SymptomDuration.today,
          severity: SymptomSeverity.severe,
        ),
      );

      expect(result.level, equals(TriageLevel.seeClinicianToday));
      expect(result.guidelineSource, contains('WHO'));
      expect(result.needsClinicianReview, isTrue);
    });

    test('Prolonged symptoms (3+ days) trigger seeClinicianToday', () {
      final result = triageEngine.evaluate(
        forWhom: ForWhom.myself,
        symptoms: {'cough'},
        answers: const FollowUpAnswers(
          duration: SymptomDuration.threePlusDays,
          severity: SymptomSeverity.moderate,
        ),
      );

      expect(result.level, equals(TriageLevel.seeClinicianToday));
      expect(result.needsClinicianReview, isTrue);
    });

    test('Pregnant woman with moderate symptoms triggers seeClinicianToday', () {
      final result = triageEngine.evaluate(
        forWhom: ForWhom.pregnant,
        symptoms: {'stomach'},
        answers: const FollowUpAnswers(
          duration: SymptomDuration.today,
          severity: SymptomSeverity.moderate,
        ),
      );

      expect(result.level, equals(TriageLevel.seeClinicianToday));
      expect(result.guidelineSource, contains('MCPC'));
    });

    test('Child with moderate symptoms triggers seeClinicianToday', () {
      final result = triageEngine.evaluate(
        forWhom: ForWhom.child,
        symptoms: {'cough'},
        answers: const FollowUpAnswers(
          duration: SymptomDuration.oneToTwoDays,
          severity: SymptomSeverity.moderate,
        ),
      );

      expect(result.level, equals(TriageLevel.seeClinicianToday));
      expect(result.guidelineSource, contains('IMCI'));
    });

    test('Mild short-duration symptoms trigger homeCare with safe non-medicinal steps', () {
      final result = triageEngine.evaluate(
        forWhom: ForWhom.myself,
        symptoms: {'cough'},
        answers: const FollowUpAnswers(
          duration: SymptomDuration.today,
          severity: SymptomSeverity.mild,
        ),
      );

      expect(result.level, equals(TriageLevel.homeCare));
      expect(result.needsClinicianReview, isFalse);
      expect(result.selfCareSteps, isNotEmpty);

      // Verify no medication names or dosages in selfCareSteps per rules.md
      for (final step in result.selfCareSteps) {
        expect(step.toLowerCase(), isNot(contains('paracetamol')));
        expect(step.toLowerCase(), isNot(contains('antibiotic')));
        expect(step.toLowerCase(), isNot(contains('mg')));
        expect(step.toLowerCase(), isNot(contains('tablet')));
      }
    });

    test('Empty symptoms fail safe to seeClinicianToday, never homeCare', () {
      final result = triageEngine.evaluate(
        forWhom: ForWhom.myself,
        symptoms: <String>{},
        answers: const FollowUpAnswers(),
      );

      expect(result.level, equals(TriageLevel.seeClinicianToday));
      expect(result.level, isNot(equals(TriageLevel.homeCare)));
      expect(result.needsClinicianReview, isTrue);
    });
  });
}
