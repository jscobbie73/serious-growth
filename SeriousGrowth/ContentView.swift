import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            HistoryView()
                .tabItem { Label("History", systemImage: "clock.fill") }
                .tag(1)

            ExercisesView()
                .tabItem { Label("Exercises", systemImage: "dumbbell.fill") }
                .tag(2)

            CardioView()
                .tabItem { Label("Cardio", systemImage: "figure.run") }
                .tag(3)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(4)
        }
        .tint(.orange)
    }
}
