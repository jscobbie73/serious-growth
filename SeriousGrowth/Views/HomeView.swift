import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var appStates: [AppState]
    @Query private var sessions: [WorkoutSession]
    @Query private var cardioSessions: [CardioSession]
    @Environment(\.modelContext) private var context

    @State private var showWorkout = false
    @State private var showProgramPicker = false

    private var appState: AppState? { appStates.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    streakCard
                    programPositionCard
                    todayCard
                    if let session = todaySession {
                        resumeCard(session: session)
                    }
                }
                .padding()
            }
            .navigationTitle("Serious Growth")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showProgramPicker = true } label: {
                        Image(systemName: "calendar.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $showWorkout) {
                if let state = appState,
                   let workoutDay = ProgramData.workoutDay(
                       phaseIndex: state.currentPhaseIndex,
                       weekIndex: state.currentWeekIndex,
                       dayIndex: state.currentDayIndex) {
                    WorkoutSessionView(
                        workoutDay: workoutDay,
                        phaseIndex: state.currentPhaseIndex,
                        weekIndex: state.currentWeekIndex,
                        dayIndex: state.currentDayIndex
                    ) {
                        advanceProgram()
                    }
                }
            }
            .sheet(isPresented: $showProgramPicker) {
                ProgramPositionPickerView()
            }
        }
    }

    // MARK: - Streak logic

    private var currentStreak: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var streak = 0
        var checkDate = today

        while true {
            let hasActivity = sessions.contains {
                calendar.startOfDay(for: $0.date) == checkDate
            } || cardioSessions.contains {
                calendar.startOfDay(for: $0.date) == checkDate
            }

            if hasActivity {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else if checkDate == today {
                // Not active today — look one day back before giving up
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
                let yesterday = hasActivityOn(date: checkDate)
                if yesterday { streak += 1; checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)! }
                else { break }
            } else {
                break
            }
        }
        return streak
    }

    private var longestStreak: Int {
        let calendar = Calendar.current
        let allDates = Set(sessions.map { calendar.startOfDay(for: $0.date) } +
                           cardioSessions.map { calendar.startOfDay(for: $0.date) })
            .sorted()
        guard !allDates.isEmpty else { return 0 }
        var longest = 1, current = 1
        for i in 1..<allDates.count {
            let diff = calendar.dateComponents([.day], from: allDates[i-1], to: allDates[i]).day ?? 0
            if diff == 1 { current += 1; longest = max(longest, current) }
            else if diff > 1 { current = 1 }
        }
        return longest
    }

    private func hasActivityOn(date: Date) -> Bool {
        let cal = Calendar.current
        let d = cal.startOfDay(for: date)
        return sessions.contains { cal.startOfDay(for: $0.date) == d } ||
               cardioSessions.contains { cal.startOfDay(for: $0.date) == d }
    }

    private var todaySession: WorkoutSession? {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        return sessions.first { cal.startOfDay(for: $0.date) == today }
    }

    // MARK: - Sub-views

    private var streakCard: some View {
        HStack(spacing: 0) {
            streakStat(value: currentStreak, label: "Current Streak", icon: "flame.fill", color: .orange)
            Divider().frame(height: 60)
            streakStat(value: longestStreak, label: "Best Streak", icon: "trophy.fill", color: .yellow)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func streakStat(value: Int, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon).foregroundStyle(color)
                Text("\(value)").font(.system(size: 36, weight: .bold, design: .rounded))
            }
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private var programPositionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let state = appState,
               let phase = ProgramData.phase(at: state.currentPhaseIndex) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(phase.name)
                            .font(.headline)
                        Text("Week \(state.currentWeekIndex + 1) of \(phase.weeks.count)  ·  Overall week \(ProgramData.overallWeek(phaseIndex: state.currentPhaseIndex, weekIndex: state.currentWeekIndex)) of \(ProgramData.totalWeeks)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(phase.focusDescription)
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    Spacer()
                    Text(phase.shortName)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(.orange)
                }

                ProgressView(value: Double(ProgramData.overallWeek(phaseIndex: state.currentPhaseIndex, weekIndex: state.currentWeekIndex)),
                             total: Double(ProgramData.totalWeeks))
                    .tint(.orange)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var todayCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let state = appState,
               let workoutDay = ProgramData.workoutDay(
                   phaseIndex: state.currentPhaseIndex,
                   weekIndex: state.currentWeekIndex,
                   dayIndex: state.currentDayIndex) {

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today — Day \(workoutDay.dayNumber)")
                            .font(.headline)
                        Text("\(workoutDay.cycleType.rawValue) · \(workoutDay.repRangeMin)–\(workoutDay.repRangeMax) reps · \(workoutDay.restSeconds)s rest")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    cycleBadge(workoutDay.cycleType)
                }

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                    ForEach(workoutDay.assignments) { assignment in
                        muscleGroupChip(assignment)
                    }
                }

                if todaySession == nil {
                    Button {
                        showWorkout = true
                    } label: {
                        Label("Start Workout", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .controlSize(.large)
                } else {
                    Label("Workout Logged", systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func resumeCard(session: WorkoutSession) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Today's Workout")
                .font(.subheadline.weight(.semibold))
            ForEach(session.sessionExercises.sorted { $0.sortOrder < $1.sortOrder }) { ex in
                HStack {
                    Image(systemName: ExerciseLibrary.icon(for: ex.muscleGroup))
                        .foregroundStyle(.orange)
                        .frame(width: 24)
                    Text(ex.exerciseName)
                        .font(.subheadline)
                    Spacer()
                    Text("\(ex.sets.filter(\.isCompleted).count)/\(ex.sets.count) sets")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private func cycleBadge(_ cycle: CycleType) -> some View {
        let color: Color = switch cycle {
            case .endurance: .blue
            case .strength:  .green
            case .power:     .red
        }
        Text(cycle.rawValue)
            .font(.caption.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private func muscleGroupChip(_ assignment: MuscleGroupAssignment) -> some View {
        HStack(spacing: 4) {
            Image(systemName: ExerciseLibrary.icon(for: assignment.muscleGroup))
                .font(.caption)
            Text("\(assignment.muscleGroup) ×\(assignment.sets)")
                .font(.caption)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(Color.orange.opacity(0.1))
        .foregroundStyle(.orange)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    // MARK: - Advance program

    private func advanceProgram() {
        // appState is always non-nil here: bootstrap seeds it before any UI renders,
        // and advanceProgram is only reachable via a callback that requires appState to be non-nil.
        let state = appState!
        let phase = ProgramData.phases[state.currentPhaseIndex]
        let week = phase.weeks[state.currentWeekIndex]

        var newDay = state.currentDayIndex + 1
        var newWeek = state.currentWeekIndex
        var newPhase = state.currentPhaseIndex

        if newDay >= week.days.count {
            newDay = 0
            newWeek += 1
            if newWeek >= phase.weeks.count {
                newWeek = 0
                newPhase = min(newPhase + 1, ProgramData.phases.count - 1)
            }
        }

        state.currentDayIndex = newDay
        state.currentWeekIndex = newWeek
        state.currentPhaseIndex = newPhase
    }
}

// MARK: - Program Position Picker

struct ProgramPositionPickerView: View {
    @Query private var appStates: [AppState]
    @Environment(\.dismiss) private var dismiss

    private var state: AppState? { appStates.first }

    var body: some View {
        NavigationStack {
            Form {
                if let state {
                    Picker("Phase", selection: Binding(get: { state.currentPhaseIndex }, set: { state.currentPhaseIndex = $0; state.currentWeekIndex = 0; state.currentDayIndex = 0 })) {
                        ForEach(ProgramData.phases) { phase in
                            Text(phase.name).tag(phase.phaseIndex)
                        }
                    }

                    if let phase = ProgramData.phase(at: state.currentPhaseIndex) {
                        Picker("Week", selection: Binding(get: { state.currentWeekIndex }, set: { state.currentWeekIndex = $0; state.currentDayIndex = 0 })) {
                            ForEach(0..<phase.weeks.count, id: \.self) { i in
                                Text("Week \(i + 1)").tag(i)
                            }
                        }

                        if let week = ProgramData.week(phaseIndex: state.currentPhaseIndex, weekIndex: state.currentWeekIndex) {
                            Picker("Day", selection: Binding(get: { state.currentDayIndex }, set: { state.currentDayIndex = $0 })) {
                                ForEach(0..<week.days.count, id: \.self) { i in
                                    Text("Day \(i + 1)").tag(i)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Set Program Position")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
