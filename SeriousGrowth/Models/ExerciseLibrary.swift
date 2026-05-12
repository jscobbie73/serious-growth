import Foundation

enum ExerciseLibrary {

    static let muscleGroups: [String] = [
        "Back", "Chest", "Bicep", "Calf", "Delts", "Tricep", "Thighs", "Abs"
    ]

    static let muscleGroupIcon: [String: String] = [
        "Back":   "figure.strengthtraining.traditional",
        "Chest":  "heart.fill",
        "Bicep":  "figure.arms.open",
        "Calf":   "figure.walk",
        "Delts":  "figure.boxing",
        "Tricep": "figure.cooldown",
        "Thighs": "figure.run",
        "Abs":    "figure.core.training"
    ]

    static let defaults: [String: [String]] = [
        "Back": [
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
        "Chest": [
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
        "Bicep": [
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
        "Calf": [
            "Standing Calf Raise",
            "Seated Calf Raise",
            "Leg Press Calf Raise",
            "Donkey Calf Raise",
            "Single-Leg Calf Raise",
            "Smith Machine Calf Raise",
            "Calf Press (Machine)"
        ],
        "Delts": [
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
        "Tricep": [
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
        "Thighs": [
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
        "Abs": [
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

    static func defaultExercises(for muscleGroup: String) -> [String] {
        defaults[muscleGroup] ?? []
    }

    static func icon(for muscleGroup: String) -> String {
        muscleGroupIcon[muscleGroup] ?? "dumbbell.fill"
    }

    // Cardio type options
    static let cardioTypes: [String] = [
        "Running", "Walking", "Cycling", "Swimming", "Rowing",
        "Elliptical", "Jump Rope", "HIIT", "Stairmaster", "Other"
    ]
}
