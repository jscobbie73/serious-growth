import SwiftUI
import SwiftData
import Charts

// MARK: - HistoryView

struct HistoryView: View {
    @Query(sort: \WorkoutSession.date, order: .reverse) private var sessions: [WorkoutSession]
    @Query(sort: \CardioSession.date, order: .reverse) private var cardioSessions: [CardioSession]

    @State private var selectedTab = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    Text("Workouts").tag(0)
                    Text("Cardio").tag(1)
                    Text("Charts").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()

                if selectedTab == 0 {
                    workoutList
                } else if selectedTab == 1 {
                    cardioList
                } else {
                    chartsView
                }
            }
            .navigationTitle("History")
        }
    }

    // MARK: - Workout List

    private var workoutList: some View {
        Group {
            if sessions.isEmpty {
                emptyState(icon: "figure.strengthtraining.traditional", message: "No workouts logged yet")
            } else {
                List {
                    ForEach(sessions) { session in
                        NavigationLink {
                            WorkoutDetailView(session: session)
                        } label: {
                            WorkoutRowView(session: session)
                        }
                    }
                    .onDelete { indexSet in
                        for i in indexSet { sessions[i].modelContext?.delete(sessions[i]) }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }

    // MARK: - Cardio List

    private var cardioList: some View {
        Group {
            if cardioSessions.isEmpty {
                emptyState(icon: "figure.run", message: "No cardio logged yet")
            } else {
                List {
                    ForEach(cardioSessions) { session in
                        CardioRowView(session: session)
                    }
                    .onDelete { indexSet in
                        for i in indexSet { cardioSessions[i].modelContext?.delete(cardioSessions[i]) }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
    }

    // MARK: - Charts

    private var chartsView: some View {
        WeightProgressView()
    }

    private func emptyState(icon: String, message: String) -> some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundStyle(.quaternary)
            Text(message)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
}

// MARK: - WorkoutRowView

struct WorkoutRowView: View {
    let session: WorkoutSession

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(session.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(ProgramData.phases[safe: session.phaseIndex]?.name ?? "Phase \(session.phaseIndex + 1)")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
            Text(session.dayLabel)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(session.sessionExercises.map { $0.muscleGroup }.joined(separator: " · "))
                .font(.caption)
                .foregroundStyle(.tertiary)
                .lineLimit(1)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - CardioRowView

struct CardioRowView: View {
    let session: CardioSession

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(session.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(session.cardioType.rawValue)
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
            HStack(spacing: 12) {
                if session.hasDistance {
                    Label(String(format: "%.1f mi", session.distanceMiles), systemImage: "arrow.right")
                        .font(.caption)
                }
                if session.hasDuration {
                    Label(session.durationFormatted, systemImage: "timer")
                        .font(.caption)
                }
                if session.hasHeartRate {
                    Label("\(session.avgHeartRate) bpm", systemImage: "heart.fill")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

// MARK: - WorkoutDetailView

struct WorkoutDetailView: View {
    let session: WorkoutSession
    @Query private var appStates: [AppState]

    private var useKg: Bool { appStates.first?.useKilograms ?? false }
    private var unit: String { useKg ? "kg" : "lbs" }

    var body: some View {
        List {
            Section("Summary") {
                LabeledContent("Date", value: session.date.formatted(date: .long, time: .shortened))
                LabeledContent("Phase", value: ProgramData.phases[safe: session.phaseIndex]?.name ?? "Phase \(session.phaseIndex + 1)")
                LabeledContent("Day", value: session.dayLabel)
                if session.durationSeconds > 0 {
                    LabeledContent("Duration", value: session.durationSeconds.formattedAsDuration)
                }
            }

            ForEach(session.sessionExercises.sorted { $0.sortOrder < $1.sortOrder }) { ex in
                Section(ex.exerciseName) {
                    ForEach(ex.sets.sorted { $0.setNumber < $1.setNumber }) { set in
                        HStack {
                            Text("Set \(set.setNumber)")
                            Spacer()
                            if set.isCompleted {
                                Text("\(set.weight > 0 ? set.weight.formattedAsWeight : "BW") \(set.weight > 0 ? unit : "")  ×\(set.completedReps)")
                                    .foregroundStyle(.primary)
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                            } else {
                                Text("Not completed").foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(session.date.formatted(date: .abbreviated, time: .omitted))
        .navigationBarTitleDisplayMode(.inline)
    }

}

// MARK: - WeightProgressView

struct WeightProgressView: View {
    @Query(sort: \WorkoutSession.date) private var sessions: [WorkoutSession]
    @Query private var appStates: [AppState]

    @State private var selectedMuscleGroup = "Back"
    @State private var selectedExercise: String? = nil

    private var useKg: Bool { appStates.first?.useKilograms ?? false }
    private var unit: String { useKg ? "kg" : "lbs" }

    private var exercisesForGroup: [String] {
        Array(Set(sessions.flatMap { $0.sessionExercises }
            .filter { $0.muscleGroup == selectedMuscleGroup }
            .map { $0.exerciseName }))
        .sorted()
    }

    private var chartData: [WeightPoint] {
        guard let exercise = selectedExercise else { return [] }
        return sessions
            .compactMap { session -> WeightPoint? in
                guard let ex = session.sessionExercises.first(where: { $0.exerciseName == exercise }),
                      let maxSet = ex.sets.filter({ $0.isCompleted && $0.weight > 0 }).max(by: { $0.weight < $1.weight })
                else { return nil }
                return WeightPoint(date: session.date, weight: maxSet.weight)
            }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Muscle group picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ExerciseLibrary.muscleGroups, id: \.self) { group in
                            Button {
                                selectedMuscleGroup = group
                                selectedExercise = exercisesForGroup.first
                            } label: {
                                Text(group)
                                    .font(.caption.weight(.semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedMuscleGroup == group ? Color.orange : Color(.systemGray5))
                                    .foregroundStyle(selectedMuscleGroup == group ? .white : .primary)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                if exercisesForGroup.isEmpty {
                    Text("No data for \(selectedMuscleGroup)")
                        .foregroundStyle(.secondary)
                        .padding()
                } else {
                    // Exercise picker
                    Picker("Exercise", selection: Binding(
                        get: { selectedExercise ?? exercisesForGroup.first ?? "" },
                        set: { selectedExercise = $0 }
                    )) {
                        ForEach(exercisesForGroup, id: \.self) { name in
                            Text(name).tag(name)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.horizontal)

                    if chartData.isEmpty {
                        Text("Log some sets to see progress")
                            .foregroundStyle(.secondary)
                            .padding()
                    } else {
                        weightChart
                        personalRecordCards
                    }
                }
            }
            .padding(.bottom)
        }
        .onAppear {
            selectedExercise = exercisesForGroup.first
        }
        .onChange(of: selectedMuscleGroup) { _, _ in
            selectedExercise = exercisesForGroup.first
        }
    }

    private var weightChart: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Max Weight per Session")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            Chart(chartData) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Weight", point.weight)
                )
                .foregroundStyle(.orange)
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Date", point.date),
                    y: .value("Weight", point.weight)
                )
                .foregroundStyle(.orange.opacity(0.1))
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Date", point.date),
                    y: .value("Weight", point.weight)
                )
                .foregroundStyle(.orange)
                .symbolSize(30)
            }
            .chartYAxisLabel(unit)
            .frame(height: 200)
            .padding(.horizontal)
        }
        .padding(.vertical)
        .cardMaterial()
        .padding(.horizontal)
    }

    private var personalRecordCards: some View {
        HStack(spacing: 12) {
            if let pr = chartData.max(by: { $0.weight < $1.weight }) {
                statCard(value: pr.weight.formattedAsWeight + " \(unit)", label: "Personal Record", icon: "trophy.fill", color: .yellow)
            }
            if let last = chartData.last {
                statCard(value: last.weight.formattedAsWeight + " \(unit)", label: "Last Session", icon: "clock.fill", color: .blue)
            }
            statCard(value: "\(chartData.count)", label: "Sessions", icon: "calendar", color: .green)
        }
        .padding(.horizontal)
    }

    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).foregroundStyle(color)
            Text(value).font(.subheadline.weight(.bold))
            Text(label).font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    struct WeightPoint: Identifiable {
        let id = UUID()
        let date: Date
        let weight: Double
    }
}
