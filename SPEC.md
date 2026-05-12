# Serious Growth — iOS App Specification

**Version:** 0.1 (Draft for Review)
**Status:** In Review
**Last Updated:** 2026-05-12

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
11. [Open Questions](#11-open-questions)
12. [Future Roadmap](#12-future-roadmap)

---

## 1. Purpose & Goals

**Serious Growth** is a native iOS app that guides a user through the Serious Growth Level 1 bodybuilding program — an 18-week, 4-day-per-week training plan — while logging every set, tracking progressive overload, and syncing data across all the user's Apple devices via iCloud.

### Goals
- Replace paper logs and generic note apps with a purpose-built experience for this specific program
- Remove cognitive load mid-workout: the app tells you exactly what to do today (muscle groups, sets, rep range, rest period)
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

The program is sourced from the provided Excel file (`f1d34ff9-lifting.xlsx`). Key structural facts:

### 18-Week Structure

| Phase | Name | Weeks | Sets | Rest | Rep Focus |
|-------|------|-------|------|------|-----------|
| 1 | Ramp 1 | 1–3 | 3→5 (increases weekly) | 120→90s | 13–15 (End), 10–12 (Str), 8–10 (Pwr) |
| 2 | Supergrowth Phase 1 | 4–6 | 3 (same all weeks) | 180s | 10–12 (End), 8–10 (Str), 5–7 (Pwr) |
| 3 | Ramp 2 | 7–9 | 3→4 (increases) | 150→60s | 13–15 (End), 10–12 (Str), 8–10 (Pwr) |
| 4 | Supergrowth Phase 2 | 10–12 | 4 (same all weeks) | 90s | 13–15 (End), 10–12 (Str), 8–10 (Pwr) |
| 5 | Ramp 3 | 13–15 | 3→5 (increases) | 120→60s | 13–15 (End), 10–12 (Str), 8–10 (Pwr) |
| 6 | Supergrowth Phase 3 | 16–18 | 3–4 (varies) | 60→180s | 13–15 (End), 8–10 (Str), 4–6 (Pwr) |

### Cycle Types (apply per day, every week)
- **Cycle A — Endurance:** Days 1 & 2 (higher reps, moderate weight)
- **Cycle B — Strength:** Day 3 (moderate reps)
- **Cycle C — Power:** Day 4 (lower reps, heavy weight)

### Muscle Groups Used
`Back`, `Chest`, `Bicep`, `Calf`, `Delts`, `Tricep`, `Thighs`, `Abs`

### Daily Assignment Examples (Ramp 1, Week 1)
| Day | Muscle Groups (sets) | Rest | Reps |
|-----|---------------------|------|------|
| 1 | Back×3, Chest×3, Bicep×3, Calf×3 | 120s | 13–15 |
| 2 | Delts×3, Tricep×3, Thighs×3, Abs×3 | 120s | 13–15 |
| 3 | Back×3, Chest×3, Thighs×3, Delts×1, Calf×2, Bicep×1, Tricep×1 | 120s | 10–12 |
| 4 | Thighs×3, Chest×3, Back×3, Delts×1, Calf×2, Tricep×1, Bicep×1 | 120s | 8–10 |

> **Open Question OQ-1:** The program states 4 days per week but does not specify which calendar days. Should the app enforce specific days (e.g., Mon/Tue/Thu/Fri) or allow flexible scheduling? See [Section 11](#11-open-questions).

---

## 4. Feature Inventory

### 4.1 Core Features (Must Have — v1)

| ID | Feature | Description |
|----|---------|-------------|
| F-01 | Program Navigation | Display current phase, week, and day; auto-advance after workout completion |
| F-02 | Manual Position Override | Allow user to set program position manually |
| F-03 | Workout Session | Start a session for today's day; log exercises, sets, reps, weight |
| F-04 | Rest Timer | Countdown timer triggered after each set completion; skippable |
| F-05 | Weight Recommendation | Suggest next weight based on last completed set +5% |
| F-06 | Exercise Selection | Choose which exercise to perform per muscle group from library |
| F-07 | Exercise Swap | Change exercise mid-session without losing other set data |
| F-08 | Exercise Library | Searchable list of built-in exercises per muscle group |
| F-09 | Custom Exercises | Add and delete custom exercises per muscle group |
| F-10 | Workout History | View past sessions with date, phase, exercises, and weights logged |
| F-11 | Weight Progress Chart | Line chart of max weight per session for any exercise |
| F-12 | Cardio Logging | Log cardio sessions with optional type, distance, duration, heart rate |
| F-13 | Streak Tracking | Track current and best consecutive-day streaks |
| F-14 | iCloud Sync | All user data syncs automatically across Apple devices |
| F-15 | Units Toggle | Switch between lbs and kg (applies globally to all display and entry) |

### 4.2 Should Have (v1 if time permits)

| ID | Feature | Description |
|----|---------|-------------|
| F-16 | Workout Duration | Track total elapsed time from session start to completion |
| F-17 | Session Notes | Free-text notes attached to a workout session |
| F-18 | Program Overview | In-app reference card for all 18 weeks and their parameters |
| F-19 | Cardio History Charts | Chart of cardio distance or duration over time |

### 4.3 Nice to Have (v2+)

| ID | Feature | Description |
|----|---------|-------------|
| F-20 | Haptic Feedback | Haptic pulse when rest timer completes |
| F-21 | Audio Alert | Optional sound when rest timer completes |
| F-22 | Keep Screen Awake | Prevent display sleep during active workout |
| F-23 | HealthKit Write | Write completed workouts to Apple Health |
| F-24 | Apple Watch | Log sets from wrist |
| F-25 | Body Weight Log | Track body weight over time (separate from exercise weight) |

---

## 5. Screens & User Flows

### 5.1 Navigation Structure

```
TabBar
├── Home          (house icon)
├── History       (clock icon)
├── Exercises     (dumbbell icon)
├── Cardio        (figure.run icon)
└── Settings      (gear icon)
```

---

### 5.2 Home Screen

**Purpose:** The daily driver. Shows where the user is in the program, what's up today, and surfaces their streak.

**Content:**
- **Streak Card** — Current streak (days) with flame icon; Best streak with trophy icon
- **Program Position Card** — Phase name, week number, overall week X of 18, progress bar, focus description
- **Today's Workout Card** — Day number, cycle type badge (Endurance / Strength / Power), rep range, rest period, muscle group chips with set counts
- **CTA Button** — "Start Workout" (orange, full-width). Disabled / replaced with "Workout Logged ✓" if session already completed today.

**Actions:**
- Tap "Start Workout" → navigate to Workout Session screen (modal)
- Tap calendar icon (nav bar) → Program Position Picker sheet

**Edge Cases:**
- If user is on the last day of the program (Phase 6, Week 3, Day 4): show "Program Complete" state with option to restart
- If no AppState exists yet (first launch): create and seed with Phase 0, Week 0, Day 0

> **Open Question OQ-2:** Should the app support multiple simultaneous programs or program instances, or is one active program sufficient?

---

### 5.3 Workout Session Screen (Modal)

**Purpose:** The active workout experience. User works through all muscle group assignments for the day.

**Flow:**
1. User taps "Start Workout"
2. App creates a `WorkoutSession` record and pre-populates one `SessionExercise` per muscle group assignment using the preferred exercise (most recently used for that group, or first default)
3. Each `SessionExercise` has its target sets pre-created with recommended weight pre-filled
4. User works through each exercise/set, entering weight and reps, tapping the checkmark to complete each set
5. On set completion, rest timer auto-starts
6. User taps "Finish" → confirmation dialog → session saved, program advances to next day

**Screen Layout:**
- Nav bar: "Day X — [Cycle Type]" title; "Cancel" (left, discards session), "Finish" (right, saves)
- Rest timer banner (orange, dismissible) appears below nav bar while active
- Scrollable list of `ExerciseCard` components, one per muscle group assignment

**ExerciseCard Layout:**
- Header: muscle group icon + exercise name + muscle group label + "swap" button
- Weight recommendation badge (if available): "Recommended: X lbs ↑"
- Set table:
  - Columns: Set # | Target Reps | Weight | Reps Done | ✓
  - Weight and reps fields are editable inline
  - Completed sets shown at reduced opacity

**Completing a Set:**
1. User edits weight field (pre-filled with recommendation)
2. User edits reps field (pre-filled with target max)
3. User taps checkmark → set marked complete → rest timer starts

**Rest Timer Behavior:**
- Counts down in seconds from the day's configured rest period
- Shown in a sticky banner: "Rest: 47s [Skip]"
- Tapping Skip stops the timer immediately
- If another set is completed before timer expires, timer resets to full duration
- Timer does NOT auto-proceed to anything; it is informational only

**Cancel vs. Finish:**
- "Cancel" shows confirmation dialog: "Discard this workout?" — deletes the in-progress session record
- "Finish" shows confirmation dialog: "Finish & Save?" — saves the session and advances program position

> **Open Question OQ-3:** If the user force-quits the app mid-session, should the partial session be preserved and resumable on next launch, or discarded?

> **Open Question OQ-4:** Should "Finish" require at least one set to be completed, or can an empty session be saved (e.g., user just checked in)?

---

### 5.4 History Screen

**Segmented control: Workouts | Cardio | Charts**

#### Workouts Tab
- Reverse-chronological list of `WorkoutSession` records
- Each row: date, phase label, day label, muscle groups logged (truncated), set/exercise count
- Tap row → Workout Detail screen
- Swipe to delete

#### Workout Detail Screen
- Summary section: date/time, phase, day, duration (if recorded)
- One section per exercise: exercise name as section header; each set as a row showing weight × reps, completion checkmark

#### Cardio Tab
- Reverse-chronological list of `CardioSession` records
- Summary stats row at top: total sessions, total miles, total time
- Each row: date, cardio type, distance / duration / heart rate (if logged)
- Swipe to delete

#### Charts Tab
- Muscle group filter pills (horizontal scroll)
- Exercise picker dropdown (filtered to groups with logged data)
- Line chart: date (x-axis) vs. max weight per session (y-axis)
  - Orange line with point markers
  - Area fill below line
- Stat cards below chart: Personal Record | Last Session | Total Sessions

> **Open Question OQ-5:** Should the chart be filterable by date range (e.g., last 30 days, last 3 months, all time)?

---

### 5.5 Exercises Screen

**Purpose:** Browse and manage the exercise library.

**Layout:**
- Horizontal scrolling muscle group filter pills at top
- Searchable list of exercises for selected group
- Each exercise row: name; "Custom" badge if user-added; trash icon (custom only)

**Add Exercise:**
- "+" button in nav bar → "Add Exercise" sheet
- Fields: Name (text), Muscle Group (picker, defaults to currently selected group)
- Save creates a custom exercise

**Delete Exercise:**
- Only custom exercises can be deleted
- Tap trash → confirmation

> **Open Question OQ-6:** If a custom exercise is deleted, should past sessions that used it retain the exercise name (as a string), or show "Deleted Exercise"? (Recommendation: retain the name string — it is already stored on `SessionExercise.exerciseName` independently of the library.)

---

### 5.6 Cardio Screen

**Purpose:** Log and review cardio sessions.

**Layout (when sessions exist):**
- Summary strip at top: session count, total miles, total time
- List of sessions, reverse-chronological
- "+" button to log new session

**Log Cardio Sheet:**
- Date/time picker
- Cardio type picker (Running, Walking, Cycling, Swimming, Rowing, Elliptical, Jump Rope, HIIT, Stairmaster, Other)
- Toggle: "Log Distance" → miles field
- Toggle: "Log Duration" → minute + second steppers
- Toggle: "Log Heart Rate" → BPM stepper (range 40–220)
- Notes field (optional)

**Empty State:** Icon + "No cardio logged yet" + "Log Cardio" button

---

### 5.7 Settings Screen

**Purpose:** Global preferences and program management.

**Sections:**
- **Units:** lbs / kg toggle
- **Program:** Current position display; "Reset Program Position" (destructive)
- **Program Reference:** Expandable list of all 6 phases with week ranges and focus descriptions
- **About:** App version, iCloud sync status indicator

---

## 6. Data Model

### 6.1 Entities

#### `AppState` (singleton)
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| currentPhaseIndex | Int | 0–5 |
| currentWeekIndex | Int | 0–2 (within phase) |
| currentDayIndex | Int | 0–3 |
| programStartDate | Date | When user started the program |
| useKilograms | Bool | Default: false |

#### `WorkoutSession`
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| date | Date | Start time of session |
| phaseIndex | Int | 0–5 |
| weekIndex | Int | 0–2 |
| dayIndex | Int | 0–3 |
| durationSeconds | Int | Elapsed time |
| notes | String | Optional user notes |
| sessionExercises | [SessionExercise] | Cascade delete |

#### `SessionExercise`
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| exerciseName | String | Denormalized — does NOT reference Exercise entity |
| muscleGroup | String | Denormalized |
| sortOrder | Int | Display order within the session |
| sets | [WorkoutSet] | Cascade delete |

> **Design note:** Exercise name is stored as a plain string on `SessionExercise` (not a foreign key to `Exercise`). This means deleting an exercise from the library does not corrupt historical data.

#### `WorkoutSet`
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| setNumber | Int | 1-indexed within the exercise |
| targetRepsMin | Int | From program data |
| targetRepsMax | Int | From program data |
| completedReps | Int | User-entered; defaults to targetRepsMax |
| weight | Double | In user's chosen unit at time of log |
| isCompleted | Bool | Whether set was marked done |

> **Open Question OQ-7:** Should `weight` be stored in a canonical unit (e.g., always lbs internally, displayed in preference unit) or in whatever unit the user has selected at log time? Canonical storage is safer for future unit conversions.

#### `Exercise` (Library)
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| name | String | Display name |
| muscleGroup | String | One of the 8 groups |
| isCustom | Bool | false = built-in, true = user-added |
| createdAt | Date | For ordering custom exercises |

#### `CardioSession`
| Field | Type | Notes |
|-------|------|-------|
| id | UUID | Primary key |
| date | Date | |
| cardioType | String | e.g., "Running" |
| hasDistance | Bool | |
| distanceMiles | Double | Stored in miles; displayed per unit preference |
| hasDuration | Bool | |
| durationSeconds | Int | |
| hasHeartRate | Bool | |
| avgHeartRate | Int | bpm |
| notes | String | |

### 6.2 Static / Seeded Data

The following are not persisted in SwiftData — they are compiled into the app as Swift constants:

- **ProgramData:** All 6 phases × 3 weeks × 4 days, with muscle group assignments, set counts, rest periods, and rep ranges
- **ExerciseLibrary:** Default exercise names per muscle group (~90 total)
- **CardioTypes:** Ordered list of cardio type strings

Built-in `Exercise` records are seeded into SwiftData on first launch so they are searchable and manageable like custom exercises.

---

## 7. Business Logic

### 7.1 Weight Recommendation

**Trigger:** When a new `WorkoutSession` is created, for each `SessionExercise`.

**Algorithm:**
1. Search all past `WorkoutSession` records for `SessionExercise` entries where `exerciseName == current exercise name`
2. From those, find all `WorkoutSet` entries where `isCompleted == true && weight > 0`
3. Take the `weight` of the most recently completed set (by session date)
4. Recommended weight = `lastWeight × 1.05`, rounded to nearest 0.25 (lbs) or nearest 0.5 (kg)
5. If no history exists, recommended weight = 0 (fields left blank, user enters manually)

> **Open Question OQ-8:** Should the 5% recommendation apply to the max weight of the last session, or the average, or the weight of the last set (by set number)? Current spec uses the highest weight completed in the most recent session.

> **Open Question OQ-9:** Should there be a minimum weight floor (e.g., never recommend below 5 lbs / 2.5 kg)?

### 7.2 Program Progression

**Trigger:** User taps "Finish & Save" on the Workout Session screen.

**Algorithm:**
1. Increment `currentDayIndex` by 1
2. If `currentDayIndex >= days in current week`: reset `currentDayIndex = 0`, increment `currentWeekIndex`
3. If `currentWeekIndex >= weeks in current phase`: reset `currentWeekIndex = 0`, increment `currentPhaseIndex`
4. If `currentPhaseIndex >= total phases (6)`: set to program-complete state (do not overflow)

**Manual Override:** User can set phase/week/day freely via the Program Position Picker. This does not delete any history.

### 7.3 Streak Calculation

**Definition:** A "streak day" is any calendar date on which at least one `WorkoutSession` or `CardioSession` was recorded.

**Current Streak:**
1. Start from today
2. Walk backwards day by day counting consecutive streak days
3. Stop at the first missing day

**Longest Streak:**
1. Collect all unique streak days (calendar date only, no time) across both session types
2. Sort ascending
3. Walk forward counting the longest consecutive run

**Edge Case:** If the user has not worked out today but did yesterday, their streak should still show the previous run (not broken yet). The current streak does not require today to be active.

> **Open Question OQ-10:** Should the streak only count completed workout sessions, or should a cardio-only day also count? Current spec: both count.

### 7.4 Unit Conversion Display

- All weights are stored in lbs internally (see OQ-7)
- When `useKilograms == true`: displayed value = `storedLbs / 2.20462`, rounded to nearest 0.5 kg
- When `useKilograms == false`: displayed value = stored value as-is
- Recommendation calculation always operates on stored (lbs) values before display conversion

---

## 8. iCloud Sync

### 8.1 Technology
SwiftData with CloudKit (`ModelConfiguration(cloudKitDatabase: .automatic)`). This uses CloudKit's private database — data is private to the user's Apple ID.

### 8.2 Synced Entities
All 6 model types sync: `AppState`, `WorkoutSession`, `SessionExercise`, `WorkoutSet`, `Exercise`, `CardioSession`.

### 8.3 Behavior
- Sync is automatic and silent — no sync button, no sync status indicator in normal usage
- Conflicts are resolved by CloudKit's last-write-wins default
- Offline: changes are queued locally and synced when connectivity is restored
- First launch on a new device: existing data downloads before showing program position

### 8.4 Constraints (SwiftData + CloudKit)
- All model properties must have default values (no non-optional primitives without defaults)
- Relationships must be explicitly declared with delete rules
- `@Attribute(.unique)` on `id` fields helps CloudKit deduplication

### 8.5 iCloud Availability
- If the user is not signed into iCloud, the app falls back to local-only storage with no error shown
- A settings indicator will show "iCloud: Not signed in" if iCloud is unavailable

---

## 9. Non-Functional Requirements

| Category | Requirement |
|----------|-------------|
| Platform | iOS 17.0 minimum (required for SwiftData) |
| Device | iPhone (primary), iPad (supported) |
| Orientation | Portrait primary; landscape supported |
| Performance | Workout session screen must respond to set-tap within 100ms |
| Accessibility | VoiceOver labels on all interactive controls; Dynamic Type supported |
| Privacy | No analytics, no crash reporting, no data leaves the device except via the user's own iCloud account |
| Offline | Fully functional without network; syncs when available |
| App Size | Target under 20 MB download size |
| Dark Mode | Full support |

---

## 10. Out of Scope (v1)

- Level 2 / Level 3 program phases
- Social features (sharing, leaderboards, friends)
- Nutrition or calorie tracking
- In-app purchase or subscription
- Android version
- Web version
- Personal trainer / coach mode
- Video demonstrations of exercises
- AI-generated workout plans
- Integration with external hardware (smart scales, heart rate monitors over Bluetooth)

---

## 11. Open Questions

| ID | Question | Options | Recommendation |
|----|----------|---------|---------------|
| OQ-1 | Does the 4-day program enforce specific calendar days or allow flexible scheduling? | (A) Flexible — user starts each day whenever they want; (B) Assigned days (Mon/Tue/Thu/Fri); (C) User-configurable rest days | **(A) Flexible** — maximizes usability |
| OQ-2 | Multiple program instances? | (A) One active program; (B) Multiple programs switchable | **(A) One program** for v1 simplicity |
| OQ-3 | Partial session on force-quit — preserve or discard? | (A) Preserve and offer Resume on next launch; (B) Discard | **(A) Preserve** — prevents data loss |
| OQ-4 | Can an empty session be saved ("check-in only")? | (A) No — require at least one completed set; (B) Yes — allow empty save | **(A) Require at least one set** |
| OQ-5 | Date range filter on weight charts? | (A) All time only; (B) 30d / 3mo / All time filter | **(B) Add filter** — useful when data grows |
| OQ-6 | Deleted custom exercise in historical sessions? | (A) Show "Deleted"; (B) Keep name string as-is | **(B) Keep name** — already in spec |
| OQ-7 | Weight storage unit? | (A) Always lbs internally; (B) Store in whichever unit was active at log time | **(A) Always lbs** — simplifies future conversions |
| OQ-8 | Recommendation basis? | (A) Max weight of last session; (B) Last set by number; (C) Average | **(A) Max weight of last session** |
| OQ-9 | Minimum weight floor for recommendations? | (A) No floor; (B) 5 lbs / 2.5 kg minimum | **(B) 5 lbs floor** — avoids unrealistically low suggestions |
| OQ-10 | Streak: workout-only or cardio counts too? | (A) Workouts only; (B) Either workout or cardio | **(B) Either counts** |

---

## 12. Future Roadmap

### v1.1
- Push notifications: rest timer alert when app is backgrounded
- Keep screen awake during active workout session
- Haptic feedback on set completion and rest timer end

### v1.2
- Body weight log (chart over time; separate from exercise weight)
- HealthKit integration: write completed workouts to Apple Health
- Date range filter on weight progress charts

### v2.0
- Apple Watch companion app (log sets, view rest timer on wrist)
- Level 2 program phases
- Export workout history to CSV or PDF

### Longer Term
- Android / cross-platform (if demand justifies)
- Trainer mode: coach can create program for a client
- Video demonstrations per exercise (linked to YouTube or embedded)

---

*End of Specification v0.1*
