import SwiftUI
import SwiftData

@main
struct SeriousGrowthApp: App {

    let container: ModelContainer

    init() {
        let schema = Schema([
            Exercise.self,
            WorkoutSession.self,
            SessionExercise.self,
            WorkoutSet.self,
            CardioSession.self,
            AppState.self
        ])

        let config = ModelConfiguration(
            schema: schema,
            cloudKitDatabase: .automatic
        )

        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(container)
        }
    }
}

// MARK: - Root bootstrapper

struct RootView: View {
    @Query private var appStates: [AppState]
    @Query private var exercises: [Exercise]
    @Environment(\.modelContext) private var context

    var body: some View {
        ContentView()
            .onAppear { bootstrap() }
    }

    private func bootstrap() {
        if appStates.isEmpty {
            context.insert(AppState())
        }
        if exercises.isEmpty {
            seedExerciseLibrary()
        }
    }

    private func seedExerciseLibrary() {
        for group in ExerciseLibrary.muscleGroups {
            for name in ExerciseLibrary.defaultExercises(for: group) {
                context.insert(Exercise(name: name, muscleGroup: group, isCustom: false))
            }
        }
    }
}
