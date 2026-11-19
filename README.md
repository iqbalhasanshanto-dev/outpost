# Outpost (আউটপোস্ট)

> **HealthSphere AI — CareAnywhere Preliminary Submission**  
> **One-line Pitch:** An offline-first, bilingual (Bangla/English) triage application that determines clinical urgency and next steps—never diagnosis—for rural and low-bandwidth communities.

---

## 1. Problem & Target Users

In rural Bangladesh and underserved low-bandwidth regions worldwide, healthcare facilities are often kilometers away over challenging terrain. When illness strikes, patients and caregivers face a critical question: *"Is this an emergency requiring immediate hospital travel, or can it wait?"*

- **The Problem:**
  - **Connectivity gaps:** Commercial symptom checkers require constant internet access, leaving rural populations stranded during network outages.
  - **Language & literacy barriers:** Most digital health tools are English-centric and text-heavy, failing low-literacy rural families.
  - **Diagnostic overreach:** AI tools that attempt to diagnose or prescribe create severe clinical and liability risks in field settings.
  - **Delayed emergency care:** Treatable pediatric (IMCI) and maternal complications frequently progress to fatal stages before families recognize danger signs.

- **Target Users:**
  1. **Rural Caregivers & Patients:** Need simple Bangla/English UI, low-literacy visual icons, instant offline urgency determinations, and nearby facility guidance.
  2. **Parents & Expectant Mothers:** Need prioritized detection for pediatric IMCI general danger signs and obstetric red flags.
  3. **Community Health Workers (CHWs):** Need a fast, dependable protocol-driven triage guide in Airplane Mode.
  4. **Reviewing Clinicians:** Need a web-based queue to audit, confirm, or override flagged field cases.

---

## 2. Solution & Safety Architecture

Outpost enforces a strict, layered clinical decision pipeline where deterministic safety rules take absolute precedence over probabilistic models.

```
┌────────────────────────────────────────────────────────┐
│               Patient Intake (Android)                 │
│      Low-Literacy Icon Grid + Bangla/English Select    │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  LAYER 1: Deterministic Red-Flag Safety Rules Engine    │
│  • 9 Hardcoded Danger Signs (Adult, Child, Pregnancy)   │
│  • Immediately triggers EMERGENCY if detected          │
│  • CANNOT be downgraded or overridden downstream       │
└──────────────────────────┬─────────────────────────────┘
                           │ (If no red flags)
                           ▼
┌────────────────────────────────────────────────────────┐
│  LAYER 2: Protocol Level Assignment & Guidance         │
│  • Duration, severity, and patient vulnerability checks│
│  • WHO IMCI, MCPC, and Primary Care Guideline mapping  │
│  • Strict Uncertainty Escalation (escalates to doctor) │
└──────────────────────────┬─────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────┐
│  LAYER 3: 3-Tier Urgency Determination Output           │
│  [ Emergency ]  |  [ See Clinician Today ]  | [ Home Care ]
│  • Plain-language bilingual rationale                  │
│  • Grounded WHO chapter & section citations            │
│  • Offline nearest health facility listing             │
└──────────────────────────┬─────────────────────────────┘
                           │ (When connectivity resumes)
                           ▼
┌────────────────────────────────────────────────────────┐
│  LAYER 4: Clinician-in-the-Loop Review (Web Portal)    │
│  • Flagged Case Queue (Confirm / Override with note)   │
└────────────────────────────────────────────────────────┘
```

### The Three Urgency Tiers
1. **Emergency (জরুরি):** Critical danger sign detected. Urgent hospital referral with one-tap national emergency dispatch (999).
2. **See a Clinician Today (আজই ডাক্তার দেখান):** Moderate, worsening, or prolonged (3+ days) symptoms, or clinical uncertainty. Directs to local Upazila Health Complex or Community Clinic within 24 hours.
3. **Home Care (বাড়িতে যত্ন):** Mild, short-duration symptoms with zero danger signs. Provides safe, non-medicinal supportive guidance (rest, safe hydration, warning signs to watch).

---

## 3. Strict Scope & Clinical Guardrails

To protect patient safety in real-world deployment, Outpost adheres to non-negotiable boundaries:

| Guardrail | What Outpost Enforces | What Outpost NEVER Does |
|---|---|---|
| **Urgency vs. Diagnosis** | Evaluates **urgency and where to go next** | **Never diagnoses diseases** (no "You have pneumonia") |
| **Medication Safety** | Non-pharmacological self-care (fluids, rest) | **Never prescribes, names, or doses medications** |
| **Rule Primacy** | Deterministic red flags run first and lock to Emergency | **No AI or algorithm can downgrade a red flag** |
| **Uncertainty Fallback** | Unclear/empty inputs fail safe to *See a Clinician Today* | **Never defaults to Home Care on ambiguity** |
| **Evidence Grounding** | Every result shows an exact WHO guideline citation | **No fabricated medical explanations** |
| **Clinical Claims** | Described strictly as **vignette-tested prototype** | **Never claims clinical validation** |
| **Device Resources** | Lightweight local Dart rule execution; zero heavy models | **No on-device LLM battery or thermal drain** |

---

## 4. Tech Stack & Repository Structure

```
outpost/
├── app/                  # Flutter Android mobile application
│   ├── lib/
│   │   ├── core/         # Theme (Figma tokens), spacing, enums, routes
│   │   ├── domain/       # Triage entities, RedFlagEngine, TriageEngine
│   │   ├── data/         # Mock facility database (Manda, Naogaon district)
│   │   ├── presentation/ # Screens, reusable widgets, Riverpod state
│   │   └── l10n/         # Bangla & English ARB files and AppStrings
│   └── test/             # RedFlagEngine, TriageEngine, and Widget unit tests
├── backend/              # FastAPI server (Phase 3 sync & online RAG)
├── dashboard/            # Next.js clinician audit portal (Phase 4 review queue)
├── eval/                 # Vignette benchmark test suite (40+ clinical vignettes)
└── data/                 # Bundled offline OpenStreetMap & WHO guideline passages
```

- **Mobile App:** Flutter 3, Dart 3, Material 3, Noto Sans Bengali typography.
- **State Management:** Riverpod 3 (`languageProvider`, `triageProvider`).
- **Offline Storage:** Bundled assets & local cache; zero external cloud dependencies for Phase 1 triage.

---

## 5. Current Prototype Status (Phase 1)

Phase 1 is complete, providing a 100% offline-operable prototype:
- [x] Initialized Flutter architecture matching `Architecture.md` specifications.
- [x] Extracted exact Figma design tokens, colors (`#006B60` Teal, `#B3261E` Red, `#825500` Amber, `#226C39` Green), and typography into `AppColors` and `AppTheme`.
- [x] Built the 9 hardcoded deterministic red-flag rules covering adult, child (IMCI), and maternal obstetric danger signs.
- [x] Implemented `TriageEngine` with 3-tier classification, WHO citations, non-medicinal supportive home-care steps, and fail-safe uncertainty escalation.
- [x] Created all Phase 1 screens (`SplashScreen`, `WhoForScreen`, `SymptomIntakeScreen`, `FollowUpScreen`, `TriageResultScreen`, `NearestFacilityScreen`).
- [x] Built reusable components: `OfflineStatusBanner`, `SymptomCard`, and `TriageBadge`.
- [x] Complete bilingual localization in `l10n/` with reactive instant switching (zero hardcoded strings).
- [x] 18 automated unit and widget tests passing with 0 analyzer issues.

---

## 6. How to Run `app/`

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.19+ / Dart 3.3+)
- Android Studio / Android Emulator or connected physical device (macOS desktop also supported for rapid evaluation)

### Running the App
```bash
# 1. Navigate to the mobile application directory
cd app

# 2. Install dependencies
flutter pub get

# 3. Verify static analysis and test suite
flutter analyze
flutter test

# 4. Launch the application
flutter run
```

---

## 7. 60-Second Demo Walkthrough for Judges

Try these two representative test paths to observe Outpost's safety architecture in action:

### Scenario A: Deterministic Emergency Red-Flag Catch (Child IMCI)
1. **Welcome Screen:** Tap **"বাংলায় শুরু করুন"** or toggle language in the top-right corner to **English** to observe instant full-app reactivity.
2. **Who Needs Care:** Select **"My child" (আমার শিশু)**.
3. **Choose a Symptom:** Select **"Fever" (জ্বর)** and tap **Next**.
4. **Follow-Up Questions:**
   - *Duration:* Select **"Today" (আজ শুরু হয়েছে)**.
   - *Severity:* Select **"Severe" (তীব্র)**.
   - *Danger Signs:* Select **"Child is unable to drink or breastfeed"** (or tap **"Yes, I am not sure"**).
5. **Triage Result:**
   - Immediately displays **Emergency (জরুরি)** in bold red (`#B3261E`).
   - Cites **WHO Integrated Management of Childhood Illness (IMCI)** guidelines.
   - Highlights the prominent **"Call emergency (999)"** button (launches mock dialer confirmation sheet) and **"Find nearest clinic"**.
6. **Nearby Facilities:** Displays sorted cached healthcare centers in Manda Upazila (Upazila Health Complex, Community Clinic, Pharmacy) with distances and transit times.

### Scenario B: Safe Home Care (Adult Mild Symptoms)
1. **Reset Flow:** Tap **"Start New Check" (নতুন মূল্যায়ন শুরু করুন)** from the result or facilities screen.
2. **Who Needs Care:** Select **"Myself" (আমি)**.
3. **Choose a Symptom:** Select **"Cough / Breathing" (কাশি বা শ্বাসকষ্ট)** and tap **Next**.
4. **Follow-Up Questions:**
   - *Duration:* Select **"Today" (আজ শুরু হয়েছে)**.
   - *Severity:* Select **"Mild" (মৃদু)**.
   - *Danger Signs:* Tap **"No, none of these" (না, এর কোনটিই নয়)**.
5. **Triage Result:**
   - Displays **Home Care (বাড়িতে যত্ন)** in green (`#226C39`).
   - Cites **WHO Integrated Primary Care Guidance**.
   - Displays safe non-pharmacological steps (adequate safe fluids, rest, infant feeding continuation) and warning signs to monitor.
   - Notice that **zero medication names or dosages** are provided, adhering strictly to patient safety boundaries.
