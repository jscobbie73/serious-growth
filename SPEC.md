# Serious Growth — iOS App Specification

**Version:** 0.2
**Status:** Updated — Incorporating Review Feedback
**Last Updated:** 2026-05-12
**Changes from v0.1:** All open questions resolved except OQ-7 (see conflict note); reviewer feedback incorporated throughout; data model expanded; First Launch Onboarding section added; 72-day schedule and exercise library appendices added.

---

## Table of Contents

1. [Purpose & Goals](#1-purpose--goals)
2. [Target Users](#2-target-users)
3. [Program Overview (Source Material)](#3-program-overview-source-material)
4. [Feature Inventory](#4-feature-inventory)
5. [Screens & User Flows](#5-screens--user-flows)
6. [Data Model](#6-data-model)
7. [Business Logic](#7-business-logic)
8. [iCloud Sync](#8-icloud-sync)
9. [Non-Functional Requirements](#9-non-functional-requirements)
10. [Out of Scope (v1)](#10-out-of-scope-v1)
11. [Resolved Decisions](#11-resolved-decisions)
12. [Future Roadmap](#12-future-roadmap)
13. [Appendix A — 72-Day Program Schedule](#appendix-a--72-day-program-schedule)
14. [Appendix B — Default Exercise Library](#appendix-b--default-exercise-library)

---

## 1. Purpose & Goals

**Serious Growth** is a native iOS app that guides a user through the Serious Growth Level 1 bodybuilding program — an 18-week, 4-day-per-week training plan — while logging every set, tracking progressive overload, and syncing data across all the user's Apple devices via iCloud.

### Goals
- Replace paper logs and generic note apps with a purpose-built experience for this specific program
- Remove cognitive load mid-workout: the app tells the user exactly what to do today (muscle groups, sets, rep range, rest period)
- Make progressive overload visible and actionable through weight history charts and automatic weight suggestions
- Build long-term consistency through streak tracking and check-in gamification
- Support multiple devices seamlessly via iCloud sync

### Non-Goals
- This is not a general-purpose workout builder
- This is not a social or community platform
- This is not a nutrition tracker

---

## 2. Target Users

**Primary:** An individual following the Serious Growth Level 1 program, training 4 days per week in a gym, using an iPhone during workouts.

**Secondary:** The same user on an iPad at home reviewing history, charts, and planning upcoming sessions.

**Assumed familiarity:** The user knows basic gym terminology (sets, reps, progressive overload) and has read the Serious Growth program guide.

---

## 3. Program Overview (Source Material)

The program is sourced from the provided Excel file (`f1d34ff9-lifting.xlsx`). Full 72-day schedule is in [Appendix A](#appendix-a--72-day-program-schedule).

### 18-Week Structure

| Phase | Name | Overall Weeks | Sets | Rest | Endurance Reps | Strength Reps | Power Reps |
|-------|------|---------------|------|------|----------------|---------------|------------|
| 1 | Ramp 1 | 1–3 | 3→4→5 | 120→90→90s | 13–15 | 10–12 | 8–10 |
| 2 | Supergrowth Phase 1 | 4–6 | 3 | 180s | 10–12 | 8–10 | 5–7 |
| 3 | Ramp 2 | 7–9 | 3→3→4 | 150→90→60s | 13–15 | 10–12 | 8–10 |
| 4 | Supergrowth Phase 2 | 10–12 | 4 | 90s | 13–15 | 10–12 | 8–10 |
| 5 | Ramp 3 | 13–15 | 3→3→4/5 | 120→120→120s | 13–15 | 10–12 | 8–10 |
| 6 | Supergrowth Phase 3 | 16–18 | 4 (Day1/2), 3 (Day3/4) | 60→60→120→180s | 13–15 | 8–10 | 4–6 |

### Cycle Types (same assignment every week within a phase)
- **Cycle A — Endurance:** Days 1 & 2
- **Cycle B — Strength:** Day 3
- **Cycle C — Power:** Day 4

### Muscle Groups
`Back` · `Chest` · `Bicep` · `Calf` · `Delts` · `Tricep` · `Thighs` · `Abs`

### Scheduling
- The program is **flexible** — the user performs each day's workout whenever they choose that week
- The app does not enforce or suggest specific calendar days
- Days are completed sequentially (Day 1 → Day 2 → Day 3 → Day 4 → next week Day 1)

---

## 4. Feature Inventory

### 4.1 Core Features — v1 (Must Have)

| ID | Feature | Description |
|----|---------|-------------|
| F-01 | Program Navigation | Display current phase, week, day; auto-advance after workout completion |
| F-02 | Manual Position Override | Allow user to set program position manually |
| F-03 | First Launch Onboarding | Unit selection, iCloud check, "Start Program" to initialize |
| F-04 | Workout Session | Start session for current day; log exercises, sets, reps, weight |
| F-05 | Session Resume | If app is killed mid-session, offer to resume on next launch |
| F-06 | Rest Timer | Countdown timer after each set completion; wall-clock accurate; skippable |
| F-07 | Weight Recommendation | Suggest next weight (last session max ×1.05); blank if no history |
| F-08 | Exercise Selection | Choose exercise per muscle group from library; pre-selects most recent |
| F-09 | Exercise Swap | Change exercise mid-session |
| F-10 | Exercise Library | 90+ built-in exercises, searchable, organized by muscle group |
| F-11 | Custom Exercises | Add and delete user-defined exercises per muscle group |
| F-12 | Workout History | Reverse-chronological log of past sessions with detail view |
| F-13 | Weight Progress Chart | Per-exercise line chart with date range filter |
| F-14 | Cardio Logging | Log sessions with optional type, distance, duration, heart rate |
| F-15 | Activity Streak | Track current and best consecutive-day streaks (workouts + cardio) |
| F-16 | iCloud Sync | All data syncs automatically via CloudKit |
| F-17 | Units Toggle | lbs / kg; stored canonically (see Section 7.4 and [OQ-7 conflict note](#oq-7-conflict)) |
| F-18 | Haptic Feedback | Pulse on set completion and rest timer zero; default on; toggle in Settings |
| F-19 | Program Complete State | Show completion screen at end of Week 18; offer restart |

### 4.2 Should Have — v1 if time permits

| ID | Feature | Description |
|----|---------|-------------|
| F-20 | Workout Duration | Track elapsed time from session start to completion |
| F-21 | Program Overview Reference | In-app card for all 18 weeks and parameters |
| F-22 | Cardio History Charts | Chart of cardio distance or duration over time |
| F-23 | Date Range Filter (Charts) | 30 days / 3 months / All time filter on weight progress charts |

### 4.3 Deferred to v1.1+

| ID | Feature | Notes |
|----|---------|-------|
| F-24 | Session Notes UI | `notes` field exists in model; UI deferred |
| F-25 | Push Notifications | Rest timer alert when app is backgrounded |
| F-26 | Keep Screen Awake | Prevent display sleep during active workout |
| F-27 | HealthKit Write | Write completed workouts to Apple Health |
| F-28 | Apple Watch | Log sets from wrist |
| F-29 | Body Weight Log | Chart body weight over time |
| F-30 | Audio Alert | Optional sound when rest timer ends |

---

## 5. Screens & User Flows

### 5.1 Navigation Structure

```
First Launch (one-time)
└── Onboarding Flow
    └── Main App

Main App
└── TabBar
    ├── Home          (house.fill)
    ├── History       (clock.fill)
    ├── Exercises     (dumbbell.fill)
    ├── Cardio        (figure.run)
    └── Settings      (gear)
```

---

### 5.2 First Launch Onboarding

**Shown once**, on first launch only. Creates `AppState` and seeds exercise library.

**Steps:**
1. **Welcome screen** — App name, tagline ("Your 18-week program. All in one place.")
2. **Unit selection** — Toggle: "Pounds (lbs)" / "Kilograms (kg)". Default: lbs.
3. **iCloud status** — If signed in: "Your data will sync across your devices automatically." If not: "Sign in to iCloud in Settings to enable sync. You can use the app offline."
4. **"Start Program"** button — Initializes `AppState` at Phase 1, Week 1, Day 1. Dismisses onboarding.

**Note:** There is no "Day 0" concept. The program begins at Phase 1, Week 1, Day 1.

---

### 5.3 Home Screen

**Purpose:** Daily driver — streaks, program position, today's workout.

**Content:**
- **Activity Streak Card**
  - Current streak (flame icon + count)
  - Best streak (trophy icon + count)
  - Label reads "Activity Streak" (counts workouts and cardio days equally)
- **Program Position Card**
  - Phase name and short code (e.g., "Ramp 1 · R1")
  - "Week 2 of 3 · Overall Week 5 of 18"
  - Progress bar (filled to current overall week / 18)
  - Focus description (e.g., "Progressive volume increase")
- **Today's Workout Card**
  - Day number and cycle type badge
  - Rep range and rest period
  - Muscle group chips, each showing group name + set count
  - CTA: **"Start Workout"** button (orange, full-width)
  - If today's session exists and is `completed`: replace button with "✓ Workout Logged" (green)
  - If today's session exists and is `inProgress`: replace button with "Resume Workout →" (orange)
  - If program is complete: show "🏆 Program Complete" with "Restart Program" option

**Nav bar:** Calendar icon → Program Position Picker sheet

**Behavior note:** Having a `completed` session for today does NOT disable the "Start Workout" button entirely — the user may want to log a second session (e.g., they came back for extra work). The "Workout Logged" label is informational, not a blocker. Tap again to start a new session for the same day.

---

### 5.4 Workout Session Screen (Modal, Full Screen)

**Triggered by:** "Start Workout" or "Resume Workout →" on Home.

**On open (new session):**
1. Create `WorkoutSession` record with `status = .inProgress`, `startedAt = now`
2. For each muscle group assignment in today's `WorkoutDay`:
   a. Determine preferred exercise (see [Section 7.5](#75-preferred-exercise))
   b. Create `SessionExercise`
   c. Create `WorkoutSet` records (one per assigned set count), pre-fill weight recommendation
3. Save to SwiftData immediately (enables resume)

**On open (resume):**
- Detect existing `inProgress` session matching current phase/week/day
- Load it and present as-is, preserving all entered data

**Screen Layout:**
```
NavigationBar: [Cancel]  "Day X — Cycle Type"  [Finish]
─────────────────────────────────────────────────────
[Rest Timer Banner — orange, when active]
─────────────────────────────────────────────────────
ScrollView:
  ExerciseCard (one per muscle group assignment, in order)
  ...
```

**ExerciseCard:**
```
[Icon] Exercise Name              [⇄ Swap]
       Muscle Group
[↑ Recommended: 135 lbs]

Set │ Target │ Weight    │ Reps │ ✓
─────────────────────────────────────
 1  │ 13–15  │ [135   ]  │ [15] │ ○
 2  │ 13–15  │ [135   ]  │ [15] │ ○
 3  │ 13–15  │ [135   ]  │ [15] │ ○
```
- Weight and reps fields are editable inline (decimal pad / number pad)
- Tap ✓ (circle) to complete a set → fills circle, dims row, triggers haptic, starts rest timer
- Tapping a completed set's ✓ again undoes completion

**Rest Timer Banner:**
- Displays: "Rest: 47s  [Skip]"
- Counts down from `WorkoutDay.restSeconds`
- Accurate from wall clock (`timerStartedAt + timerDurationSeconds - now`), survives app backgrounding
- On reaching zero: haptic pulse, banner changes to "Rest complete — go!" for 3 seconds, then dismisses
- "Skip" stops timer immediately, banner dismisses
- Starting a new set while timer is running resets timer to full duration

**Cancel:**
- Confirmation: "Discard this workout?" → deletes the `inProgress` session and all child records

**Finish:**
- Requires at least one set marked `isCompleted = true`
- Confirmation: "Finish & Save?"
- On confirm: sets `status = .completed`, `completedAt = now`, advances program position

**Exercise Swap Sheet:**
- Presented when user taps ⇄ on an ExerciseCard
- Shows exercise picker filtered to that muscle group
- On selection: updates `exerciseName` on `SessionExercise`, recalculates weight recommendation for all sets in that exercise

---

### 5.5 History Screen

**Segmented control:** Workouts | Cardio | Charts

#### Workouts Tab
- Reverse-chronological list of `WorkoutSession` records with `status == .completed`
- Each row: date, phase label, day label, muscle group list (truncated to 1 line), completed set count
- Tap → Workout Detail screen
- Swipe left → Delete (with confirmation)

#### Workout Detail Screen
- Summary: date/time, phase, day, duration (if `completedAt` is set)
- Section per `SessionExercise` (sorted by `sortOrder`): exercise name as header; each `WorkoutSet` as a row showing set #, weight × reps, checkmark

#### Cardio Tab
- Summary strip: total sessions, total miles (distance-tracked sessions only), total time (duration-tracked sessions only)
- Reverse-chronological list
- Each row: date, type icon + name, optional distance / duration / heart rate stats
- Swipe left → Delete

#### Charts Tab
- Muscle group filter pills (horizontal scroll)
- Exercise dropdown (only exercises that have logged history in selected group)
- **Date range control:** 30 Days | 3 Months | All Time (segmented or picker)
- Line chart: session date (x) vs. max weight per session (y)
  - Orange line + area fill + point markers
  - y-axis labeled with unit (lbs or kg)
- Below chart: Personal Record | Last Session | Sessions Logged stat tiles

---

### 5.6 Exercises Screen

**Purpose:** Browse and manage the exercise library.

- Horizontal muscle group filter pills at top (with icon per group)
- Search bar
- Sorted list: built-in first (alphabetical), custom after (newest first)
- Each row: exercise name; "Custom" badge on user-added; trash icon (custom only)

**Add Exercise (+):**
- Sheet: Name (text field), Muscle Group (picker)
- Saves as `isCustom = true`

**Delete Custom Exercise:**
- Swipe to delete or tap trash icon
- Confirmation alert
- Built-in exercises cannot be deleted

---

### 5.7 Cardio Screen

**Empty state:** Icon + "No cardio logged yet" + "Log Cardio" button

**When sessions exist:**
- Summary strip: sessions, total miles, total time
- List, reverse-chronological
- Each row: date, type, optional stats
- Swipe to delete

**Log Cardio Sheet:**
- Date/time picker (defaults to now)
- Cardio type picker (see Appendix B for list)
- Toggle: **Log Distance** → decimal field (miles)
- Toggle: **Log Duration** → minute + second steppers
- Toggle: **Log Avg Heart Rate** → BPM stepper (40–220 bpm)
- Optional Notes text field

---

### 5.8 Settings Screen

**Sections:**

**Units**
- Segment or toggle: lbs / kg
- Note: changing unit affects display and input only; stored values are unchanged

**Haptics**
- Toggle: "Haptic Feedback" (default: on)

**Program**
- Current position (phase, week, day) — read only
- "Change Program Position" → Program Position Picker sheet
- "Reset to Week 1" → destructive confirm

**Program Reference (expandable)**
- All 6 phases with week ranges, sets, rest, rep focus, and description

**Account / Sync**
- iCloud status: "Syncing" / "Up to date" / "Not signed in"

**About**
- App version
- Build number

---

## 6. Data Model

### 6.1 Entities

All entities include `updatedAt: Date` for CloudKit last-write-wins conflict resolution.

---

#### `AppState` (singleton — at most one record)

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| id | UUID | new | Primary key |
| currentPhaseIndex | Int | 0 | 0–5 |
| currentWeekIndex | Int | 0 | 0–2 within phase |
| currentDayIndex | Int | 0 | 0–3 |
| programStartDate | Date | now | When onboarding completed |
| unitSystem | String | "imperial" | "imperial" or "metric"; use `UnitSystem` enum in code |
| hapticsEnabled | Bool | true | |
| isProgramComplete | Bool | false | Set true when Phase 6 Week 3 Day 4 is completed |
| updatedAt | Date | now | CloudKit conflict resolution |

> **Developer note:** `unitSystem` is stored as a `String` raw value but should be accessed through a `UnitSystem` enum (`imperial` / `metric`) in Swift code.

---

#### `WorkoutSession`

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| id | UUID | new | Primary key |
| startedAt | Date | now | When session was created / started |
| completedAt | Date? | nil | Set on Finish; nil = in progress or incomplete |
| phaseIndex | Int | 0 | |
| weekIndex | Int | 0 | |
| dayIndex | Int | 0 | |
| status | String | "inProgress" | "inProgress" or "completed"; use `WorkoutSessionStatus` enum |
| notes | String | "" | Stored now; UI deferred to v1.1 |
| updatedAt | Date | now | |
| sessionExercises | [SessionExercise] | [] | Cascade delete |

> **Developer note:** `status` raw values map to `enum WorkoutSessionStatus: String { case inProgress, completed }`.

> **Computed:** `durationSeconds: Int` → `completedAt.timeIntervalSince(startedAt)` (calculated, not stored).

---

#### `SessionExercise`

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| id | UUID | new | Primary key |
| exerciseName | String | "" | Denormalized string — no FK to `Exercise` |
| muscleGroup | String | "" | Denormalized |
| sortOrder | Int | 0 | Display order within session |
| updatedAt | Date | now | |
| sets | [WorkoutSet] | [] | Cascade delete |

> **Design decision:** `exerciseName` is a plain string. Deleting an exercise from the library does not affect session history.

---

#### `WorkoutSet`

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| id | UUID | new | Primary key |
| setNumber | Int | 1 | 1-indexed within the exercise |
| targetRepsMin | Int | 0 | From program data |
| targetRepsMax | Int | 0 | From program data |
| completedReps | Int | 0 | User-entered; initialized to `targetRepsMax` |
| weightLbs | Double | 0.0 | **Always stored in lbs** (see [OQ-7 conflict note](#oq-7-conflict)) |
| isCompleted | Bool | false | |
| completedAt | Date? | nil | Set when user taps ✓ |
| updatedAt | Date | now | |

---

#### `Exercise` (Library)

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| id | UUID | new | Primary key |
| sourceID | String | "" | Stable identifier for idempotent seeding (e.g., "back.barbell_row"); empty for custom |
| name | String | "" | Display name |
| muscleGroup | String | "" | One of the 8 groups |
| isCustom | Bool | false | false = built-in, true = user-added |
| createdAt | Date | now | For ordering custom exercises |
| updatedAt | Date | now | |

> **`sourceID` rationale:** On first launch, built-in exercises are seeded with deterministic `sourceID` values. On re-seed (e.g., app update adds exercises), the app checks `sourceID` before inserting to avoid duplicates.

---

#### `CardioSession`

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| id | UUID | new | Primary key |
| date | Date | now | |
| cardioType | String | "Running" | |
| hasDistance | Bool | false | |
| distanceMiles | Double | 0.0 | Always stored in miles |
| hasDuration | Bool | false | |
| durationSeconds | Int | 0 | |
| hasHeartRate | Bool | false | |
| avgHeartRate | Int | 0 | bpm |
| notes | String | "" | |
| updatedAt | Date | now | |

---

### 6.2 Static / Compiled Data (Not in SwiftData)

| Data | Format | Notes |
|------|--------|-------|
| ProgramData | Swift constants | All 72 days; see Appendix A |
| ExerciseLibrary.defaults | Swift dictionary | See Appendix B |
| ExerciseLibrary.cardioTypes | Swift array | See Section 5.7 |

Built-in `Exercise` records are **seeded into SwiftData on first launch** using `sourceID` for deduplication so they are searchable alongside custom exercises.

---

### 6.3 ⚠️ OQ-7 Conflict — Weight Storage Unit

**This decision requires explicit sign-off before implementation.**

| Stakeholder | Position | Rationale |
|-------------|----------|-----------|
| **Owner (you)** | Store in active unit (whatever the user has selected at log time) | Simpler mental model; no conversion at entry time |
| **Reviewer** | Store canonically in lbs (`weightLbs`); convert only at display/input boundaries | Unit switching later will not corrupt old data; math is simpler; consistent with `distanceMiles` on `CardioSession` |

**Implications of each choice:**

*Active units (owner preference):*
- Must store a `unit: String` flag alongside every `weightLbs` field so the app knows what unit was used
- If user switches units, old data is displayed wrong unless the app knows the original unit
- Requires re-labeling the field to `weight` + `weightUnit` on `WorkoutSet`

*Canonical lbs (reviewer preference):*
- A single `weightLbs: Double` field; no per-record unit flag needed
- Unit change only affects the display layer
- Consistent with how `distanceMiles` is already designed on `CardioSession`
- Industry standard for fitness apps

**Current spec draft uses canonical lbs.** Please confirm or override.

---

## 7. Business Logic

### 7.1 Weight Recommendation

**Trigger:** `SessionExercise` creation (when a new workout session is set up).

**Algorithm:**
1. Search all `SessionExercise` records where `exerciseName == current exercise name`
2. Filter to parent `WorkoutSession` records with `status == .completed`
3. From the most recent such session (by `startedAt`), find all `WorkoutSet` where `isCompleted == true && weightLbs > 0`
4. Take the **maximum** `weightLbs` among those sets
5. `recommendedLbs = maxWeight × 1.05`
6. Round to nearest **2.5 lbs** (imperial) or nearest **1 kg** (metric)
7. Apply minimum floor of **5 lbs / 2.5 kg** — but **only** when a prior session exists. If no history: leave field blank (do not suggest 5 lbs)
8. Convert to display unit before showing in UI

**Example (lbs):** Last session max weight = 100 lbs → 100 × 1.05 = 105 → rounded to 105 lbs (already a multiple of 2.5)

**Example (kg display):** Stored 100 lbs → display = 100 / 2.20462 = 45.36 kg → rounded to 45.5 kg

---

### 7.2 Program Progression

**Trigger:** User taps "Finish & Save" on Workout Session screen.

**Algorithm:**
1. `newDay = currentDayIndex + 1`
2. If `newDay >= days in current week` (always 4): `newDay = 0`, `newWeek = currentWeekIndex + 1`
3. If `newWeek >= weeks in current phase` (always 3): `newWeek = 0`, `newPhase = currentPhaseIndex + 1`
4. If `newPhase >= 6` (total phases): do not increment; set `isProgramComplete = true`
5. Save new values to `AppState`

**Manual override:** Program Position Picker writes directly to `AppState`. Does not delete history or reset `isProgramComplete`.

---

### 7.3 Activity Streak

**Definition:** A "streak day" is any calendar date (local timezone) on which at least one `WorkoutSession` with `status == .completed` or any `CardioSession` was saved.

**Current Streak:**
1. Start from today (local calendar date)
2. Walk backward day by day
3. Count each day that has at least one qualifying session
4. Stop at the first calendar day with no activity
5. If today has no activity yet, start counting from yesterday (streak is not broken until the day is over)

**Longest Streak:**
1. Collect all unique streak days from both session types
2. Sort ascending
3. Walk forward; count the longest unbroken consecutive run
4. A gap of > 1 day resets the current-run counter

---

### 7.4 Unit Conversion

*(Pending resolution of [OQ-7 conflict](#oq-7-conflict). The following describes the canonical-lbs path.)*

**Storage:** `weightLbs` on `WorkoutSet` (lbs); `distanceMiles` on `CardioSession` (miles). All stored values are canonical.

**Display (imperial):** `weightLbs` shown as-is, labeled "lbs". `distanceMiles` shown as-is, labeled "mi".

**Display (metric):**
- Weight: `weightLbs / 2.20462`, rounded to nearest 1 kg (or 0.5 kg if precision preferred — to be decided), labeled "kg"
- Distance: `distanceMiles * 1.60934`, labeled "km"

**Input (metric):** User enters value in kg; app converts to lbs before storing: `enteredKg * 2.20462`.

**Rounding for recommendations:**
- Imperial: nearest 2.5 lbs
- Metric: nearest 1 kg

**Unit change behavior:** Changing `unitSystem` in Settings immediately re-renders all displayed values. No data migration required.

---

### 7.5 Preferred Exercise

**Purpose:** When a workout session is created, the app pre-selects the most contextually appropriate exercise for each muscle group.

**Algorithm (per muscle group):**
1. Search all completed `WorkoutSession` records, find the most recent `SessionExercise` for this muscle group
2. If found: use that `exerciseName` as the default
3. If not found: use the first exercise in the built-in library for that muscle group (alphabetical order)

This means the app "remembers" which exercise the user gravitated toward and re-selects it automatically.

---

### 7.6 Rest Timer — Wall-Clock Accuracy

**Problem:** A simple countdown `Timer` stops when the app is backgrounded.

**Solution:** The timer stores an anchor, not a counter.

**Implementation:**
- On timer start: store `timerStartedAt = Date.now` in app state (in-memory, not persisted)
- Each UI tick: `remaining = timerDurationSeconds - Int(Date.now - timerStartedAt)`
- When app returns from background: recalculate `remaining` from wall clock
- If `remaining <= 0` on return: timer has already expired; show "Rest complete" state immediately with haptic

---

## 8. iCloud Sync

### 8.1 Technology
SwiftData with CloudKit (`ModelConfiguration(cloudKitDatabase: .automatic)`). Uses CloudKit private database — data belongs exclusively to the user's Apple ID.

### 8.2 Synced Entities
All 6 model types: `AppState`, `WorkoutSession`, `SessionExercise`, `WorkoutSet`, `Exercise`, `CardioSession`.

### 8.3 Behavior
| Scenario | Behavior |
|----------|----------|
| Normal use | Silent background sync; no UI indicator during normal operation |
| Settings | iCloud status shown: "Syncing" / "Up to date" / "Not signed in" |
| Conflict | Last-write-wins; `updatedAt` field used to determine recency |
| Offline | Changes queue locally; sync resumes automatically when network returns |
| New device first launch | Existing data downloads; onboarding is skipped if `AppState` exists in CloudKit |
| iCloud disabled | App falls back to local-only; data is not lost; alert shown in Settings |

### 8.4 SwiftData + CloudKit Constraints
- All properties must have default values
- All relationships need explicit `deleteRule`
- `@Attribute(.unique)` on `id` fields supports CloudKit deduplication
- No optional relationships without defaults

### 8.5 Exercise Library Seeding Across Devices
- Built-in exercises use `sourceID` for deduplication
- On a new device, seeding checks `sourceID` before inserting — avoids duplicating library items that already synced from another device

---

## 9. Non-Functional Requirements

| Category | Requirement |
|----------|-------------|
| Platform | iOS 17.0 minimum (SwiftData requirement) |
| Devices | iPhone primary; iPad fully supported |
| Orientation | Portrait primary; landscape fully functional |
| Performance | Set-tap → visual response < 100ms |
| Accessibility | VoiceOver labels on all controls; Dynamic Type; minimum tap target 44×44pt |
| Privacy | No analytics; no crash reporting; no third-party SDKs; data only leaves device via user's own iCloud account |
| Offline | Fully functional with no network connection |
| App Size | < 20 MB download |
| Dark Mode | Full support |
| Localization | English only for v1; strings structured for future localization |

---

## 10. Out of Scope (v1)

- Level 2 / Level 3 program phases
- Social features (sharing, leaderboards, friends)
- Nutrition or calorie tracking
- In-app purchase or subscription
- Android or web versions
- Coach / trainer mode (multi-user)
- Video demonstrations of exercises
- AI-generated workout modifications
- Bluetooth hardware integration (smart scales, HRMs)
- Multiple simultaneous active programs

---

## 11. Resolved Decisions

| ID | Question | Decision | Notes |
|----|----------|----------|-------|
| OQ-1 | Calendar day enforcement? | **Flexible** — no enforcement | User logs each day whenever convenient |
| OQ-2 | Multiple programs? | **One active program** | v1 only |
| OQ-3 | Force-quit mid-session? | **Preserve and offer Resume** | v1 required; `status = .inProgress` persisted immediately |
| OQ-4 | Empty session save? | **Require ≥ 1 completed set** | Prevents meaningless entries |
| OQ-5 | Date range on charts? | **30d / 3mo / All time** | v1 (F-23) |
| OQ-6 | Deleted exercise in history? | **Keep name string** | `exerciseName` is denormalized |
| **OQ-7** | **Weight storage unit?** | **⚠️ UNRESOLVED CONFLICT** | See [Section 6.3](#63-️-oq-7-conflict--weight-storage-unit) |
| OQ-8 | Recommendation basis? | **Max weight of most recent completed session** | Not "last set by number" |
| OQ-9 | Weight floor? | **5 lbs / 2.5 kg, only when history exists** | Blank field if no history |
| OQ-10 | Cardio counts for streak? | **Yes** | Label as "Activity Streak" |

**Additional decisions from review:**
| Topic | Decision |
|-------|----------|
| Haptics | Move to v1; set complete + rest timer zero; default on; can be disabled in Settings |
| Push notifications | Stay v1.1 |
| Session notes | `notes: String` in model with `""` default; Notes UI deferred to v1.1 |
| `completedAt` | Added to `WorkoutSession` and `WorkoutSet` |
| `startedAt` | Added to `WorkoutSession` |
| `status` | Added to `WorkoutSession` as `WorkoutSessionStatus` enum |
| `sourceID` | Added to `Exercise` for idempotent seeding |
| `updatedAt` | Added to all entities for CloudKit conflict support |
| `isProgramComplete` | Added to `AppState` |
| Weight rounding | 2.5 lbs / 1 kg (not 0.25 lbs) |
| "Day 0 flow" | Renamed to "First Launch Onboarding"; no "Day 0" concept |

---

## 12. Future Roadmap

### v1.1
- Session Notes UI (field already in model)
- Push notifications for rest timer when app is backgrounded
- Keep screen awake during active session
- Audio alert option when rest timer ends

### v1.2
- Body weight log + chart
- HealthKit integration: write workouts to Apple Health
- Export to CSV / PDF

### v2.0
- Apple Watch companion (log sets, view timer on wrist)
- Level 2 program phases
- Trainer mode (coach creates program for a client)

---

## Appendix A — 72-Day Program Schedule

All 18 weeks × 4 days. Sets listed as (count). Rest and rep ranges apply to the entire day. Cycle type is fixed per day position.

### Phase 1 — Ramp 1

#### Week 1 (Overall Week 1) — 120s rest
| Day | Cycle | Reps | Muscle Groups |
|-----|-------|------|---------------|
| 1 | Endurance | 13–15 | Back(3), Chest(3), Bicep(3), Calf(3) |
| 2 | Endurance | 13–15 | Delts(3), Tricep(3), Thighs(3), Abs(3) |
| 3 | Strength | 10–12 | Back(3), Chest(3), Thighs(3), Delts(1), Calf(2), Bicep(1), Tricep(1) |
| 4 | Power | 8–10 | Thighs(3), Chest(3), Back(3), Delts(1), Calf(2), Tricep(1), Bicep(1) |

#### Week 2 (Overall Week 2) — 90s rest
| Day | Cycle | Reps | Muscle Groups |
|-----|-------|------|---------------|
| 1 | Endurance | 13–15 | Back(4), Chest(4), Bicep(4), Calf(4) |
| 2 | Endurance | 13–15 | Delts(4), Tricep(4), Thighs(4), Abs(4) |
| 3 | Strength | 10–12 | Back(4), Chest(4), Thighs(4), Delts(1), Calf(2), Bicep(1), Tricep(1) |
| 4 | Power | 8–10 | Thighs(4), Chest(4), Back(4), Delts(1), Calf(2), Tricep(1), Bicep(1) |

#### Week 3 (Overall Week 3) — 90s rest
| Day | Cycle | Reps | Muscle Groups |
|-----|-------|------|---------------|
| 1 | Endurance | 13–15 | Back(5), Chest(5), Bicep(5), Calf(5) |
| 2 | Endurance | 13–15 | Delts(5), Tricep(5), Thighs(5), Abs(5) |
| 3 | Strength | 10–12 | Back(5), Chest(5), Thighs(5), Delts(2), Calf(2), Bicep(1), Tricep(1) |
| 4 | Power | 8–10 | Thighs(5), Chest(5), Back(5), Delts(2), Calf(2), Tricep(1), Bicep(1) |

---

### Phase 2 — Supergrowth Phase 1
**Weeks 4–6 (Overall Weeks 4–6) — same layout all three weeks — 180s rest**

| Day | Cycle | Reps | Muscle Groups |
|-----|-------|------|---------------|
| 1 | Endurance | 10–12 | Back(3), Chest(3), Bicep(3), Calf(3) |
| 2 | Endurance | 10–12 | Delts(3), Tricep(3), Thighs(3), Abs(3) |
| 3 | Strength | 8–10 | Back(3), Chest(3), Thighs(3), Delts(1), Calf(2), Bicep(1), Tricep(1) |
| 4 | Power | 5–7 | Thighs(3), Chest(3), Back(3), Delts(1), Calf(2), Tricep(1), Bicep(1) |

---

### Phase 3 — Ramp 2

#### Week 1 (Overall Week 7) — 150s rest
| Day | Cycle | Reps | Muscle Groups |
|-----|-------|------|---------------|
| 1 | Endurance | 13–15 | Back(3), Chest(3), Thighs(3), Calf(3), Bicep(3) |
| 2 | Endurance | 13–15 | Chest(3), Back(3), Thighs(3), Calf(3), Tricep(3) |
| 3 | Strength | 10–12 | Back(3), Chest(3), Thighs(3), Delts(1), Calf(2), Bicep(1), Tricep(1) |
| 4 | Power | 8–10 | Thighs(3), Chest(3), Back(3), Delts(1), Calf(2), Tricep(1), Bicep(1) |

#### Week 2 (Overall Week 8) — 90s rest
| Day | Cycle | Reps | Muscle Groups |
|-----|-------|------|---------------|
| 1 | Endurance | 13–15 | Back(3), Chest(3), Thighs(3), Calf(3), Bicep(3) |
| 2 | Endurance | 13–15 | Chest(3), Back(3), Thighs(3), Calf(3), Tricep(2) |
| 3 | Strength | 10–12 | Thighs(3), Chest(3), Back(3), Calf(2), Delts(1), Bicep(1), Tricep(1) |
| 4 | Power | 8–10 | Back(3), Chest(3), Thighs(3), Delts(1), Calf(2), Tricep(1), Bicep(1) |

#### Week 3 (Overall Week 9) — 60s rest
| Day | Cycle | Reps | Muscle Groups |
|-----|-------|------|---------------|
| 1 | Endurance | 13–15 | Back(4), Chest(4), Thighs(4), Calf(4), Bicep(4) |
| 2 | Endurance | 13–15 | Chest(4), Back(4), Thighs(4), Calf(4), Tricep(3) |
| 3 | Strength | 10–12 | Back(4), Chest(4), Thighs(4), Calf(3), Delts(2), Tricep(1), Bicep(1) |
| 4 | Power | 8–10 | Thighs(4), Chest(4), Back(4), Calf(3), Delts(2), Tricep(1), Bicep(1) |

---

### Phase 4 — Supergrowth Phase 2
**Weeks 1–3 (Overall Weeks 10–12) — same layout all three weeks — 90s rest**

| Day | Cycle | Reps | Muscle Groups |
|-----|-------|------|---------------|
| 1 | Endurance | 13–15 | Back(4), Chest(4), Bicep(4), Calf(4) |
| 2 | Endurance | 13–15 | Delts(4), Tricep(4), Thighs(4), Abs(4) |
| 3 | Strength | 10–12 | Back(4), Chest(4), Calf(2), Tricep(1), Bicep(1) |
| 4 | Power | 8–10 | Thighs(4), Chest(4), Delts(2), Calf(2), Tricep(1), Bicep(1) |

---

### Phase 5 — Ramp 3

#### Weeks 1–2 (Overall Weeks 13–14) — same layout both weeks
| Day | Cycle | Reps | Rest | Muscle Groups |
|-----|-------|------|------|---------------|
| 1 | Endurance | 13–15 | 120s | Back(3), Chest(3), Bicep(4), Calf(3) |
| 2 | Endurance | 13–15 | 120s | Delts(4), Tricep(4), Thighs(3), Abs(3) |
| 3 | Strength | 10–12 | 90s | Back(3), Chest(3), Thighs(3), Calf(2), Delts(2) |
| 4 | Power | 8–10 | 60s | Thighs(3), Chest(3), Back(3), Delts(2), Calf(2) |

#### Week 3 (Overall Week 15)
| Day | Cycle | Reps | Rest | Muscle Groups |
|-----|-------|------|------|---------------|
| 1 | Endurance | 13–15 | 120s | Back(4), Chest(4), Bicep(5), Calf(4) |
| 2 | Endurance | 13–15 | 120s | Delts(5), Tricep(5), Thighs(4), Abs(4) |
| 3 | Strength | 10–12 | 120s | Back(4), Chest(4), Thighs(4), Calf(2), Delts(2) |
| 4 | Power | 8–10 | 120s | Thighs(4), Chest(4), Back(4), Delts(2), Calf(2) |

---

### Phase 6 — Supergrowth Phase 3
**Weeks 1–3 (Overall Weeks 16–18) — same layout all three weeks**

| Day | Cycle | Reps | Rest | Muscle Groups |
|-----|-------|------|------|---------------|
| 1 | Endurance | 13–15 | 60s | Back(4), Chest(4), Bicep(4), Calf(4) |
| 2 | Endurance | 13–15 | 60s | Delts(4), Tricep(4), Thighs(4), Abs(4) |
| 3 | Strength | 8–10 | 120s | Back(3), Chest(3), Thighs(3), Delts(1), Calf(2), Bicep(1), Tricep(1) |
| 4 | Power | 4–6 | 180s | Thighs(3), Chest(3), Back(3), Delts(1), Calf(2), Tricep(1), Bicep(1) |

---

## Appendix B — Default Exercise Library

90 built-in exercises across 8 muscle groups. Marked with `[sourceID]` for seeding.

### Back (13 exercises)
1. Barbell Row
2. Dumbbell Row
3. Lat Pulldown
4. Seated Cable Row
5. T-Bar Row
6. Pull-Up
7. Chin-Up
8. Face Pull
9. Deadlift
10. Single-Arm Cable Row
11. Meadows Row
12. Rack Pull
13. Inverted Row

### Chest (13 exercises)
1. Barbell Bench Press
2. Dumbbell Bench Press
3. Incline Barbell Press
4. Incline Dumbbell Press
5. Decline Bench Press
6. Cable Fly
7. Dumbbell Fly
8. Chest Dip
9. Push-Up
10. Pec Deck Machine
11. Smith Machine Press
12. Landmine Press
13. Incline Cable Fly

### Bicep (11 exercises)
1. Barbell Curl
2. Dumbbell Curl
3. Hammer Curl
4. Preacher Curl
5. Incline Dumbbell Curl
6. Cable Curl
7. Concentration Curl
8. EZ-Bar Curl
9. Spider Curl
10. Reverse Curl
11. Cross-Body Hammer Curl

### Calf (7 exercises)
1. Standing Calf Raise
2. Seated Calf Raise
3. Leg Press Calf Raise
4. Donkey Calf Raise
5. Single-Leg Calf Raise
6. Smith Machine Calf Raise
7. Calf Press (Machine)

### Delts (13 exercises)
1. Overhead Press (Barbell)
2. Overhead Press (Dumbbell)
3. Lateral Raise
4. Front Raise
5. Rear Delt Fly
6. Arnold Press
7. Upright Row
8. Cable Lateral Raise
9. Machine Shoulder Press
10. Cable Front Raise
11. Bent-Over Lateral Raise
12. Face Pull
13. Plate Front Raise

### Tricep (12 exercises)
1. Tricep Pushdown (Cable)
2. Skull Crusher
3. Close-Grip Bench Press
4. Overhead Tricep Extension
5. Tricep Dip
6. Kickback
7. Diamond Push-Up
8. Rope Pushdown
9. JM Press
10. French Press
11. Tate Press
12. Single-Arm Pushdown

### Thighs (14 exercises)
1. Barbell Squat
2. Leg Press
3. Hack Squat
4. Leg Extension
5. Leg Curl (Lying)
6. Leg Curl (Seated)
7. Romanian Deadlift
8. Lunge
9. Bulgarian Split Squat
10. Sumo Squat
11. Goblet Squat
12. Front Squat
13. Step-Up
14. Sissy Squat

### Abs (13 exercises)
1. Crunch
2. Plank
3. Russian Twist
4. Hanging Leg Raise
5. Cable Crunch
6. Ab Rollout
7. Bicycle Crunch
8. Leg Raise
9. Decline Crunch
10. Hollow Body Hold
11. Dead Bug
12. Dragon Flag
13. Woodchopper

### Cardio Types (10 options)
Running · Walking · Cycling · Swimming · Rowing · Elliptical · Jump Rope · HIIT · Stairmaster · Other

---

*End of Specification v0.2*
