import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var appStates: [AppState]
    @Environment(\.modelContext) private var context

    private var state: AppState? { appStates.first }

    var body: some View {
        NavigationStack {
            Form {
                // Weight units
                Section("Units") {
                    if let state {
                        Toggle("Use Kilograms (kg)", isOn: Binding(
                            get: { state.useKilograms },
                            set: { state.useKilograms = $0 }
                        ))
                    }
                }

                // Program overview
                Section("18-Week Program") {
                    ForEach(ProgramData.phases) { phase in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(phase.name).font(.subheadline.weight(.semibold))
                                Text("Weeks \(phase.weekStart)–\(phase.weekStart + phase.weeks.count - 1)")
                                    .font(.caption).foregroundStyle(.secondary)
                                Text(phase.focusDescription)
                                    .font(.caption2).foregroundStyle(.tertiary)
                            }
                            Spacer()
                            Text(phase.shortName)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(.orange)
                        }
                        .padding(.vertical, 2)
                    }
                }

                // About
                Section("About") {
                    LabeledContent("App", value: "Serious Growth")
                    LabeledContent("Program", value: "Level 1 — 18 Weeks")
                    LabeledContent("iCloud Sync", value: "Enabled")
                    LabeledContent("Version", value: "1.0.0")
                }

                // Reset
                Section {
                    Button("Reset Program Position", role: .destructive) {
                        state?.currentPhaseIndex = 0
                        state?.currentWeekIndex = 0
                        state?.currentDayIndex = 0
                        state?.programStartDate = Date()
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
