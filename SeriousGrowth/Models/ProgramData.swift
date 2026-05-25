import Foundation

// MARK: - Domain Types

enum CycleType: String, Codable {
    case endurance = "Endurance"
    case strength  = "Strength"
    case power     = "Power"
}

struct MuscleGroupAssignment: Identifiable {
    let id = UUID()
    let muscleGroup: MuscleGroup
    let sets: Int
}

struct WorkoutDay: Identifiable {
    let id = UUID()
    let dayNumber: Int          // 1–4
    let cycleType: CycleType
    let assignments: [MuscleGroupAssignment]
    let restSeconds: Int
    let repRangeMin: Int
    let repRangeMax: Int
}

struct ProgramWeek: Identifiable {
    let id = UUID()
    let weekNumber: Int         // 1-indexed within phase
    let days: [WorkoutDay]
}

struct ProgramPhase: Identifiable {
    let id = UUID()
    let name: String
    let shortName: String
    let phaseIndex: Int
    let weekStart: Int          // overall program week (1-based)
    let weeks: [ProgramWeek]
    let focusDescription: String
}

// MARK: - Program Builder Helpers

private func day(
    _ number: Int,
    cycle: CycleType,
    rest: Int,
    reps: ClosedRange<Int>,
    _ groups: (MuscleGroup, Int)...
) -> WorkoutDay {
    WorkoutDay(
        dayNumber: number,
        cycleType: cycle,
        assignments: groups.map { MuscleGroupAssignment(muscleGroup: $0.0, sets: $0.1) },
        restSeconds: rest,
        repRangeMin: reps.lowerBound,
        repRangeMax: reps.upperBound
    )
}

private func week(_ number: Int, days: [WorkoutDay]) -> ProgramWeek {
    ProgramWeek(weekNumber: number, days: days)
}

// MARK: - Program Data

enum ProgramData {

    // Standard 4-day templates reused across phases
    private static func standardDays4(rest: Int, cycleA: ClosedRange<Int>, cycleB: ClosedRange<Int>, cycleC: ClosedRange<Int>, sets: Int) -> [WorkoutDay] {
        [
            day(1, cycle: .endurance, rest: rest, reps: cycleA,
                (.back, sets), (.chest, sets), (.bicep, sets), (.calf, sets)),
            day(2, cycle: .endurance, rest: rest, reps: cycleA,
                (.delts, sets), (.tricep, sets), (.thighs, sets), (.abs, sets)),
            day(3, cycle: .strength, rest: rest, reps: cycleB,
                (.back, sets), (.chest, sets), (.thighs, sets), (.delts, 1), (.calf, 2), (.bicep, 1), (.tricep, 1)),
            day(4, cycle: .power, rest: rest, reps: cycleC,
                (.thighs, sets), (.chest, sets), (.back, sets), (.delts, 1), (.calf, 2), (.tricep, 1), (.bicep, 1))
        ]
    }

    static let phases: [ProgramPhase] = [

        // ── RAMP 1 (Weeks 1–3) ──────────────────────────────────────────────
        ProgramPhase(
            name: "Ramp 1", shortName: "R1",
            phaseIndex: 0, weekStart: 1,
            weeks: [
                week(1, days: standardDays4(rest: 120, cycleA: 13...15, cycleB: 10...12, cycleC: 8...10, sets: 3)),
                week(2, days: standardDays4(rest: 90,  cycleA: 13...15, cycleB: 10...12, cycleC: 8...10, sets: 4)),
                week(3, days: standardDays4(rest: 90,  cycleA: 13...15, cycleB: 10...12, cycleC: 8...10, sets: 5))
            ],
            focusDescription: "Progressive volume increase, sub-optimal → optimal zone"
        ),

        // ── SUPERGROWTH PHASE 1 (Weeks 4–6) ─────────────────────────────────
        ProgramPhase(
            name: "Supergrowth Phase 1", shortName: "SG1",
            phaseIndex: 1, weekStart: 4,
            weeks: (1...3).map { n in
                week(n, days: [
                    day(1, cycle: .endurance, rest: 180, reps: 10...12,
                        (.back, 3), (.chest, 3), (.bicep, 3), (.calf, 3)),
                    day(2, cycle: .endurance, rest: 180, reps: 10...12,
                        (.delts, 3), (.tricep, 3), (.thighs, 3), (.abs, 3)),
                    day(3, cycle: .strength, rest: 180, reps: 8...10,
                        (.back, 3), (.chest, 3), (.thighs, 3), (.delts, 1), (.calf, 2), (.bicep, 1), (.tricep, 1)),
                    day(4, cycle: .power, rest: 180, reps: 5...7,
                        (.thighs, 3), (.chest, 3), (.back, 3), (.delts, 1), (.calf, 2), (.tricep, 1), (.bicep, 1))
                ])
            },
            focusDescription: "Hypo-zone training, 180s rest, 10–12 reps endurance"
        ),

        // ── RAMP 2 (Weeks 7–9) ──────────────────────────────────────────────
        ProgramPhase(
            name: "Ramp 2", shortName: "R2",
            phaseIndex: 2, weekStart: 7,
            weeks: [
                week(1, days: [
                    day(1, cycle: .endurance, rest: 150, reps: 13...15,
                        ("Back", 3), ("Chest", 3), ("Thighs", 3), ("Calf", 3), ("Bicep", 3)),
                    day(2, cycle: .endurance, rest: 150, reps: 13...15,
                        ("Chest", 3), ("Back", 3), ("Thighs", 3), ("Calf", 3), ("Tricep", 3)),
                    day(3, cycle: .strength, rest: 150, reps: 10...12,
                        ("Back", 3), ("Chest", 3), ("Thighs", 3), ("Delts", 1), ("Calf", 2), ("Bicep", 1), ("Tricep", 1)),
                    day(4, cycle: .power, rest: 150, reps: 8...10,
                        ("Thighs", 3), ("Chest", 3), ("Back", 3), ("Delts", 1), ("Calf", 2), ("Tricep", 1), ("Bicep", 1))
                ]),
                week(2, days: [
                    day(1, cycle: .endurance, rest: 90, reps: 13...15,
                        ("Back", 3), ("Chest", 3), ("Thighs", 3), ("Calf", 3), ("Bicep", 3)),
                    day(2, cycle: .endurance, rest: 90, reps: 13...15,
                        ("Chest", 3), ("Back", 3), ("Thighs", 3), ("Calf", 3), ("Tricep", 2)),
                    day(3, cycle: .strength, rest: 90, reps: 10...12,
                        ("Thighs", 3), ("Chest", 3), ("Back", 3), ("Calf", 2), ("Delts", 1), ("Bicep", 1), ("Tricep", 1)),
                    day(4, cycle: .power, rest: 90, reps: 8...10,
                        ("Back", 3), ("Chest", 3), ("Thighs", 3), ("Delts", 1), ("Calf", 2), ("Tricep", 1), ("Bicep", 1))
                ]),
                week(3, days: [
                    day(1, cycle: .endurance, rest: 60, reps: 13...15,
                        ("Back", 4), ("Chest", 4), ("Thighs", 4), ("Calf", 4), ("Bicep", 4)),
                    day(2, cycle: .endurance, rest: 60, reps: 13...15,
                        ("Chest", 4), ("Back", 4), ("Thighs", 4), ("Calf", 4), ("Tricep", 3)),
                    day(3, cycle: .strength, rest: 60, reps: 10...12,
                        ("Back", 4), ("Chest", 4), ("Thighs", 4), ("Calf", 3), ("Delts", 2), ("Tricep", 1), ("Bicep", 1)),
                    day(4, cycle: .power, rest: 60, reps: 8...10,
                        ("Thighs", 4), ("Chest", 4), ("Back", 4), ("Calf", 3), ("Delts", 2), ("Tricep", 1), ("Bicep", 1))
                ])
            ],
            focusDescription: "Progressive volume increase, sub-optimal → optimal zone"
        ),

        // ── SUPERGROWTH PHASE 2 (Weeks 10–12) ───────────────────────────────
        ProgramPhase(
            name: "Supergrowth Phase 2", shortName: "SG2",
            phaseIndex: 3, weekStart: 10,
            weeks: (1...3).map { n in
                week(n, days: [
                    day(1, cycle: .endurance, rest: 90, reps: 13...15,
                        ("Back", 4), ("Chest", 4), ("Bicep", 4), ("Calf", 4)),
                    day(2, cycle: .endurance, rest: 90, reps: 13...15,
                        ("Delts", 4), ("Tricep", 4), ("Thighs", 4), ("Abs", 4)),
                    day(3, cycle: .strength, rest: 90, reps: 10...12,
                        ("Back", 4), ("Chest", 4), ("Calf", 2), ("Tricep", 1), ("Bicep", 1)),
                    day(4, cycle: .power, rest: 90, reps: 8...10,
                        ("Thighs", 4), ("Chest", 4), ("Delts", 2), ("Calf", 2), ("Tricep", 1), ("Bicep", 1))
                ])
            },
            focusDescription: "Optimal zone training, 90s rest, 13–15 reps endurance"
        ),

        // ── RAMP 3 (Weeks 13–15) ────────────────────────────────────────────
        ProgramPhase(
            name: "Ramp 3", shortName: "R3",
            phaseIndex: 4, weekStart: 13,
            weeks: [
                week(1, days: [
                    day(1, cycle: .endurance, rest: 120, reps: 13...15,
                        ("Back", 3), ("Chest", 3), ("Bicep", 4), ("Calf", 3)),
                    day(2, cycle: .endurance, rest: 120, reps: 13...15,
                        ("Delts", 4), ("Tricep", 4), ("Thighs", 3), ("Abs", 3)),
                    day(3, cycle: .strength, rest: 90, reps: 10...12,
                        ("Back", 3), ("Chest", 3), ("Thighs", 3), ("Calf", 2), ("Delts", 2)),
                    day(4, cycle: .power, rest: 60, reps: 8...10,
                        ("Thighs", 3), ("Chest", 3), ("Back", 3), ("Delts", 2), ("Calf", 2))
                ]),
                week(2, days: [
                    day(1, cycle: .endurance, rest: 120, reps: 13...15,
                        ("Back", 3), ("Chest", 3), ("Bicep", 4), ("Calf", 3)),
                    day(2, cycle: .endurance, rest: 120, reps: 13...15,
                        ("Delts", 4), ("Tricep", 4), ("Thighs", 3), ("Abs", 3)),
                    day(3, cycle: .strength, rest: 90, reps: 10...12,
                        ("Back", 3), ("Chest", 3), ("Thighs", 3), ("Calf", 2), ("Delts", 2)),
                    day(4, cycle: .power, rest: 60, reps: 8...10,
                        ("Thighs", 3), ("Chest", 3), ("Back", 3), ("Delts", 2), ("Calf", 2))
                ]),
                week(3, days: [
                    day(1, cycle: .endurance, rest: 120, reps: 13...15,
                        ("Back", 4), ("Chest", 4), ("Bicep", 5), ("Calf", 4)),
                    day(2, cycle: .endurance, rest: 120, reps: 13...15,
                        ("Delts", 5), ("Tricep", 5), ("Thighs", 4), ("Abs", 4)),
                    day(3, cycle: .strength, rest: 120, reps: 10...12,
                        ("Back", 4), ("Chest", 4), ("Thighs", 4), ("Calf", 2), ("Delts", 2)),
                    day(4, cycle: .power, rest: 120, reps: 8...10,
                        ("Thighs", 4), ("Chest", 4), ("Back", 4), ("Delts", 2), ("Calf", 2))
                ])
            ],
            focusDescription: "Progressive volume increase, sub-optimal → optimal zone"
        ),

        // ── SUPERGROWTH PHASE 3 (Weeks 16–18) ───────────────────────────────
        ProgramPhase(
            name: "Supergrowth Phase 3", shortName: "SG3",
            phaseIndex: 5, weekStart: 16,
            weeks: (1...3).map { n in
                week(n, days: [
                    day(1, cycle: .endurance, rest: 60, reps: 13...15,
                        ("Back", 4), ("Chest", 4), ("Bicep", 4), ("Calf", 4)),
                    day(2, cycle: .endurance, rest: 60, reps: 13...15,
                        ("Delts", 4), ("Tricep", 4), ("Thighs", 4), ("Abs", 4)),
                    day(3, cycle: .strength, rest: 120, reps: 8...10,
                        ("Back", 3), ("Chest", 3), ("Thighs", 3), ("Delts", 1), ("Calf", 2), ("Bicep", 1), ("Tricep", 1)),
                    day(4, cycle: .power, rest: 180, reps: 4...6,
                        ("Thighs", 3), ("Chest", 3), ("Back", 3), ("Delts", 1), ("Calf", 2), ("Tricep", 1), ("Bicep", 1))
                ])
            },
            focusDescription: "Peak training, 60–180s rest, mixed rep ranges"
        )
    ]

    // MARK: - Lookups

    static func phase(at index: Int) -> ProgramPhase? { phases[safe: index] }

    static func week(phaseIndex: Int, weekIndex: Int) -> ProgramWeek? {
        phase(at: phaseIndex)?.weeks[safe: weekIndex]
    }

    static func workoutDay(phaseIndex: Int, weekIndex: Int, dayIndex: Int) -> WorkoutDay? {
        week(phaseIndex: phaseIndex, weekIndex: weekIndex)?.days[safe: dayIndex]
    }

    static var totalWeeks: Int { phases.flatMap(\.weeks).count }

    // Overall program week number (1-based)
    static func overallWeek(phaseIndex: Int, weekIndex: Int) -> Int {
        phases[phaseIndex].weekStart + weekIndex
    }
}
