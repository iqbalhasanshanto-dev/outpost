import '../core/constants/triage_enums.dart';

/// Strongly typed localization string repository for Outpost Phase 1.
///
/// Contains comprehensive Bangla and English translations for all screens.
/// Guarantees compile-time safety and prevents hardcoding user-facing strings.
class AppStrings {
  const AppStrings._({
    required this.appName,
    required this.appTagline,
    required this.appOneLineTagline,
    required this.chooseLanguageTitle,
    required this.continueInBangla,
    required this.continueInEnglish,
    required this.securityNotice,
    required this.conceptDisclaimer,
    required this.offlineStatusBanner,
    required this.navHome,
    required this.navHistory,
    required this.navSettings,
    required this.btnNext,
    required this.btnBack,
    required this.btnCallEmergency,
    required this.btnFindFacility,
    required this.startNewCheck,
    required this.emergencyCallSheetTitle,
    required this.emergencyCallSheetNotice,
    required this.emergencyCallConfirm,
    required this.emergencyCallDismiss,
    required this.whoNeedsCareTitle,
    required this.whoNeedsCareSubtitle,
    required this.forMyself,
    required this.forChild,
    required this.forPregnant,
    required this.privacyReassurance,
    required this.privacySub,
    required this.symptomsTitle,
    required this.symptomsSubtitle,
    required this.voicePhase5Chip,
    required this.voiceIntakePrompt,
    required this.symptomFever,
    required this.symptomCoughBreathing,
    required this.symptomChestPain,
    required this.symptomBleeding,
    required this.symptomStomach,
    required this.symptomHeadache,
    required this.symptomVomitingDiarrhea,
    required this.symptomPregnancy,
    required this.symptomInjury,
    required this.symptomRash,
    required this.symptomDizziness,
    required this.symptomOther,
    required this.followUpTitle,
    required this.followUpSubtitle,
    required this.howLongHappening,
    required this.durationToday,
    required this.durationOneToTwo,
    required this.durationThreePlus,
    required this.howSevereFeels,
    required this.severityMild,
    required this.severityModerate,
    required this.severitySevere,
    required this.areDangerSignsPresent,
    required this.dangerSignsGuidance,
    required this.dangerSignUnsureOption,
    required this.dangerSignNoneOption,
    required this.answerYes,
    required this.answerNo,
    required this.answerUnsure,
    required this.triageResultTitle,
    required this.triageEmergency,
    required this.triageSeeClinicianToday,
    required this.triageHomeCare,
    required this.nextStepHeading,
    required this.emergencyActionTitle,
    required this.emergencyActionSubtitle,
    required this.clinicianTodayActionTitle,
    required this.clinicianTodayActionSubtitle,
    required this.homeCareActionTitle,
    required this.homeCareActionSubtitle,
    required this.reasonHeading,
    required this.guidelineSourceHeading,
    required this.selfCareStepsHeading,
    required this.warningSignsWatchHeading,
    required this.triageDisclaimer,
    required this.facilityTitle,
    required this.facilitySubtitle,
    required this.offlineMapPreview,
    required this.facilityDistance,
    required this.facilityTypeHospital,
    required this.facilityTypeClinic,
    required this.facilityTypePharmacy,
    required this.statusOpenNow,
    required this.statusClosed,
    required this.callFacility,
    required this.offlineBadge,
  });

  final String appName;
  final String appTagline;
  final String appOneLineTagline;
  final String chooseLanguageTitle;
  final String continueInBangla;
  final String continueInEnglish;
  final String securityNotice;
  final String conceptDisclaimer;
  final String offlineStatusBanner;
  final String navHome;
  final String navHistory;
  final String navSettings;
  final String btnNext;
  final String btnBack;
  final String btnCallEmergency;
  final String btnFindFacility;
  final String startNewCheck;
  final String emergencyCallSheetTitle;
  final String emergencyCallSheetNotice;
  final String emergencyCallConfirm;
  final String emergencyCallDismiss;
  final String whoNeedsCareTitle;
  final String whoNeedsCareSubtitle;
  final String forMyself;
  final String forChild;
  final String forPregnant;
  final String privacyReassurance;
  final String privacySub;
  final String symptomsTitle;
  final String symptomsSubtitle;
  final String voicePhase5Chip;
  final String voiceIntakePrompt;
  final String symptomFever;
  final String symptomCoughBreathing;
  final String symptomChestPain;
  final String symptomBleeding;
  final String symptomStomach;
  final String symptomHeadache;
  final String symptomVomitingDiarrhea;
  final String symptomPregnancy;
  final String symptomInjury;
  final String symptomRash;
  final String symptomDizziness;
  final String symptomOther;
  final String followUpTitle;
  final String followUpSubtitle;
  final String howLongHappening;
  final String durationToday;
  final String durationOneToTwo;
  final String durationThreePlus;
  final String howSevereFeels;
  final String severityMild;
  final String severityModerate;
  final String severitySevere;
  final String areDangerSignsPresent;
  final String dangerSignsGuidance;
  final String dangerSignUnsureOption;
  final String dangerSignNoneOption;
  final String answerYes;
  final String answerNo;
  final String answerUnsure;
  final String triageResultTitle;
  final String triageEmergency;
  final String triageSeeClinicianToday;
  final String triageHomeCare;
  final String nextStepHeading;
  final String emergencyActionTitle;
  final String emergencyActionSubtitle;
  final String clinicianTodayActionTitle;
  final String clinicianTodayActionSubtitle;
  final String homeCareActionTitle;
  final String homeCareActionSubtitle;
  final String reasonHeading;
  final String guidelineSourceHeading;
  final String selfCareStepsHeading;
  final String warningSignsWatchHeading;
  final String triageDisclaimer;
  final String facilityTitle;
  final String facilitySubtitle;
  final String offlineMapPreview;
  final String facilityDistance;
  final String facilityTypeHospital;
  final String facilityTypeClinic;
  final String facilityTypePharmacy;
  final String statusOpenNow;
  final String statusClosed;
  final String callFacility;
  final String offlineBadge;

  /// Returns localized progress text (e.g. "Question 1 of 3").
  String questionProgress(int current, int total) {
    return this == bangla
        ? '$current / $total নম্বর প্রশ্ন'
        : 'Question $current of $total';
  }

  /// Bangla (bn) translation map.
  static const AppStrings bangla = AppStrings._(
    appName: 'outpost',
    appTagline: 'নেটওয়ার্ক ছাড়াও, পাশে আছি',
    appOneLineTagline: 'সমস্যা কতটা জরুরি এবং এরপর কী করবেন?',
    chooseLanguageTitle: 'ভাষা বেছে নিন · Choose language',
    continueInBangla: 'বাংলায় শুরু করুন',
    continueInEnglish: 'English-এ এগিয়ে যান',
    securityNotice: 'নিরাপদে সংরক্ষিত • ইন্টারনেট লাগে না',
    conceptDisclaimer: 'ক্লিকযোগ্য কনসেপ্ট · চিকিৎসার চূড়ান্ত নির্দেশ নয়',
    offlineStatusBanner: 'অফলাইন • স্থানীয় সুরক্ষা নিয়ম সক্রিয়',
    navHome: 'শুরু',
    navHistory: 'ইতিহাস',
    navSettings: 'সেটিংস',
    btnNext: 'পরবর্তী',
    btnBack: 'পেছনে',
    btnCallEmergency: 'জরুরি কল (৯৯৯)',
    btnFindFacility: 'নিকটস্থ স্বাস্থ্যকেন্দ্র',
    startNewCheck: 'নতুন মূল্যায়ন শুরু করুন',
    emergencyCallSheetTitle: 'জাতীয় জরুরি সেবা (৯৯৯)',
    emergencyCallSheetNotice:
        'প্রোটোটাইপ ডায়ালারে ৯৯৯ প্রস্তুত করবে, স্বয়ংক্রিয় কোনো কল করবে না।',
    emergencyCallConfirm: 'ডায়ালার চালু করুন (৯৯৯)',
    emergencyCallDismiss: 'বাতিল',
    whoNeedsCareTitle: 'কার জন্য সাহায্য চান?',
    whoNeedsCareSubtitle: 'একটি বেছে নিয়ে এগিয়ে যান',
    forMyself: 'আমি',
    forChild: 'আমার শিশু',
    forPregnant: 'গর্ভবতী মা',
    privacyReassurance: 'আপনার তথ্য এই ফোনেই থাকে',
    privacySub: 'ফোনেই সংরক্ষিত। প্রয়োজনে পরে সিঙ্ক করতে পারবেন।',
    symptomsTitle: 'কী সমস্যা হচ্ছে?',
    symptomsSubtitle: 'প্রধান লক্ষণগুলো নির্বাচন করুন',
    voicePhase5Chip: 'ভয়েস ইনপুট (ফেজ ৫ আসছে)',
    voiceIntakePrompt: 'নিচের লক্ষণগুলো নির্বাচন করুন (ভয়েস ইনপুট ফেজ ৫-এ যুক্ত হবে)',
    symptomFever: 'জ্বর',
    symptomCoughBreathing: 'কাশি বা শ্বাসকষ্ট',
    symptomChestPain: 'বুকে তীব্র ব্যথা',
    symptomBleeding: 'রক্তক্ষরণ',
    symptomStomach: 'পেটে তীব্র ব্যথা',
    symptomHeadache: 'তীব্র মাথা ব্যথা',
    symptomVomitingDiarrhea: 'বমি বা পাতলা পায়খানা',
    symptomPregnancy: 'গর্ভকালীন সমস্যা',
    symptomInjury: 'আঘাত',
    symptomRash: 'ত্বকে ফুসকুড়ি',
    symptomDizziness: 'মাথা ঘোরা বা অজ্ঞান হওয়া',
    symptomOther: 'অন্যান্য লক্ষণ',
    followUpTitle: 'জরুরি প্রশ্নাবলী',
    followUpSubtitle: 'সঠিক সিদ্ধান্তের জন্য ৩টি প্রশ্নের উত্তর দিন',
    howLongHappening: 'কত দিন ধরে হচ্ছে?',
    durationToday: 'আজ শুরু হয়েছে',
    durationOneToTwo: '১–২ দিন',
    durationThreePlus: '৩ দিন বা বেশি',
    howSevereFeels: 'সমস্যা কতটা তীব্র?',
    severityMild: 'মৃদু',
    severityModerate: 'মাঝারি',
    severitySevere: 'তীব্র',
    areDangerSignsPresent: 'বিপদের কোনো লক্ষণ আছে?',
    dangerSignsGuidance: 'নিশ্চিত না হলে “হ্যাঁ, নিশ্চিত নই” বেছে নিন',
    dangerSignUnsureOption: 'হ্যাঁ, নিশ্চিত নই',
    dangerSignNoneOption: 'না, এর কোনটিই নয়',
    answerYes: 'হ্যাঁ',
    answerNo: 'না',
    answerUnsure: 'নিশ্চিত নই',
    triageResultTitle: 'ফলাফল',
    triageEmergency: 'জরুরি · Emergency',
    triageSeeClinicianToday: 'আজই ডাক্তার দেখান · See clinician today',
    triageHomeCare: 'বাড়িতে যত্ন · Home care',
    nextStepHeading: 'আপনার করণীয়',
    emergencyActionTitle: 'এখনই হাসপাতালে যান',
    emergencyActionSubtitle: 'সম্ভব হলে কাউকে সঙ্গে নিন।',
    clinicianTodayActionTitle: 'আজই চিকিৎসক দেখান',
    clinicianTodayActionSubtitle: 'বিশ্রাম নিন। সম্ভব হলে কাউকে সঙ্গে নিন।',
    homeCareActionTitle: 'এখন ঘরেই যত্ন নিন',
    homeCareActionSubtitle:
        'বিশ্রাম নিন এবং পর্যাপ্ত তরল পান করুন। সমস্যা বাড়লে স্বাস্থ্যকেন্দ্রে যান।',
    reasonHeading: 'কারণ ও ক্লিনিক্যাল মূল্যায়ন',
    guidelineSourceHeading: 'নির্দেশিকা সূত্র ও অধ্যায়',
    selfCareStepsHeading: 'যত্ন ও সতর্কতা',
    warningSignsWatchHeading: 'যেসব বিপদচিহ্ন লক্ষ্য রাখবেন',
    triageDisclaimer:
        'এটি ডব্লিউএইচও (WHO) নির্দেশিকা অনুযায়ী কাল্পনিক কেস-পরীক্ষিত প্রাথমিক প্রোটোটাইপ, কোনো চূড়ান্ত রোগ নির্ণয় নয়। গুরুতর সমস্যায় তাৎক্ষণিক জরুরি চিকিৎসা নিন।',
    facilityTitle: 'কাছের চিকিৎসাকেন্দ্র',
    facilitySubtitle: 'এই অঞ্চলের জন্য অফলাইনে সংরক্ষিত স্বাস্থ্যকেন্দ্রের তালিকা',
    offlineMapPreview: 'মান্দা, নওগাঁ • অফলাইন ম্যাপ প্রাকদর্শন',
    facilityDistance: 'দূরত্ব',
    facilityTypeHospital: 'উপজেলা স্বাস্থ্য কমপ্লেক্স',
    facilityTypeClinic: 'কমিউনিটি ক্লিনিক',
    facilityTypePharmacy: 'ফার্মেসি · জরুরি সেবা নয়',
    statusOpenNow: 'খোলা আছে',
    statusClosed: 'আপাতত বন্ধ',
    callFacility: 'কল',
    offlineBadge: 'অফলাইন • ইন্টারনেট প্রয়োজন নেই',
  );

  /// English (en) translation map.
  static const AppStrings english = AppStrings._(
    appName: 'outpost',
    appTagline: 'Care, even without a signal',
    appOneLineTagline: 'How urgent is this, and what should I do next?',
    chooseLanguageTitle: 'Choose language',
    continueInBangla: 'Start in Bangla',
    continueInEnglish: 'Continue in English',
    securityNotice: 'Saved privately • Works offline',
    conceptDisclaimer: 'Clickable concept · not for medical use',
    offlineStatusBanner: 'Offline • Local safety rules active',
    navHome: 'Home',
    navHistory: 'History',
    navSettings: 'Settings',
    btnNext: 'Next',
    btnBack: 'Back',
    btnCallEmergency: 'Call emergency (999)',
    btnFindFacility: 'Find nearest clinic',
    startNewCheck: 'Start New Check',
    emergencyCallSheetTitle: 'National Emergency Service (999)',
    emergencyCallSheetNotice:
        'Prototype launches the phone dialer with 999 ready; it does not place an automatic call.',
    emergencyCallConfirm: 'Launch Dialer (999)',
    emergencyCallDismiss: 'Cancel',
    whoNeedsCareTitle: 'Who needs care?',
    whoNeedsCareSubtitle: 'Choose one to continue',
    forMyself: 'Myself',
    forChild: 'My child',
    forPregnant: 'Someone pregnant',
    privacyReassurance: 'Your health data stays on this device',
    privacySub: 'Private on this device. Sync when you choose.',
    symptomsTitle: 'Choose a symptom',
    symptomsSubtitle: 'Select primary symptoms to continue',
    voicePhase5Chip: 'Voice (Phase 5 · Coming soon)',
    voiceIntakePrompt: 'Tap symptoms below (voice input coming in Phase 5)',
    symptomFever: 'Fever',
    symptomCoughBreathing: 'Cough / Breathing',
    symptomChestPain: 'Chest pain',
    symptomBleeding: 'Bleeding',
    symptomStomach: 'Stomach pain',
    symptomHeadache: 'Severe headache',
    symptomVomitingDiarrhea: 'Vomiting / Diarrhea',
    symptomPregnancy: 'Pregnancy concern',
    symptomInjury: 'Injury / trauma',
    symptomRash: 'Skin rash',
    symptomDizziness: 'Dizziness / faint',
    symptomOther: 'Other symptom',
    followUpTitle: 'Follow-up questions',
    followUpSubtitle: 'Step through 3 quick questions for a safe assessment',
    howLongHappening: 'How long has this been happening?',
    durationToday: 'Today',
    durationOneToTwo: '1–2 days',
    durationThreePlus: '3+ days',
    howSevereFeels: 'How severe does it feel?',
    severityMild: 'Mild',
    severityModerate: 'Moderate',
    severitySevere: 'Severe',
    areDangerSignsPresent: 'Are any danger signs present?',
    dangerSignsGuidance: 'If unsure, select "Yes, I am not sure"',
    dangerSignUnsureOption: 'Yes, I am not sure',
    dangerSignNoneOption: 'No, none of these',
    answerYes: 'Yes',
    answerNo: 'No',
    answerUnsure: 'Not sure',
    triageResultTitle: 'Triage Result',
    triageEmergency: 'Emergency',
    triageSeeClinicianToday: 'See a clinician today',
    triageHomeCare: 'Home care',
    nextStepHeading: 'Your next step',
    emergencyActionTitle: 'Go to a hospital now',
    emergencyActionSubtitle: 'Ask someone to go with you if possible.',
    clinicianTodayActionTitle: 'See a clinician today',
    clinicianTodayActionSubtitle: 'Rest. Ask someone to go with you.',
    homeCareActionTitle: 'Home care',
    homeCareActionSubtitle: 'Rest and drink fluids. Get help if worse.',
    reasonHeading: 'Clinical assessment rationale',
    guidelineSourceHeading: 'Guideline source citation',
    selfCareStepsHeading: 'Safe self-care & precautions',
    warningSignsWatchHeading: 'Warning signs to watch for',
    triageDisclaimer:
        'Vignette-tested prototype, not a medical diagnosis. In severe distress, seek emergency medical care immediately.',
    facilityTitle: 'Nearby facilities',
    facilitySubtitle: 'Offline cached facilities for this district',
    offlineMapPreview: 'Manda, Naogaon • Offline Map Preview',
    facilityDistance: 'Distance',
    facilityTypeHospital: 'Hospital / clinic',
    facilityTypeClinic: 'Community Clinic',
    facilityTypePharmacy: 'Pharmacy · not emergency care',
    statusOpenNow: 'Open now',
    statusClosed: 'Closed',
    callFacility: 'Call',
    offlineBadge: 'Offline • No signal needed',
  );

  /// Resolves the string translations for the specified [AppLanguage].
  static AppStrings of(AppLanguage language) {
    return switch (language) {
      AppLanguage.bn => bangla,
      AppLanguage.en => english,
    };
  }
}
