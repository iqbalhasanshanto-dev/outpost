import '../core/constants/triage_enums.dart';

/// Strongly typed localization string repository for Outpost Phase 1.
///
/// Contains comprehensive Bangla and English translations for all screens.
/// Guarantees compile-time safety and prevents hardcoding user-facing strings.
class AppStrings {
  const AppStrings._({
    required this.appName,
    required this.appTagline,
    required this.chooseLanguageTitle,
    required this.continueInBangla,
    required this.continueInEnglish,
    required this.securityNotice,
    required this.conceptDisclaimer,
    required this.navHome,
    required this.navHistory,
    required this.navSettings,
    required this.btnNext,
    required this.btnBack,
    required this.btnCallEmergency,
    required this.btnFindFacility,
    required this.whoNeedsCareTitle,
    required this.whoNeedsCareSubtitle,
    required this.forMyself,
    required this.forChild,
    required this.forPregnant,
    required this.privacyReassurance,
    required this.privacySub,
    required this.symptomsTitle,
    required this.symptomsSubtitle,
    required this.voiceIntakePrompt,
    required this.symptomFever,
    required this.symptomCough,
    required this.symptomBreathing,
    required this.symptomChestPain,
    required this.symptomStomach,
    required this.symptomHeadache,
    required this.symptomBleeding,
    required this.symptomDiarrhea,
    required this.symptomInjury,
    required this.symptomRash,
    required this.symptomDizziness,
    required this.symptomOther,
    required this.followUpTitle,
    required this.followUpSubtitle,
    required this.answerYes,
    required this.answerNo,
    required this.answerUnsure,
    required this.triageResultTitle,
    required this.triageEmergency,
    required this.triageSeeClinicianToday,
    required this.triageHomeCare,
    required this.reasonHeading,
    required this.guidelineSourceHeading,
    required this.triageDisclaimer,
    required this.facilityTitle,
    required this.facilitySubtitle,
    required this.facilityDistance,
    required this.facilityTypeHospital,
    required this.facilityTypeClinic,
    required this.facilityTypePharmacy,
    required this.offlineBadge,
  });

  final String appName;
  final String appTagline;
  final String chooseLanguageTitle;
  final String continueInBangla;
  final String continueInEnglish;
  final String securityNotice;
  final String conceptDisclaimer;
  final String navHome;
  final String navHistory;
  final String navSettings;
  final String btnNext;
  final String btnBack;
  final String btnCallEmergency;
  final String btnFindFacility;
  final String whoNeedsCareTitle;
  final String whoNeedsCareSubtitle;
  final String forMyself;
  final String forChild;
  final String forPregnant;
  final String privacyReassurance;
  final String privacySub;
  final String symptomsTitle;
  final String symptomsSubtitle;
  final String voiceIntakePrompt;
  final String symptomFever;
  final String symptomCough;
  final String symptomBreathing;
  final String symptomChestPain;
  final String symptomStomach;
  final String symptomHeadache;
  final String symptomBleeding;
  final String symptomDiarrhea;
  final String symptomInjury;
  final String symptomRash;
  final String symptomDizziness;
  final String symptomOther;
  final String followUpTitle;
  final String followUpSubtitle;
  final String answerYes;
  final String answerNo;
  final String answerUnsure;
  final String triageResultTitle;
  final String triageEmergency;
  final String triageSeeClinicianToday;
  final String triageHomeCare;
  final String reasonHeading;
  final String guidelineSourceHeading;
  final String triageDisclaimer;
  final String facilityTitle;
  final String facilitySubtitle;
  final String facilityDistance;
  final String facilityTypeHospital;
  final String facilityTypeClinic;
  final String facilityTypePharmacy;
  final String offlineBadge;

  /// Bangla (bn) translation map.
  static const AppStrings bangla = AppStrings._(
    appName: 'outpost',
    appTagline: 'নেটওয়ার্ক ছাড়াও, পাশে আছি',
    chooseLanguageTitle: 'ভাষা বেছে নিন · Choose language',
    continueInBangla: 'শুরু করুন',
    continueInEnglish: 'English-এ এগিয়ে যান',
    securityNotice: 'নিরাপদে সংরক্ষিত • ইন্টারনেট লাগে না',
    conceptDisclaimer: 'ক্লিকযোগ্য কনসেপ্ট · চিকিৎসার চূড়ান্ত নির্দেশ নয়',
    navHome: 'শুরু',
    navHistory: 'ইতিহাস',
    navSettings: 'সেটিংস',
    btnNext: 'পরবর্তী',
    btnBack: 'পেছনে',
    btnCallEmergency: 'জরুরি কল করুন',
    btnFindFacility: 'নিকটস্থ স্বাস্থ্যকেন্দ্র',
    whoNeedsCareTitle: 'কার জন্য সাহায্য চান?',
    whoNeedsCareSubtitle: 'একটি বেছে নিন',
    forMyself: 'আমি',
    forChild: 'আমার শিশু',
    forPregnant: 'গর্ভবতী মা',
    privacyReassurance: 'আপনার তথ্য এই ফোনেই থাকে',
    privacySub: 'ফোনেই সংরক্ষিত। প্রয়োজনে পরে সিঙ্ক করতে পারবেন।',
    symptomsTitle: 'লক্ষণ নির্বাচন করুন',
    symptomsSubtitle: 'কী কী শারীরিক সমস্যা হচ্ছে?',
    voiceIntakePrompt: 'মুখে বলুন অথবা নিচের লক্ষণগুলো বাছাই করুন',
    symptomFever: 'জ্বর',
    symptomCough: 'কাশি',
    symptomBreathing: 'শ্বাসকষ্ট',
    symptomChestPain: 'বুকে ব্যথা',
    symptomStomach: 'পেট ব্যথা',
    symptomHeadache: 'তীব্র মাথা ব্যথা',
    symptomBleeding: 'রক্তক্ষরণ',
    symptomDiarrhea: 'পাতলা পায়খানা',
    symptomInjury: 'আঘাত',
    symptomRash: 'ত্বকে ফুসকুড়ি',
    symptomDizziness: 'মাথা ঘোরা বা অজ্ঞান হওয়া',
    symptomOther: 'অন্যান্য লক্ষণ',
    followUpTitle: 'জরুরি প্রশ্নাবলী',
    followUpSubtitle: 'সঠিক সিদ্ধান্তের জন্য কয়েকটি প্রশ্নের উত্তর দিন',
    answerYes: 'হ্যাঁ',
    answerNo: 'না',
    answerUnsure: 'নিশ্চিত নই',
    triageResultTitle: 'ফলাফল',
    triageEmergency: 'জরুরি · Emergency',
    triageSeeClinicianToday: 'আজই ডাক্তার দেখান · See clinician today',
    triageHomeCare: 'বাড়িতে যত্ন · Home care',
    reasonHeading: 'কারণ ও ক্লিনিক্যাল মূল্যায়ন',
    guidelineSourceHeading: 'নির্দেশিকা সূত্র',
    triageDisclaimer:
        'এটি ডব্লিউএইচও (WHO) নির্দেশিকা অনুযায়ী কাল্পনিক কেস-পরীক্ষিত প্রাথমিক মূল্যায়ন, কোনো চূড়ান্ত প্রেসক্রিপশন বা রোগ নির্ণয় নয়। গুরুতর সমস্যায় তাৎক্ষণিক জরুরি চিকিৎসা নিন।',
    facilityTitle: 'নিকটস্থ স্বাস্থ্যকেন্দ্র',
    facilitySubtitle: 'এই অঞ্চলের জন্য অফলাইনে সংরক্ষিত স্বাস্থ্যকেন্দ্রের তালিকা',
    facilityDistance: 'দূরত্ব',
    facilityTypeHospital: 'উপজেলা স্বাস্থ্য কমপ্লেক্স',
    facilityTypeClinic: 'কমিউনিটি ক্লিনিক',
    facilityTypePharmacy: 'ফার্মেসি / প্রাথমিক চিকিৎসা',
    offlineBadge: 'অফলাইন • ইন্টারনেট প্রয়োজন নেই',
  );

  /// English (en) translation map.
  static const AppStrings english = AppStrings._(
    appName: 'outpost',
    appTagline: 'Care, even without a signal',
    chooseLanguageTitle: 'Choose language',
    continueInBangla: 'Start',
    continueInEnglish: 'Continue in English',
    securityNotice: 'Saved privately • Works offline',
    conceptDisclaimer: 'Clickable concept · not for medical use',
    navHome: 'Home',
    navHistory: 'History',
    navSettings: 'Settings',
    btnNext: 'Next',
    btnBack: 'Back',
    btnCallEmergency: 'Call Emergency',
    btnFindFacility: 'Find Nearest Facility',
    whoNeedsCareTitle: 'Who needs care?',
    whoNeedsCareSubtitle: 'Choose one',
    forMyself: 'Myself',
    forChild: 'My child',
    forPregnant: 'Pregnant woman',
    privacyReassurance: 'Your health data stays on this device',
    privacySub: 'Private on this device. Sync when you choose.',
    symptomsTitle: 'Select symptoms',
    symptomsSubtitle: 'What problems are you experiencing?',
    voiceIntakePrompt: 'Tap to speak or select symptoms below',
    symptomFever: 'Fever',
    symptomCough: 'Cough',
    symptomBreathing: 'Difficulty breathing',
    symptomChestPain: 'Chest pain',
    symptomStomach: 'Stomach pain',
    symptomHeadache: 'Severe headache',
    symptomBleeding: 'Bleeding',
    symptomDiarrhea: 'Diarrhea',
    symptomInjury: 'Injury / trauma',
    symptomRash: 'Skin rash',
    symptomDizziness: 'Dizziness / faint',
    symptomOther: 'Other symptom',
    followUpTitle: 'Follow-up questions',
    followUpSubtitle: 'Answer a few questions for an accurate assessment',
    answerYes: 'Yes',
    answerNo: 'No',
    answerUnsure: 'Not sure',
    triageResultTitle: 'Triage Result',
    triageEmergency: 'Emergency',
    triageSeeClinicianToday: 'See a clinician today',
    triageHomeCare: 'Home care',
    reasonHeading: 'Clinical assessment rationale',
    guidelineSourceHeading: 'Guideline source',
    triageDisclaimer:
        'Vignette-tested guidance based on WHO protocols. Not a medical diagnosis. In severe distress, seek emergency medical care immediately.',
    facilityTitle: 'Nearest Facilities',
    facilitySubtitle: 'Offline cached facilities for this district',
    facilityDistance: 'Distance',
    facilityTypeHospital: 'Upazila Health Complex',
    facilityTypeClinic: 'Community Clinic',
    facilityTypePharmacy: 'Pharmacy / First Aid',
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
