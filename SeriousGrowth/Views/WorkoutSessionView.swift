import SwiftUI
import SwiftData

struct WorkoutSessionView: View {
    let workoutDay: WorkoutDay
    let phaseIndex: Int
    let weekIndex: Int
    let dayIndex: Int
    let onComplete: () -> Void

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var allSessions: [WorkoutSession]
    @Query private var allExercises: [Exercise]
    @Query private var appStates: [AppState]

    @State private var session: WorkoutSession?
    @State private var restTimerActive = false
    @State private var restSecondsLeft = 0
    @State private var restTimer: Timer?
    @State private var showExercisePicker: MuscleGroupAssignment? = nil
    @State private var showFinishConfirm = false
    @State private var workoutStartTime = Date()

    private var useKg: Bool { appStates.first?.useKilograms ?? false }
    private var unitLabel: String { useKg ? "kg" : "lbs" }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    restTimerBanner
                    if let session {
                        ForEach(session.sessionExercises.sorted { $0.sortOrder < $1.sortOrder }) { ex in
                            ExerciseCard(
                                sessionExercise: ex,
                                restSeconds: workoutDay.restSeconds,
                                unitLabel: unitLabel,
                                recommendedWeight: recommendedWeight(for: ex.exerciseName),
                                onSetCompleted: { startRestTimer() },
                                onSwapExercise: {
                                    if let assignment = workoutDay.assignments.first(where: { $0.muscleGroup == ex.muscleGroup }) {
                                        showExercisePicker = assignment
                                    }
                                }
                            )
                        }
                    }
                    Spacer(minLength: 80)
                }
                .padding()
            }
            .navigationTitle("Day \(workoutDay.dayNumber) — \(workoutDay.cycleType.rawValue)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Finish") { showFinishConfirm = true }
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                }
            }
            .confirmationDialog("Finish workout?", isPresented: $showFinishConfirm, titleVisibility: .visible) {
                Button("Finish & Save") { finishWorkout() }
                Button("Cancel", role: .cancel) {}
            }
            .sheet(item: $showExercisePicker) { assignment in
                // showExercisePicker is only set from ExerciseCard buttons, which are
                // rendered inside `if let session`, so session is guaranteed non-nil here.
                ExercisePickerView(
                    muscleGroup: assignment.muscleGroup,
                    allExercises: allExercises.filter { $0.muscleGroup == assignment.muscleGroup }
                ) { chosen in
                    swapExercise(in: session!, forGroup: assignment.muscleGroup, to: chosen)
                }
            }
            .onAppear { setupSession() }
            .onDisappear { restTimer?.invalidate() }
        }
    }

    // MARK: - Rest Timer

    @ViewBuilder
    private var restTimerBanner: some View {
        if restTimerActive {
            HStack {
                Image(systemName: "timer")
                Text("Rest: \(restSecondsLeft)s")
                    .monospacedDigit()
                    .fontWeight(.semibold)
                Spacer()
                Button("Skip") { stopRestTimer() }
                    .font(.caption)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.orange.opacity(0.15))
            .foregroundStyle(.orange)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func startRestTimer() {
        stopRestTimer()
        restSecondsLeft = workoutDay.restSeconds
        restTimerActive = true
        restTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if restSecondsLeft > 0 {
                restSecondsLeft -= 1
            } else {
                stopRestTimer()
            }
        }
    }

    private func stopRestTimer() {
        restTimer?.invalidate()
        restTimer = nil
        restTimerActive = false
        restSecondsLeft = 0
    }

    // MARK: - Session Setup

    private func setupSession() {
        workoutStartTime = Date()
        let s = WorkoutSession(phaseIndex: phaseIndex, weekIndex: weekIndex, dayIndex: dayIndex)
        context.insert(s)

        var order = 0
        for assignment in workoutDay.assignments {
            let exerciseName = preferredExercise(for: assignment.muscleGroup)
            let se = SessionExercise(exerciseName: exerciseName, muscleGroup: assignment.muscleGroup, sortOrder: order)
            context.insert(se)

            let recWeight = recommendedWeight(for: exerciseName)
            for setNum in 1...assignment.sets {
                let ws = WorkoutSet(
                    setNumber: setNum,
                    targetRepsMin: workoutDay.repRangeMin,
                    targetRepsMax: workoutDay.repRangeMax,
                    weight: recWeight
                )
                context.insert(ws)
                se.sets.append(ws)
            }

            s.sessionExercises.append(se)
            order += 1
        }
        session = s
    }

    private func preferredExercise(for group: MuscleGroup) -> String {
        let recent = allSessions
            .sorted { $0.date > $1.date }
            .flatMap { $0.sessionExercises }
            .first { $0.muscleGroup == group }?
            .exerciseName
        // defaultExercises returns a non-empty list for every known muscle group; group is always from ProgramData's hardcoded assignments.
        return recent ?? ExerciseLibrary.defaultExercises(for: group).first!
    }

    private func recommendedWeight(for exerciseName: String) -> Double {
        let lastSet = allSessions
            .flatMap { $0.sessionExercises }
            .filter { $0.exerciseName == exerciseName }
            .flatMap { $0.sets }
            .filter { $0.isCompleted && $0.weight > 0 }
            .sorted { $0.weight < $1.weight }
            .last

        guard let w = lastSet?.weight else { return 0 }
        return (w * 1.05 * 4).rounded() / 4  // round to nearest 0.25
    }

    private func swapExercise(in session: WorkoutSession, forGroup group: MuscleGroup, to newName: String) {
        // session was built from workoutDay.assignments, which always contains an entry for every group.
        let ex = session.sessionExercises.first(where: { $0.muscleGroup == group })!
        ex.exerciseName = newName
        let recWeight = recommendedWeight(for: newName)
        for set in ex.sets { set.weight = recWeight }
    }

    private func finishWorkout() {
        // session is always set by setupSession() in onAppear before the Finish button is reachable.
        session!.durationSeconds = Int(Date().timeIntervalSince(workoutStartTime))
        onComplete()
        dismiss()
    }
}

struct ExerciseCard: View {
    @Bindable var sessionExercise: SessionExercise
    let restSeconds: Int
    let unitLabel: String
    let recommendedWeight: Double
    let onSetCompleted: () -> Void
    let onSwapExercise: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: ExerciseLibrary.icon(for: sessionExercise.muscleGroup))
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text(sessionExercise.exerciseName)
                        .font(.headline)
                    Text(sessionExercise.muscleGroup.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(action: onSwapExercise) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if recommendedWeight > 0 {
                Label("Recommended: \(recommendedWeight.formattedAsWeight) \(unitLabel)",
                      systemImage: "arrow.up.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }

            VStack(spacing: 8) {
                HStack {
                    Text("Set").font(.caption.weight(.semibold)).foregroundStyle(.secondary).frame(width: 32, alignment: .leading)
                    Text("Target").font(.caption.weight(.semibold)).foregroundStyle(.secondary).frame(maxWidth: .infinity)
                    Text("Weight (\(unitLabel))").font(.caption.weight(.semibold)).foregroundStyle(.secondary).frame(maxWidth: .infinity)
                    Text("Reps").font(.caption.weight(.semibold)).foregroundStyle(.secondary).frame(width: 60)
                    Text("✓").font(.caption.weight(.semibold)).foregroundStyle(.secondary).frame(width: 32)
                }

                ForEach(sessionExercise.sets.sorted { $0.setNumber < $1.setNumber }) { set in
                    SetRow(set: set, unitLabel: unitLabel, onComplete: onSetCompleted)
                }
            }
        }
        .padding()
        .cardMaterial()
    }
}

struct SetRow: View {
    @Bindable var set: WorkoutSet
    let unitLabel: String
    let onComplete: () -> Void

    @State private var weightText: String = ""
    @State private var repsText: String = ""
    @FocusState private var focusedField: Field?

    enum Field { case weight, reps }

    var body: some View {
        HStack(spacing: 8) {
            Text("\(set.setNumber)").font(.subheadline.weight(.semibold))
                .foregroundStyle(set.isCompleted ? .orange : .primary)
                .frame(width: 32, alignment: .leading)

            Text(set.targetRepsLabel)
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)

            TextField("0", text: $weightText)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .focused($focusedField, equals: .weight)
                .onChange(of: weightText) { _, new in
                    set.weight = Double(new) ?? set.weight
                }

            TextField("\(set.targetRepsMax)", text: $repsText)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 60)
                .padding(.vertical, 6)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .focused($focusedField, equals: .reps)
                .onChange(of: repsText) { _, new in
                    set.completedReps = Int(new) ?? set.completedReps
                }

            Button {
                focusedField = nil
                set.isCompleted.toggle()
                if set.isCompleted { onComplete() }
            } label: {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(set.isCompleted ? .green : .secondary)
            }
            .frame(width: 32)
        }
        .onAppear {
            weightText = set.weight > 0 ? set.weight.formattedAsWeight : ""
            repsText = "\(set.completedReps)"
        }
        .opacity(set.isCompleted ? 0.7 : 1.0)
    }
}

struct ExercisePickerView: View {
    let muscleGroup: MuscleGroup
    let allExercises: [Exercise]
    let onSelect: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var search = ""
    @State private var showAddCustom = false
    @State private var newExerciseName = ""
    @Environment(\.modelContext) private var context

    private var filtered: [Exercise] {
        search.isEmpty ? allExercises : allExercises.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered.sorted { !$0.isCustom && $1.isCustom || $0.name < $1.name }) { ex in
                    Button {
                        onSelect(ex.name)
                        dismiss()
                    } label: {
                        HStack {
                            Text(ex.name)
                            if ex.isCustom {
                                Spacer()
                                Text("Custom").font(.caption).foregroundStyle(.orange)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
            .searchable(text: $search, prompt: "Search exercises")
            .navigationTitle(muscleGroup.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAddCustom = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Add Custom Exercise", isPresented: $showAddCustom) {
                TextField("Exercise name", text: $newExerciseName)
                Button("Add") {
                    guard !newExerciseName.isEmpty else { return }
                    let ex = Exercise(name: newExerciseName, muscleGroup: muscleGroup, isCustom: true)
                    context.insert(ex)
                    onSelect(newExerciseName)
                    newExerciseName = ""
                    dismiss()
                }
                Button("Cancel", role: .cancel) { newExerciseName = "" }
            }
        }
    }
}
