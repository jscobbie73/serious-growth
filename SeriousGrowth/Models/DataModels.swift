import SwiftData
import Foundation

// MARK: - Exercise

@Model
final class Exercise {
    var id: UUID
    var name: String
    var muscleGroup: String
    var isCustom: Bool
    var createdAt: Date

    init(name: String, muscleGroup: String, isCustom: Bool = false) {
        self.id = UUID()
        self.name = name
        self.muscleGroup = muscleGroup
        self.isCustom = isCustom
        self.createdAt = Date()
    }
}

// MARK: - WorkoutSession

@Model
final class WorkoutSession {
    var id: UUID
    var date: Date
    var phaseIndex: Int
    var weekIndex: Int
    var dayIndex: Int
    var notes: String
    var durationSeconds: Int

    @Relationship(deleteRule: .cascade) var sessionExercises: [SessionExercise]

    var isCompleted: Bool { !sessionExercises.isEmpty }

    var dayLabel: String { "Day \(dayIndex + 1)" }

    init(phaseIndex: Int, weekIndex: Int, dayIndex: Int) {
        self.id = UUID()
        self.date = Date()
        self.phaseIndex = phaseIndex
        self.weekIndex = weekIndex
        self.dayIndex = dayIndex
        self.notes = ""
        self.durationSeconds = 0
        self.sessionExercises = []
    }
}

// MARK: - SessionExercise

@Model
final class SessionExercise {
    var id: UUID
    var exerciseName: String
    var muscleGroup: String
    var sortOrder: Int

    @Relationship(deleteRule: .cascade) var sets: [WorkoutSet]

    var isCompleted: Bool { !sets.isEmpty && sets.allSatisfy { $0.isCompleted } }

    var lastCompletedWeight: Double {
        sets.filter { $0.isCompleted }.last?.weight ?? 0
    }

    init(exerciseName: String, muscleGroup: String, sortOrder: Int) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.sortOrder = sortOrder
        self.sets = []
    }
}

// MARK: - WorkoutSet

@Model
final class WorkoutSet {
    var id: UUID
    var setNumber: Int
    var targetRepsMin: Int
    var targetRepsMax: Int
    var completedReps: Int
    var weight: Double
    var isCompleted: Bool

    var targetRepsLabel: String { "\(targetRepsMin)–\(targetRepsMax)" }

    init(setNumber: Int, targetRepsMin: Int, targetRepsMax: Int, weight: Double = 0) {
        self.id = UUID()
        self.setNumber = setNumber
        self.targetRepsMin = targetRepsMin
        self.targetRepsMax = targetRepsMax
        self.completedReps = targetRepsMax
        self.weight = weight
        self.isCompleted = false
    }
}

// MARK: - CardioSession

@Model
final class CardioSession {
    var id: UUID
    var date: Date
    var cardioType: String
    var distanceMiles: Double
    var durationSeconds: Int
    var avgHeartRate: Int
    var notes: String
    var hasDistance: Bool
    var hasDuration: Bool
    var hasHeartRate: Bool

    var durationFormatted: String {
        guard hasDuration else { return "—" }
        let h = durationSeconds / 3600
        let m = (durationSeconds % 3600) / 60
        let s = durationSeconds % 60
        if h > 0 { return String(format: "%d:%02d:%02d", h, m, s) }
        return String(format: "%d:%02d", m, s)
    }

    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
        self.cardioType = "Running"
        self.distanceMiles = 0
        self.durationSeconds = 0
        self.avgHeartRate = 0
        self.notes = ""
        self.hasDistance = false
        self.hasDuration = false
        self.hasHeartRate = false
    }
}

// MARK: - AppState

@Model
final class AppState {
    var id: UUID
    var currentPhaseIndex: Int
    var currentWeekIndex: Int
    var currentDayIndex: Int
    var programStartDate: Date
    var useKilograms: Bool

    init() {
        self.id = UUID()
        self.currentPhaseIndex = 0
        self.currentWeekIndex = 0
        self.currentDayIndex = 0
        self.programStartDate = Date()
        self.useKilograms = false
    }
}

// MARK: - Helpers

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Double {
    var formattedAsWeight: String {
        truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}

extension Int {
    var formattedAsDuration: String {
        let h = self / 3600
        let m = (self % 3600) / 60
        return h > 0 ? "\(h)h \(m)m" : "\(m)m"
    }
}

import SwiftUI

struct CardMaterial: ViewModifier {
    func body(content: Content) -> some View {
        content.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

extension View {
    func cardMaterial() -> some View {
        modifier(CardMaterial())
    }
}
