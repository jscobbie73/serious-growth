import SwiftUI
import SwiftData

struct ExercisesView: View {
    @Query(sort: \Exercise.name) private var exercises: [Exercise]
    @Environment(\.modelContext) private var context

    @State private var selectedGroup = "Back"
    @State private var showAddSheet = false
    @State private var search = ""
    @State private var showDeleteConfirm: Exercise? = nil

    private var grouped: [Exercise] {
        exercises
            .filter { $0.muscleGroup == selectedGroup }
            .filter { search.isEmpty || $0.name.localizedCaseInsensitiveContains(search) }
            .sorted { !$0.isCustom && $1.isCustom || $0.name < $1.name }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Muscle group filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(ExerciseLibrary.muscleGroups, id: \.self) { group in
                            Button {
                                selectedGroup = group
                            } label: {
                                HStack(spacing: 4) {
                                    Image(systemName: ExerciseLibrary.icon(for: group))
                                    Text(group)
                                }
                                .font(.caption.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(selectedGroup == group ? Color.orange : Color(.systemGray5))
                                .foregroundStyle(selectedGroup == group ? .white : .primary)
                                .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }

                List {
                    ForEach(grouped) { exercise in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(exercise.name)
                                    .font(.body)
                                if exercise.isCustom {
                                    Text("Custom")
                                        .font(.caption2)
                                        .foregroundStyle(.orange)
                                }
                            }
                            Spacer()
                            if exercise.isCustom {
                                Button(role: .destructive) {
                                    showDeleteConfirm = exercise
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                        .font(.caption)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $search, prompt: "Search \(selectedGroup)")
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddExerciseSheet(defaultGroup: selectedGroup)
            }
            .confirmationDialog(
                "Delete \"\(showDeleteConfirm?.name ?? "")\"?",
                isPresented: Binding(get: { showDeleteConfirm != nil }, set: { if !$0 { showDeleteConfirm = nil } }),
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    if let ex = showDeleteConfirm { context.delete(ex) }
                    showDeleteConfirm = nil
                }
            }
        }
    }
}

// MARK: - AddExerciseSheet

struct AddExerciseSheet: View {
    let defaultGroup: String
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var muscleGroup: String

    init(defaultGroup: String) {
        self.defaultGroup = defaultGroup
        _muscleGroup = State(initialValue: defaultGroup)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Exercise Details") {
                    TextField("Name", text: $name)

                    Picker("Muscle Group", selection: $muscleGroup) {
                        ForEach(ExerciseLibrary.muscleGroups, id: \.self) { group in
                            Text(group).tag(group)
                        }
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        context.insert(Exercise(name: name.trimmingCharacters(in: .whitespaces),
                                                muscleGroup: muscleGroup,
                                                isCustom: true))
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
