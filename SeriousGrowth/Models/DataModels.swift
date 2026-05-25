import SwiftData
import Foundation

// MARK: - MuscleGroup

enum MuscleGroup: String, Codable, CaseIterable, Identifiable {
    case back    = "Back"
    case chest   = "Chest"
    case bicep   = "Bicep"
    case calf    = "Calf"
    case delts   = "Delts"
    case tricep  = "Tricep"
    case thighs  = "Thighs"
    case abs     = "Abs"

    var id: String { rawValue }
}

// MARK: - Exercise

@Model
final class Exercise {
    var name: String
    var muscleGroup: MuscleGroup
    var isCustom: Bool

    init(name: String, muscleGroup: MuscleGroup, isCustom: Bool = false) {
        self.name = name
        self.muscleGroup = muscleGroup
        self.isCustom = isCustom
    }
}

// MARK: - WorkoutSession

@Model
final class WorkoutSession {
    var date: Date
    var phaseIndex: Int
    var weekIndex: Int
    var dayIndex: Int
    var notes: String
    var durationSeconds: Int

    @Relationship(deleteRule: .cascade) var sessionExercises: [SessionExercise]

    var dayLabel: String { "Day \(dayIndex + 1)" }

    init(phaseIndex: Int, weekIndex: Int, dayIndex: Int) {
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
    var exerciseName: String
    var muscleGroup: MuscleGroup
    var sortOrder: Int

    @Relationship(deleteRule: .cascade) var sets: [WorkoutSet]

    init(exerciseName: String, muscleGroup: MuscleGroup, sortOrder: Int) {
        self.exerciseName = exerciseName
        self.muscleGroup = muscleGroup
        self.sortOrder = sortOrder
        self.sets = []
    }
}

// MARK: - WorkoutSet

@Model
final class WorkoutSet {
    var setNumber: Int
    var targetRepsMin: Int
    var targetRepsMax: Int
    var completedReps: Int
    var weight: Double
    var isCompleted: Bool

    var targetRepsLabel: String { "\(targetRepsMin)–\(targetRepsMax)" }

    init(setNumber: Int, targetRepsMin: Int, targetRepsMax: Int, weight: Double = 0) {
        self.setNumber = setNumber
        self.targetRepsMin = targetRepsMin
        self.targetRepsMax = targetRepsMax
        self.completedReps = targetRepsMax
        self.weight = weight
        self.isCompleted = false
    }
}

// MARK: - CardioType

enum CardioType: String, Codable {
    case running   = "Running"
    case walking   = "Walking"
    case cycling   = "Cycling"
    case swimming  = "Swimming"
    case rowing    = "Rowing"
    case elliptical = "Elliptical"
    case jumpRope  = "Jump Rope"
    case hiit      = "HIIT"
    case stairmaster = "Stairmaster"
    case other     = "Other"
}

// MARK: - CardioSession

@Model
final class CardioSession {
    var date: Date
    var cardioType: CardioType
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
        self.date = date
        self.cardioType = .running
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
    var currentPhaseIndex: Int
    var currentWeekIndex: Int
    var currentDayIndex: Int
    var useKilograms: Bool

    init() {
        self.currentPhaseIndex = 0
        self.currentWeekIndex = 0
        self.currentDayIndex = 0
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
