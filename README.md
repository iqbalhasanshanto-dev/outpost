# Outpost (আউটপোস্ট)

### HealthSphere AI — CareAnywhere Preliminary Submission

> [!IMPORTANT]
> **Preliminary Prototype Notice:** This repository currently implements the **Phase 1 Preliminary Prototype**—a working, 100% offline-operable mobile application built with Flutter, driven by deterministic red-flag rules and local mock facility data. All outputs and protocols are **vignette-tested prototypes, not clinically validated diagnostic systems**.

**One-line Pitch:** An offline-first, bilingual (Bangla/English) triage application that determines clinical urgency and next steps—never diagnosis—for rural and low-bandwidth communities.

---

## 1. Problem & Target Users

In rural Bangladesh and remote, low-bandwidth communities worldwide, health centers are often hours away over difficult terrain. When illness strikes, patients and caregivers face an agonizing question: *"Is this an emergency requiring immediate hospital travel, or can it safely be managed at home?"*

- **The Problem:**
  - **Connectivity gaps:** Mainstream symptom checkers demand continuous high-speed internet, leaving rural populations stranded during frequent blackouts and network outages.
  - **Language & literacy barriers:** Digital health tools are predominantly English-centric and text-heavy, alienating low-literacy rural families.
  - **Diagnostic overreach:** Systems that attempt to diagnose illnesses or recommend medications introduce hazardous clinical risks in unmonitored field settings.
  - **Delayed emergency escalation:** Treatable childhood illnesses (IMCI) and maternal obstetric complications frequently turn fatal because families fail to recognize critical danger signs in time.

- **Target Users:**
  1. **Rural Caregivers & Patients:** Need a visual, icon-driven Bangla/English interface providing instant offline urgency decisions and facility directions.
  2. **Parents & Expectant Mothers:** Need prioritized screening for pediatric IMCI general danger signs and maternal obstetric red flags.
  3. **Community Health Workers (CHWs):** Need a fast, protocol-guided bedside triage tool that functions reliably in Airplane Mode.
  4. **Reviewing Clinicians:** Need a web-based flagged case queue to audit, confirm, or override triage outcomes when connectivity is available.

---

## 2. Safety Architecture & Decision Pipeline

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
2. **See a Clinician Today (আজই ডাক্তার দেখান):** Moderate, worsening, or prolonged (3+ days) symptoms, or clinical uncertainty. Directs to a local Upazila Health Complex or Community Clinic within 24 hours.
3. **Home Care (বাড়িতে যত্ন):** Mild, short-duration symptoms with zero danger signs. Provides safe, non-medicinal supportive guidance (rest, safe hydration, infant feeding continuation, warning signs to watch).

---

## 3. Strict Scope & Clinical Guardrails

To protect patient safety in real-world deployment, Outpost adheres to non-negotiable boundaries:

| Guardrail | What Outpost Enforces | What Outpost NEVER Does |
|---|---|---|
| **Urgency vs. Diagnosis** | Evaluates **urgency and where to go next** | **Never diagnoses diseases** (no "You have pneumonia") |
| **Medication Safety** | Non-pharmacological self-care (fluids, rest) | **Never prescribes, names, or doses medications** |
| **Rule Primacy** | Deterministic red flags run first and lock to Emergency | **No AI or algorithm can downgrade a red flag** |
| **Uncertainty Fallback** | Unclear/empty inputs fail safe to *See a Clinician Today* | **Never defaults to Home Care on ambiguity** |
| **Evidence Grounding** | Every result shows an exact WHO guideline citation | **No hallucinated or ungrounded medical guidance** |
| **Clinical Claims** | Described strictly as **vignette-tested prototype** | **Never claims clinical validation** |
| **Device Resources** | Lightweight local Dart rule execution; zero heavy models | **No on-device LLM battery or thermal drain** |

---

## 4. What's Working Today (Phase 1 Prototype)

The preliminary prototype in `app/` is 100% complete, fully offline-functional, and test-verified:
- **Bilingual Bangla/English UI:** Reactive, instantaneous switching via Riverpod with zero hardcoded user-facing strings across all widgets.
- **6 Interactive Screens:** Welcome/Language (`SplashScreen`), Patient Category (`WhoForScreen`), Symptom Picker (`SymptomIntakeScreen`), 3-step Guided Follow-up (`FollowUpScreen`), Urgency Outcome (`TriageResultScreen`), and Nearby Facilities (`NearestFacilityScreen`).
- **9 Deterministic Red-Flag Rules:** Hardcoded danger signs covering adult cardiovascular/respiratory emergencies, pediatric IMCI danger signs (unable to drink, vomiting everything), and maternal obstetric red flags (severe abdominal pain, bleeding, pre-eclampsia headache/vision changes).
- **WHO Protocol Grounding:** Specific document and section citations (WHO IMCI, ETAT, MCPC, PEN) attached to every triage decision.
- **Mock Facility Directory:** 5 realistic healthcare facilities for Manda Upazila (Naogaon district) sorted by distance with transit times and phone contacts.
- **Verification:** 18 automated unit and widget tests passing with 0 analyzer issues (`flutter analyze` clean).

---

## 5. Planned Development Roadmap (Phases 2 – 7)

Following the preliminary submission, Outpost will progress across the remaining phases detailed in `phases.md`:

| Phase | Milestone | Key Deliverables & Architecture |
|---|---|---|
| **Phase 2** | **Offline Triage Core** | • Local SQLite database via **Drift**<br>• Real WHO IMCI and Primary Care guideline chunks indexed with **SQLite FTS5**<br>• Dynamic follow-up flow with uncertainty escalation<br>• On-device patient case history |
| **Phase 3** | **Backend & Store-and-Forward Sync** | • Lightweight **FastAPI + SQLite** backend<br>• `/sync` and `/cases` endpoints<br>• Background offline queue with **WorkManager** and **connectivity_plus**<br>• Manual "Sync Now" button for instant synchronization |
| **Phase 4** | **Clinician Review Portal (Web)** | • **Next.js** clinician portal with secure clinician authentication<br>• Flagged Case Queue for emergency & escalated cases<br>• Confirm / Override actions with clinician notes syncing back to patient devices |
| **Phase 5** | **Bangla Voice & Retrieval-Constrained AI** | • On-device Android speech recognizer with visual picker fallback<br>• Online **Whisper** transcription upgrade<br>• **FAISS RAG + LLM** plain-language Bangla explanations strictly constrained to retrieved WHO passages (no ungrounded generation) |
| **Phase 6** | **Real Facilities & Offline Maps** | • Bundled OpenStreetMap clinic and pharmacy data for the target district<br>• **flutter_map** integration (no paid or key-gated map APIs)<br>• Offline Haversine distance and travel-time estimates |
| **Phase 7** | **Vignette Evaluation & Final Polish** | • Benchmark against **40–50 clinical vignettes** with gold-standard urgency labels<br>• Measure accuracy, under-triage rate, offline completion rate, and time-to-result<br>• Field UI polish and clinical stakeholder review |

---

## 6. Tech Stack & Repository Structure

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

- **Mobile Framework:** Flutter 3, Dart 3, Material 3, Noto Sans Bengali typography.
- **State Management:** Riverpod 3 (`languageProvider`, `triageProvider`).
- **Offline Storage:** Bundled assets & local cache; zero external cloud dependencies for Phase 1 triage.

---

## 7. How to Run `app/`

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

## 8. 60-Second Demo Walkthrough for Judges

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
