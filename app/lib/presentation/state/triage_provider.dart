import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/triage_enums.dart';
import '../../domain/entities/triage_models.dart';
import '../../domain/triage/triage_engine.dart';

/// State representation for the active patient intake and triage evaluation.
class TriageState {
  /// Creates a [TriageState].
  const TriageState({
    this.forWhom = ForWhom.myself,
    this.selectedSymptoms = const <String>{},
    this.followUpAnswers = const FollowUpAnswers(),
    this.result,
  });

  /// Who the intake is currently being performed for.
  final ForWhom forWhom;

  /// Set of selected symptom IDs.
  final Set<String> selectedSymptoms;

  /// User answers to clinical follow-up questions.
  final FollowUpAnswers followUpAnswers;

  /// Computed triage outcome, or null if evaluation has not yet been triggered.
  final TriageResult? result;

  /// Creates a copy of this state with updated values.
  TriageState copyWith({
    ForWhom? forWhom,
    Set<String>? selectedSymptoms,
    FollowUpAnswers? followUpAnswers,
    TriageResult? Function()? result,
  }) {
    return TriageState(
      forWhom: forWhom ?? this.forWhom,
      selectedSymptoms: selectedSymptoms ?? this.selectedSymptoms,
      followUpAnswers: followUpAnswers ?? this.followUpAnswers,
      result: result != null ? result() : this.result,
    );
  }
}

/// Riverpod notifier managing active triage state across intake, follow-up, and results.
class TriageNotifier extends Notifier<TriageState> {
  final TriageEngine _triageEngine = const TriageEngine();

  @override
  TriageState build() {
    return const TriageState();
  }

  /// Sets the patient category ([ForWhom]).
  void setForWhom(ForWhom forWhom) {
    state = state.copyWith(forWhom: forWhom);
  }

  /// Toggles selection of a specific symptom ID.
  void toggleSymptom(String symptomId) {
    final updated = Set<String>.from(state.selectedSymptoms);
    if (updated.contains(symptomId)) {
      updated.remove(symptomId);
    } else {
      updated.add(symptomId);
    }
    state = state.copyWith(selectedSymptoms: updated);
  }

  /// Replaces the entire set of selected symptoms.
  void setSymptoms(Set<String> symptoms) {
    state = state.copyWith(selectedSymptoms: Set<String>.from(symptoms));
  }

  /// Updates the duration of reported symptoms.
  void setDuration(SymptomDuration duration) {
    state = state.copyWith(
      followUpAnswers: state.followUpAnswers.copyWith(duration: duration),
    );
  }

  /// Updates the severity tier of reported symptoms.
  void setSeverity(SymptomSeverity severity) {
    state = state.copyWith(
      followUpAnswers: state.followUpAnswers.copyWith(severity: severity),
    );
  }

  /// Toggles a specific confirmed danger sign.
  void toggleDangerSign(String dangerSignId) {
    final currentSigns = Set<String>.from(state.followUpAnswers.dangerSigns);
    if (currentSigns.contains(dangerSignId)) {
      currentSigns.remove(dangerSignId);
    } else {
      currentSigns.add(dangerSignId);
    }
    state = state.copyWith(
      followUpAnswers: state.followUpAnswers.copyWith(dangerSigns: currentSigns),
    );
  }

  /// Sets full follow-up answers directly.
  void setFollowUpAnswers(FollowUpAnswers answers) {
    state = state.copyWith(followUpAnswers: answers);
  }

  /// Evaluates current state using [TriageEngine] and updates [state.result].
  TriageResult evaluateTriage() {
    final evaluated = _triageEngine.evaluate(
      forWhom: state.forWhom,
      symptoms: state.selectedSymptoms,
      answers: state.followUpAnswers,
    );
    state = state.copyWith(result: () => evaluated);
    return evaluated;
  }

  /// Resets the intake and triage state to clean default values.
  void reset() {
    state = const TriageState();
  }
}

/// Global Riverpod provider for active patient triage assessment.
final triageProvider = NotifierProvider<TriageNotifier, TriageState>(
  TriageNotifier.new,
);
