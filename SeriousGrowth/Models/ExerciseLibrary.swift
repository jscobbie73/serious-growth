import Foundation

enum ExerciseLibrary {

    static let muscleGroups: [MuscleGroup] = MuscleGroup.allCases

    static let muscleGroupIcon: [MuscleGroup: String] = [
        .back:   "figure.strengthtraining.traditional",
        .chest:  "heart.fill",
        .bicep:  "figure.arms.open",
        .calf:   "figure.walk",
        .delts:  "figure.boxing",
        .tricep: "figure.cooldown",
        .thighs: "figure.run",
        .abs:    "figure.core.training"
    ]

    static let defaults: [MuscleGroup: [String]] = [
        .back: [
            "Barbell Row",
            "Dumbbell Row",
            "Lat Pulldown",
            "Seated Cable Row",
            "T-Bar Row",
            "Pull-Up",
            "Chin-Up",
            "Face Pull",
            "Deadlift",
            "Single-Arm Cable Row",
            "Meadows Row",
            "Rack Pull",
            "Inverted Row"
        ],
        .chest: [
            "Barbell Bench Press",
            "Dumbbell Bench Press",
            "Incline Barbell Press",
            "Incline Dumbbell Press",
            "Decline Bench Press",
            "Cable Fly",
            "Dumbbell Fly",
            "Chest Dip",
            "Push-Up",
            "Pec Deck Machine",
            "Smith Machine Press",
            "Landmine Press",
            "Incline Cable Fly"
        ],
        .bicep: [
            "Barbell Curl",
            "Dumbbell Curl",
            "Hammer Curl",
            "Preacher Curl",
            "Incline Dumbbell Curl",
            "Cable Curl",
            "Concentration Curl",
            "EZ-Bar Curl",
            "Spider Curl",
            "Reverse Curl",
            "Cross-Body Hammer Curl"
        ],
        .calf: [
            "Standing Calf Raise",
            "Seated Calf Raise",
            "Leg Press Calf Raise",
            "Donkey Calf Raise",
            "Single-Leg Calf Raise",
            "Smith Machine Calf Raise",
            "Calf Press (Machine)"
        ],
        .delts: [
            "Overhead Press (Barbell)",
            "Overhead Press (Dumbbell)",
            "Lateral Raise",
            "Front Raise",
            "Rear Delt Fly",
            "Arnold Press",
            "Upright Row",
            "Cable Lateral Raise",
            "Machine Shoulder Press",
            "Cable Front Raise",
            "Bent-Over Lateral Raise",
            "Face Pull",
            "Plate Front Raise"
        ],
        .tricep: [
            "Tricep Pushdown (Cable)",
            "Skull Crusher",
            "Close-Grip Bench Press",
            "Overhead Tricep Extension",
            "Tricep Dip",
            "Kickback",
            "Diamond Push-Up",
            "Rope Pushdown",
            "JM Press",
            "French Press",
            "Tate Press",
            "Single-Arm Pushdown"
        ],
        .thighs: [
            "Barbell Squat",
            "Leg Press",
            "Hack Squat",
            "Leg Extension",
            "Leg Curl (Lying)",
            "Leg Curl (Seated)",
            "Romanian Deadlift",
            "Lunge",
            "Bulgarian Split Squat",
            "Sumo Squat",
            "Goblet Squat",
            "Front Squat",
            "Step-Up",
            "Sissy Squat"
        ],
        .abs: [
            "Crunch",
            "Plank",
            "Russian Twist",
            "Hanging Leg Raise",
            "Cable Crunch",
            "Ab Rollout",
            "Bicycle Crunch",
            "Leg Raise",
            "Decline Crunch",
            "Hollow Body Hold",
            "Dead Bug",
            "Dragon Flag",
            "Woodchopper"
        ]
    ]

    static func defaultExercises(for muscleGroup: MuscleGroup) -> [String] {
        defaults[muscleGroup] ?? []
    }

    static func icon(for muscleGroup: MuscleGroup) -> String {
        muscleGroupIcon[muscleGroup] ?? "dumbbell.fill"
    }

    static let cardioTypes: [CardioType] = [
        .running, .walking, .cycling, .swimming, .rowing,
        .elliptical, .jumpRope, .hiit, .stairmaster, .other
    ]
}
