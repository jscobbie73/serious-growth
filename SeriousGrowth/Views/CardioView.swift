import SwiftUI
import SwiftData
import Charts

struct CardioView: View {
    @Query(sort: \CardioSession.date, order: .reverse) private var sessions: [CardioSession]
    @Environment(\.modelContext) private var context

    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            Group {
                if sessions.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "figure.run")
                            .font(.system(size: 56))
                            .foregroundStyle(.quaternary)
                        Text("No cardio logged yet")
                            .foregroundStyle(.secondary)
                        Button("Log Cardio") { showAddSheet = true }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                        Spacer()
                    }
                } else {
                    List {
                        Section {
                            cardioSummaryRow
                        }
                        Section("Sessions") {
                            ForEach(sessions) { session in
                                CardioDetailRow(session: session)
                            }
                            .onDelete { indexSet in
                                for i in indexSet { context.delete(sessions[i]) }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Cardio")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                LogCardioSheet()
            }
        }
    }

    private var cardioSummaryRow: some View {
        HStack(spacing: 0) {
            summaryTile(
                value: "\(sessions.count)",
                label: "Sessions",
                icon: "calendar",
                color: .blue
            )
            Divider().frame(height: 50)
            summaryTile(
                value: String(format: "%.1f", sessions.filter(\.hasDistance).map(\.distanceMiles).reduce(0, +)),
                label: "Total Miles",
                icon: "arrow.right",
                color: .green
            )
            Divider().frame(height: 50)
            summaryTile(
                value: formatTotalTime(sessions.filter(\.hasDuration).map(\.durationSeconds).reduce(0, +)),
                label: "Total Time",
                icon: "timer",
                color: .orange
            )
        }
        .padding(.vertical, 8)
    }

    private func summaryTile(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).foregroundStyle(color).font(.caption)
            Text(value).font(.headline.bold())
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    private func formatTotalTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        if hours > 0 { return "\(hours)h \(minutes)m" }
        return "\(minutes)m"
    }
}

// MARK: - CardioDetailRow

struct CardioDetailRow: View {
    let session: CardioSession

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label(session.cardioType.isEmpty ? "Cardio" : session.cardioType, systemImage: iconForType(session.cardioType))
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(session.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                if session.hasDistance {
                    stat(String(format: "%.2f mi", session.distanceMiles), icon: "arrow.right")
                }
                if session.hasDuration {
                    stat(session.durationFormatted, icon: "timer")
                }
                if session.hasHeartRate {
                    stat("\(session.avgHeartRate) bpm", icon: "heart.fill", color: .red)
                }
            }

            if !session.notes.isEmpty {
                Text(session.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }

    private func stat(_ value: String, icon: String, color: Color = .secondary) -> some View {
        Label(value, systemImage: icon)
            .font(.caption)
            .foregroundStyle(color)
    }

    private func iconForType(_ type: String) -> String {
        switch type {
        case "Running": return "figure.run"
        case "Walking": return "figure.walk"
        case "Cycling": return "bicycle"
        case "Swimming": return "figure.pool.swim"
        case "Rowing": return "oar.2.crossed"
        case "Elliptical": return "figure.elliptical"
        case "Jump Rope": return "figure.jumprope"
        case "HIIT": return "bolt.fill"
        case "Stairmaster": return "stairs"
        default: return "figure.run"
        }
    }
}

// MARK: - LogCardioSheet

struct LogCardioSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var cardioType = "Running"
    @State private var hasDistance = false
    @State private var distanceMiles = 0.0
    @State private var hasDuration = false
    @State private var durationMinutes = 30
    @State private var durationSeconds = 0
    @State private var hasHeartRate = false
    @State private var avgHeartRate = 140
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Session") {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])

                    Picker("Type", selection: $cardioType) {
                        ForEach(ExerciseLibrary.cardioTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }

                Section {
                    Toggle("Log Distance", isOn: $hasDistance)
                    if hasDistance {
                        HStack {
                            Text("Miles")
                            Spacer()
                            TextField("0.0", value: $distanceMiles, format: .number.precision(.fractionLength(2)))
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 80)
                        }
                    }
                } header: { Text("Distance") }

                Section {
                    Toggle("Log Duration", isOn: $hasDuration)
                    if hasDuration {
                        HStack {
                            Text("Minutes")
                            Spacer()
                            Stepper("\(durationMinutes)", value: $durationMinutes, in: 0...600)
                        }
                        HStack {
                            Text("Seconds")
                            Spacer()
                            Stepper("\(durationSeconds)", value: $durationSeconds, in: 0...59, step: 5)
                        }
                    }
                } header: { Text("Duration") }

                Section {
                    Toggle("Log Heart Rate", isOn: $hasHeartRate)
                    if hasHeartRate {
                        HStack {
                            Text("Avg BPM")
                            Spacer()
                            Stepper("\(avgHeartRate)", value: $avgHeartRate, in: 40...220)
                        }
                    }
                } header: { Text("Heart Rate") }

                Section("Notes") {
                    TextField("Optional notes...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Log Cardio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                }
            }
        }
    }

    private func save() {
        let session = CardioSession(date: date)
        session.cardioType = cardioType
        session.hasDistance = hasDistance
        session.distanceMiles = hasDistance ? distanceMiles : 0
        session.hasDuration = hasDuration
        session.durationSeconds = hasDuration ? durationMinutes * 60 + durationSeconds : 0
        session.hasHeartRate = hasHeartRate
        session.avgHeartRate = hasHeartRate ? avgHeartRate : 0
        session.notes = notes
        context.insert(session)
        dismiss()
    }
}
