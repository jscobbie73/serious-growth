# Serious Growth — iOS Gym Tracker

A native iOS app for tracking the **Serious Growth Level 1 bodybuilding program** — 18 weeks, 4 days per week, full weight tracking, progress charts, cardio logging, streaks, and iCloud sync.

---

## App Specification

### Program Structure
- **18 weeks**, 6 phases, 4 days per week
- **Phase 1 — Ramp 1** (Weeks 1–3): Progressive volume 3→5 sets, 120–90s rest, 13–15 reps (Endurance)
- **Phase 2 — Supergrowth Phase 1** (Weeks 4–6): Hypo-zone, 3 sets, 180s rest, 10–12 reps
- **Phase 3 — Ramp 2** (Weeks 7–9): Progressive volume 3→4 sets, 150–60s rest, 13–15 reps
- **Phase 4 — Supergrowth Phase 2** (Weeks 10–12): Optimal zone, 4 sets, 90s rest, 13–15 reps
- **Phase 5 — Ramp 3** (Weeks 13–15): Progressive volume 3→5 sets, 120s rest
- **Phase 6 — Supergrowth Phase 3** (Weeks 16–18): Peak training, 60–180s rest, mixed rep ranges

### Daily Split (4 Days)
| Day | Cycle | Focus |
|-----|-------|-------|
| Day 1 | Endurance (A) | Back · Chest · Bicep · Calf |
| Day 2 | Endurance (A) | Delts · Tricep · Thighs · Abs |
| Day 3 | Strength (B) | Back · Chest · Thighs + accessories |
| Day 4 | Power (C) | Thighs · Chest · Back + accessories |

### Features

#### Workout Tracking
- Full 18-week program pre-loaded from the Serious Growth spreadsheet
- Automatic progression through phases/weeks/days on workout completion
- Manual position override (tap calendar icon on Home)
- Rest timer counts down automatically after each set marked complete
- Skip rest timer at any time
- Workout duration tracked

#### Weight & Sets
- Log weight (lbs or kg) and reps per set
- Check off sets with a single tap
- **5% weight recommendation**: calculates `last completed weight × 1.05`, rounded to nearest 0.25 lb, pre-filled for each set
- Swap exercise within a muscle group mid-session

#### Exercise Library
- 8 muscle groups: Back, Chest, Bicep, Calf, Delts, Tricep, Thighs, Abs
- 90+ built-in exercises
- Add unlimited custom exercises per muscle group
- Delete custom exercises
- Searchable library

#### Progress Charts (History → Charts tab)
- Filter by muscle group, then select specific exercise
- Line chart of max weight per session over time
- Personal record, last session, and total sessions stats

#### Cardio Tracking
- Log any cardio session with optional: type, distance (miles), duration, avg heart rate
- 10 cardio type presets (Running, Cycling, Swimming, HIIT, etc.)
- Running totals for miles and time
- Delete sessions by swiping

#### Streaks
- **Current streak**: consecutive days with at least one workout or cardio session
- **Best streak**: longest streak ever achieved
- Displayed prominently on Home screen

#### iCloud Sync
- All data (workouts, exercises, cardio, progress) syncs via **CloudKit**
- Works automatically across all iPhones and iPads signed into the same Apple ID

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| UI | SwiftUI |
| Data | SwiftData |
| Sync | CloudKit (automatic via SwiftData) |
| Charts | Swift Charts |
| Min iOS | 17.0 |
| Language | Swift 5.9+ |

---

## Xcode Setup

### Prerequisites
- Xcode 15.0 or later
- Apple Developer account (free for simulator; paid required for device + iCloud)

### Steps

1. **Open the project**
   ```
   open SeriousGrowth.xcodeproj
   ```

2. **Set your Team**
   - Select the `SeriousGrowth` target → Signing & Capabilities
   - Set your Development Team

3. **Enable iCloud**
   - Signing & Capabilities → `+` Capability → **iCloud**
   - Check **CloudKit**
   - Container `iCloud.com.seriousgrowth.app` will be created automatically

4. **Update Bundle ID** (if needed)
   - Change `com.seriousgrowth.app` to your preferred bundle ID
   - Update `SeriousGrowth.entitlements` accordingly

5. **Run** — `⌘R`

### iCloud Sync Notes
- iCloud sync requires a paid Apple Developer account for device testing
- On simulator, use `Features → Trigger iCloud Sync` to test
- Changes appear on other devices within seconds on the same network

---

## Project Structure

```
SeriousGrowth/
├── SeriousGrowthApp.swift          # App entry, ModelContainer, seed data
├── ContentView.swift               # TabView (Home / History / Exercises / Cardio / Settings)
├── SeriousGrowth.entitlements      # iCloud + CloudKit entitlements
├── Info.plist
├── Assets.xcassets/
├── Models/
│   ├── DataModels.swift            # SwiftData @Model classes
│   ├── ProgramData.swift           # Full 18-week program data (all 6 phases)
│   └── ExerciseLibrary.swift       # Default exercises + cardio types
└── Views/
    ├── HomeView.swift              # Streak cards, today's workout, start button
    ├── WorkoutSessionView.swift    # Active workout: sets, rest timer, weight entry
    ├── HistoryView.swift           # Workout list, cardio list, weight charts
    ├── ExercisesView.swift         # Exercise library + add custom
    ├── CardioView.swift            # Cardio log + summary stats
    └── SettingsView.swift          # Units, program overview, reset
```

---

## Data Models

```
AppState         — current phase/week/day, weight unit preference
WorkoutSession   — date, phase, week, day, duration → [SessionExercise]
SessionExercise  — exercise name, muscle group, order → [WorkoutSet]
WorkoutSet       — set #, target reps, completed reps, weight, isCompleted
Exercise         — name, muscle group, isCustom flag
CardioSession    — date, type, distance, duration, heart rate, notes
```

---

## Future Enhancements
- Push notifications for rest timer in background
- Apple Watch companion for set logging
- Body weight tracking chart
- Level 2 / Level 3 program phases
- Export workout data to CSV
- HealthKit integration (write workouts, read heart rate)
