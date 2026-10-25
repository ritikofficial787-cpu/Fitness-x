// ─────────────────────────────────────────────────────────────────────────────
// workout_model.dart
//
// Simple local data structures for the Workout Tracker feature.
// No database, no Firebase, no backend – just plain Dart classes and lists.
// Easy to edit: just find the workout you want and change its values below.
// ─────────────────────────────────────────────────────────────────────────────

/// One step in an exercise (used in "How To Do" section)
class ExerciseStep {
  final String instruction;
  const ExerciseStep(this.instruction);
}

/// A single exercise inside a workout
class Exercise {
  final String name;
  final String duration; // e.g. "05:00" or "12x"
  final String description;
  final List<ExerciseStep> howToDo;
  final int defaultReps; // default repetitions value
  final bool hasVideo; // true when a video asset exists
  final String? videoPath; // asset path to the video file, e.g. 'assets/videos/jumping rope.mp4'
  /// Asset path to the animated GIF shown in the exercise media area.
  /// Set to null if no matching GIF exists for this exercise.
  /// To change a mapping later, just update the gifPath value below.
  final String? gifPath;

  const Exercise({
    required this.name,
    required this.duration,
    required this.description,
    required this.howToDo,
    this.defaultReps = 30,
    this.hasVideo = false,
    this.videoPath, // null = no video
    this.gifPath,  // null = no GIF (keeps existing placeholder)
  });
}

/// A complete workout with metadata and exercise list
class WorkoutModel {
  final String name;
  final String imagePath; // asset path – must exist in assets/images/
  final String duration; // e.g. "20 Minutes"
  final String calories; // e.g. "120 Calories"
  final String difficulty; // Beginner / Intermediate / Advanced
  final String description;
  final List<String> equipment; // items shown in "You'll Need"
  final List<Exercise> exercises;

  const WorkoutModel({
    required this.name,
    required this.imagePath,
    required this.duration,
    required this.calories,
    required this.difficulty,
    required this.description,
    required this.equipment,
    required this.exercises,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// ALL 12 WORKOUTS
// To add / edit a workout: find it below and change the values.
// imagePath must match a file in assets/images/
// ─────────────────────────────────────────────────────────────────────────────

final List<WorkoutModel> allWorkouts = [
  // ── 1. Fullbody Workout ───────────────────────────────────────────────────
  WorkoutModel(
    name: 'Fullbody Workout',
    imagePath: 'assets/images/onboarding1.png',
    duration: '20 Minutes',
    calories: '120 Calories',
    difficulty: 'Beginner',
    description:
        'A complete full-body routine targeting all major muscle groups. '
        'Great for building overall strength and endurance.',
    equipment: ['Dumbbell', 'Skipping Rope', 'Exercise Mat'],
    exercises: [
      Exercise(
        name: 'Warm Up',
        duration: '05:00',
        description: 'Light movements to prepare your body for exercise.',
        howToDo: [
          ExerciseStep('March in place for 30 seconds.'),
          ExerciseStep('Roll your shoulders forwards and backwards.'),
          ExerciseStep('Gently rotate your neck side to side.'),
          ExerciseStep('Swing your arms in big circles.'),
        ],
        defaultReps: 10,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Jumping Jack',
        duration: '12x',
        description:
            'A jumping jack, also known as a star jump, is a physical '
            'jumping exercise performed by jumping to a position with the '
            'legs spread wide and the hands going overhead.',
        howToDo: [
          ExerciseStep('Stand upright with feet together, arms at your sides.'),
          ExerciseStep('Jump while spreading your legs shoulder-width apart.'),
          ExerciseStep('Raise your arms above your head as you jump.'),
          ExerciseStep('Jump back to the starting position and repeat.'),
        ],
        defaultReps: 30,
        hasVideo: true,
        videoPath: 'assets/videos/jumping rope.mp4', // Video file in assets/videos/
        gifPath: 'assets/images/workout1.gif', // General cardio / jumping exercise
      ),
      Exercise(
        name: 'Skipping',
        duration: '18x',
        description:
            'Jump rope skipping is a great cardio exercise that improves '
            'coordination and burns calories quickly.',
        howToDo: [
          ExerciseStep('Hold the rope handles with a relaxed grip.'),
          ExerciseStep('Swing the rope overhead and jump as it passes.'),
          ExerciseStep('Land softly on the balls of your feet.'),
          ExerciseStep('Keep a steady rhythm and maintain good posture.'),
        ],
        defaultReps: 30,
        gifPath: 'assets/images/workout2.gif', // Cardio/skipping movement
      ),
      Exercise(
        name: 'Squats',
        duration: '20x',
        description:
            'Squats target your quads, hamstrings, glutes and core muscles '
            'for powerful lower-body strength.',
        howToDo: [
          ExerciseStep('Stand with feet shoulder-width apart.'),
          ExerciseStep('Lower your body as if sitting into a chair.'),
          ExerciseStep('Keep your back straight and knees over your toes.'),
          ExerciseStep('Push through your heels to return to standing.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/leg.gif', // Squat = leg exercise
      ),
      Exercise(
        name: 'Arm Circles',
        duration: '02:53',
        description:
            'Arm circles warm up your shoulder joints and improve '
            'upper-body flexibility.',
        howToDo: [
          ExerciseStep('Extend both arms straight out to the sides.'),
          ExerciseStep('Make small forward circles for 15 seconds.'),
          ExerciseStep('Make large forward circles for 15 seconds.'),
          ExerciseStep('Repeat in the reverse direction.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/shoulder3.gif', // Shoulder/arm rotation movement
      ),
      Exercise(
        name: 'Rest and Drink',
        duration: '02:00',
        description:
            'Take a short break, hydrate and prepare for the next set.',
        howToDo: [
          ExerciseStep('Drink 200-300 ml of water.'),
          ExerciseStep('Walk slowly to lower your heart rate.'),
          ExerciseStep('Take slow, deep breaths.'),
          ExerciseStep('Shake out your arms and legs.'),
        ],
        defaultReps: 1,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Push Ups',
        duration: '18x',
        description:
            'Push-ups strengthen your chest, shoulders and triceps while '
            'also engaging your core.',
        howToDo: [
          ExerciseStep('Place hands slightly wider than shoulder-width.'),
          ExerciseStep('Keep your body in a straight plank line.'),
          ExerciseStep('Lower chest towards the floor, elbows at 45 degrees.'),
          ExerciseStep('Push back up to the starting position.'),
        ],
        defaultReps: 15,
        gifPath: 'assets/images/chest1.gif', // Push-up = chest exercise
      ),
      Exercise(
        name: 'Lunges',
        duration: '16x',
        description:
            'Lunges develop leg strength, balance and hip flexibility.',
        howToDo: [
          ExerciseStep('Stand tall with feet hip-width apart.'),
          ExerciseStep('Step one foot forward into a long stride.'),
          ExerciseStep('Lower your back knee towards the floor.'),
          ExerciseStep('Push off the front foot and return to start.'),
        ],
        defaultReps: 16,
        gifPath: 'assets/images/leg2.gif', // Lunge = leg exercise
      ),
      Exercise(
        name: 'Cool Down',
        duration: '05:00',
        description:
            'Gentle stretches to reduce muscle soreness and aid recovery.',
        howToDo: [
          ExerciseStep('Hold a standing quad stretch for 20 seconds each side.'),
          ExerciseStep('Perform a seated hamstring stretch for 20 seconds.'),
          ExerciseStep('Do a chest-opener stretch with arms behind your back.'),
          ExerciseStep('Breathe deeply and relax for 30 seconds.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
    ],
  ),

  // ── 2. Lowerbody Workout ─────────────────────────────────────────────────
  WorkoutModel(
    name: 'Lowerbody Workout',
    imagePath: 'assets/images/onboarding4.png',
    duration: '25 Minutes',
    calories: '150 Calories',
    difficulty: 'Intermediate',
    description:
        'Focus on your glutes, quads, hamstrings and calves with this '
        'targeted lower-body routine.',
    equipment: ['Exercise Mat', 'Resistance Band'],
    exercises: [
      Exercise(
        name: 'Warm Up March',
        duration: '03:00',
        description: 'March in place to get blood flowing to your legs.',
        howToDo: [
          ExerciseStep('March in place lifting knees to hip height.'),
          ExerciseStep('Pump your arms in sync with your legs.'),
          ExerciseStep('Gradually increase pace over 3 minutes.'),
          ExerciseStep('Finish with ankle circles each direction.'),
        ],
        defaultReps: 10,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Squats',
        duration: '20x',
        description: 'Deep squats for maximum quad and glute activation.',
        howToDo: [
          ExerciseStep('Feet shoulder-width apart, toes slightly out.'),
          ExerciseStep('Send hips back and down, keeping chest up.'),
          ExerciseStep('Lower until thighs are parallel to floor.'),
          ExerciseStep('Drive through heels to stand.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/leg.gif', // Squat = leg exercise
      ),
      Exercise(
        name: 'Lunges',
        duration: '16x',
        description: 'Alternating forward lunges for balanced leg strength.',
        howToDo: [
          ExerciseStep('Step forward with one leg.'),
          ExerciseStep('Lower until both knees are at 90 degrees.'),
          ExerciseStep('Push back to starting position.'),
          ExerciseStep('Alternate legs each rep.'),
        ],
        defaultReps: 16,
        gifPath: 'assets/images/leg2.gif', // Lunge = leg exercise
      ),
      Exercise(
        name: 'Glute Bridge',
        duration: '15x',
        description: 'Targets glutes and hamstrings while lying on your back.',
        howToDo: [
          ExerciseStep('Lie on your back, knees bent, feet flat.'),
          ExerciseStep('Press through heels and lift hips toward ceiling.'),
          ExerciseStep('Squeeze glutes at the top for 1 second.'),
          ExerciseStep('Lower slowly and repeat.'),
        ],
        defaultReps: 15,
        gifPath: 'assets/images/leg4.gif', // Glute bridge = leg/glute exercise
      ),
      Exercise(
        name: 'Calf Raises',
        duration: '20x',
        description: 'Strengthen and define your calf muscles.',
        howToDo: [
          ExerciseStep('Stand with feet hip-width apart near a wall.'),
          ExerciseStep('Rise onto the balls of your feet.'),
          ExerciseStep('Hold at the top for 1 second.'),
          ExerciseStep('Lower heels slowly to the floor.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/leg3.gif', // Calf raises = leg exercise
      ),
      Exercise(
        name: 'Cool Down Stretch',
        duration: '05:00',
        description: 'Essential lower-body stretches after your workout.',
        howToDo: [
          ExerciseStep('Standing quad stretch - 20 sec each leg.'),
          ExerciseStep('Seated hamstring stretch - 20 sec each leg.'),
          ExerciseStep('Hip flexor lunge stretch - 20 sec each side.'),
          ExerciseStep('Calf stretch against a wall - 15 sec each.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
    ],
  ),

  // ── 3. Ab Workout ────────────────────────────────────────────────────────
  WorkoutModel(
    name: 'Ab Workout',
    imagePath: 'assets/images/onboarding2.png',
    duration: '15 Minutes',
    calories: '80 Calories',
    difficulty: 'Beginner',
    description:
        'Core-focused exercises to build a strong, toned midsection and '
        'improve your overall stability.',
    equipment: ['Exercise Mat'],
    exercises: [
      Exercise(
        name: 'Warm Up',
        duration: '02:00',
        description: 'Light core activation before the main workout.',
        howToDo: [
          ExerciseStep('Cat-cow stretches for 30 seconds.'),
          ExerciseStep('Hip circles in both directions.'),
          ExerciseStep('Lying knee-to-chest pulls, 5 reps each side.'),
          ExerciseStep('Child pose for 20 seconds.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Crunches',
        duration: '20x',
        description: 'Classic crunch targeting the upper abdominals.',
        howToDo: [
          ExerciseStep('Lie on your back, knees bent, hands behind head.'),
          ExerciseStep('Engage core and curl shoulders off the floor.'),
          ExerciseStep('Pause at the top, then lower slowly.'),
          ExerciseStep('Do not pull your neck - lead with your chest.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/workout4.gif', // Core crunch movement
      ),
      Exercise(
        name: 'Plank',
        duration: '30 sec',
        description: 'Isometric exercise that trains the entire core.',
        howToDo: [
          ExerciseStep('Get into a forearm plank position.'),
          ExerciseStep('Keep body in a straight line from head to heels.'),
          ExerciseStep('Engage your abs, glutes and shoulders.'),
          ExerciseStep('Hold for 30 seconds without sagging hips.'),
        ],
        defaultReps: 3,
        gifPath: 'assets/images/workout5.gif', // Plank/core hold
      ),
      Exercise(
        name: 'Leg Raises',
        duration: '15x',
        description: 'Targets the lower abs and hip flexors.',
        howToDo: [
          ExerciseStep('Lie flat, hands under your lower back for support.'),
          ExerciseStep('Keep legs straight and raise them to 90 degrees.'),
          ExerciseStep('Lower slowly without touching the floor.'),
          ExerciseStep('Repeat for all reps.'),
        ],
        defaultReps: 15,
        gifPath: 'assets/images/leg5.gif', // Leg raises = leg/core
      ),
      Exercise(
        name: 'Bicycle Crunches',
        duration: '20x',
        description: 'Works both obliques and rectus abdominis.',
        howToDo: [
          ExerciseStep('Lie on back, hands behind head, legs lifted.'),
          ExerciseStep('Bring right elbow to left knee.'),
          ExerciseStep('Switch: left elbow to right knee.'),
          ExerciseStep('Alternate in a pedalling motion.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/workout3.gif', // Bicycle crunch movement
      ),
      Exercise(
        name: 'Cool Down',
        duration: '03:00',
        description: 'Stretch your core and back after the workout.',
        howToDo: [
          ExerciseStep('Cobra stretch: lie face down and push chest up.'),
          ExerciseStep('Child pose for 30 seconds.'),
          ExerciseStep('Seated spinal twist, 20 sec each side.'),
          ExerciseStep('Deep diaphragmatic breathing for 30 seconds.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
    ],
  ),

  // ── 4. Chest Workout ─────────────────────────────────────────────────────
  WorkoutModel(
    name: 'Chest Workout',
    imagePath: 'assets/images/Card-Goals-2.png',
    duration: '25 Minutes',
    calories: '160 Calories',
    difficulty: 'Intermediate',
    description:
        'Build a stronger, broader chest with this push-focused workout '
        'targeting your pectorals from multiple angles.',
    equipment: ['Dumbbell', 'Exercise Mat', 'Bench (optional)'],
    exercises: [
      Exercise(
        name: 'Warm Up',
        duration: '03:00',
        description: 'Shoulder and chest opening warm-up.',
        howToDo: [
          ExerciseStep('Arm swings across your chest, 20 reps.'),
          ExerciseStep('Arm circles forward and backward.'),
          ExerciseStep('Doorway chest stretch, 20 sec each side.'),
          ExerciseStep('Light push-up negatives x 5.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Push Ups',
        duration: '15x',
        description: 'The cornerstone of chest training with no equipment.',
        howToDo: [
          ExerciseStep('Hands slightly wider than shoulders.'),
          ExerciseStep('Lower chest to just above the floor.'),
          ExerciseStep('Keep elbows at 45 degrees from your torso.'),
          ExerciseStep('Push powerfully back to start.'),
        ],
        defaultReps: 15,
        gifPath: 'assets/images/chest1.gif', // Standard push-up
      ),
      Exercise(
        name: 'Wide Push Ups',
        duration: '12x',
        description: 'Wider hand placement shifts emphasis to outer chest.',
        howToDo: [
          ExerciseStep('Place hands wider than push-up position.'),
          ExerciseStep('Lower slowly with control.'),
          ExerciseStep('Feel the stretch in your outer pecs.'),
          ExerciseStep('Push back up and squeeze at the top.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/chest2.gif', // Wide push-up variant
      ),
      Exercise(
        name: 'Dumbbell Press',
        duration: '12x',
        description: 'Lying dumbbell press for full chest development.',
        howToDo: [
          ExerciseStep('Lie on mat, dumbbells at chest height.'),
          ExerciseStep('Press dumbbells straight up over chest.'),
          ExerciseStep('Lower slowly back to chest level.'),
          ExerciseStep('Keep feet flat and back neutral.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/chest3.gif', // Dumbbell press
      ),
      Exercise(
        name: 'Dumbbell Fly',
        duration: '10x',
        description: 'Isolation exercise for the inner chest.',
        howToDo: [
          ExerciseStep('Lie on mat, dumbbells held above chest.'),
          ExerciseStep('Open arms wide in an arc, lowering dumbbells.'),
          ExerciseStep('Feel the chest stretch at the bottom.'),
          ExerciseStep('Squeeze chest to bring dumbbells back together.'),
        ],
        defaultReps: 10,
        gifPath: 'assets/images/chest4.gif', // Dumbbell fly
      ),
      Exercise(
        name: 'Cool Down',
        duration: '03:00',
        description: 'Chest stretches to prevent soreness.',
        howToDo: [
          ExerciseStep('Doorway chest stretch, 30 sec each side.'),
          ExerciseStep('Cross-body shoulder stretch, 20 sec each.'),
          ExerciseStep('Child pose for 30 seconds.'),
          ExerciseStep('Slow deep breathing to relax.'),
        ],
        defaultReps: 5,
        gifPath: 'assets/images/chest5.gif', // Chest stretch cool-down
      ),
    ],
  ),

  // ── 5. Back Workout ──────────────────────────────────────────────────────
  WorkoutModel(
    name: 'Back Workout',
    imagePath: 'assets/images/Card-Goals-2 (1).png',
    duration: '25 Minutes',
    calories: '155 Calories',
    difficulty: 'Intermediate',
    description:
        'Strengthen your upper and lower back to improve posture and '
        'reduce back pain with these targeted exercises.',
    equipment: ['Dumbbell', 'Exercise Mat', 'Pull-up Bar (optional)'],
    exercises: [
      Exercise(
        name: 'Warm Up',
        duration: '03:00',
        description: 'Activate the back muscles before training.',
        howToDo: [
          ExerciseStep('Cat-cow stretches: 10 slow reps.'),
          ExerciseStep('Thread the needle stretch, 15 sec each side.'),
          ExerciseStep('Band pull-aparts or arm circles.'),
          ExerciseStep('Good-mornings: 10 slow reps with bodyweight.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Superman Hold',
        duration: '12x',
        description: 'Strengthens the lower back extensors.',
        howToDo: [
          ExerciseStep('Lie face down, arms stretched overhead.'),
          ExerciseStep('Lift arms, chest and legs off the floor.'),
          ExerciseStep('Hold for 2 seconds at the top.'),
          ExerciseStep('Lower slowly and repeat.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/back1.gif', // Superman = back extension
      ),
      Exercise(
        name: 'Dumbbell Row',
        duration: '12x',
        description: 'Targets the lats, rhomboids and biceps.',
        howToDo: [
          ExerciseStep('Place one knee and hand on a bench or chair.'),
          ExerciseStep('Hold a dumbbell in the other hand.'),
          ExerciseStep('Pull dumbbell to hip, elbow close to body.'),
          ExerciseStep('Lower with control and repeat.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/back2.gif', // Dumbbell row = back pull
      ),
      Exercise(
        name: 'Reverse Snow Angels',
        duration: '15x',
        description: 'Works the upper back and rear deltoids.',
        howToDo: [
          ExerciseStep('Lie face down, arms at your sides.'),
          ExerciseStep('Lift arms slightly off the floor.'),
          ExerciseStep('Sweep arms from hips to overhead position.'),
          ExerciseStep('Return to start and repeat.'),
        ],
        defaultReps: 15,
        gifPath: 'assets/images/back3.gif', // Reverse snow angels = upper back
      ),
      Exercise(
        name: 'Dead Bug',
        duration: '10x',
        description: 'Builds core stability to protect your back.',
        howToDo: [
          ExerciseStep('Lie on back, arms straight up, legs at 90 degrees.'),
          ExerciseStep('Slowly lower opposite arm and leg toward floor.'),
          ExerciseStep('Keep your lower back pressed into the floor.'),
          ExerciseStep('Return and alternate sides.'),
        ],
        defaultReps: 10,
        gifPath: 'assets/images/back4.gif', // Dead bug = back stability
      ),
      Exercise(
        name: 'Cool Down',
        duration: '03:00',
        description: 'Gentle back stretches to release tension.',
        howToDo: [
          ExerciseStep('Child pose for 30 seconds.'),
          ExerciseStep('Seated spinal twist, 20 sec each side.'),
          ExerciseStep('Cat-cow, 8 slow reps.'),
          ExerciseStep('Lying knee hug, 20 seconds.'),
        ],
        defaultReps: 5,
        gifPath: 'assets/images/back5.gif', // Back cool-down stretch
      ),
    ],
  ),

  // ── 6. Arm Workout ───────────────────────────────────────────────────────
  WorkoutModel(
    name: 'Arm Workout',
    imagePath: 'assets/images/Card-Goals-2 (2).png',
    duration: '20 Minutes',
    calories: '100 Calories',
    difficulty: 'Beginner',
    description:
        'Sculpt and tone your biceps, triceps and forearms with this '
        'dumbbell-focused arm routine.',
    equipment: ['Dumbbell'],
    exercises: [
      Exercise(
        name: 'Warm Up',
        duration: '02:00',
        description: 'Loosen your elbow and wrist joints.',
        howToDo: [
          ExerciseStep('Wrist circles, 10 reps each direction.'),
          ExerciseStep('Elbow circles, 10 reps each direction.'),
          ExerciseStep('Arm swings across the chest.'),
          ExerciseStep('Light dumbbell curls x 10 at low weight.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Bicep Curls',
        duration: '15x',
        description: 'Classic exercise to build bicep size and strength.',
        howToDo: [
          ExerciseStep('Stand holding dumbbells at your sides.'),
          ExerciseStep('Curl both dumbbells toward your shoulders.'),
          ExerciseStep('Squeeze biceps at the top.'),
          ExerciseStep('Lower slowly to the start position.'),
        ],
        defaultReps: 15,
        gifPath: 'assets/images/biceps1.gif', // Bicep curl
      ),
      Exercise(
        name: 'Tricep Dips',
        duration: '12x',
        description: 'Bodyweight exercise targeting the triceps.',
        howToDo: [
          ExerciseStep('Sit on the edge of a chair, hands beside hips.'),
          ExerciseStep('Slide your hips off and bend elbows to 90 degrees.'),
          ExerciseStep('Push back up by straightening your arms.'),
          ExerciseStep('Keep your back close to the chair.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/triceps1.gif', // Tricep dip
      ),
      Exercise(
        name: 'Hammer Curls',
        duration: '12x',
        description: 'Targets the brachialis and forearm for thicker arms.',
        howToDo: [
          ExerciseStep('Hold dumbbells with a neutral (hammer) grip.'),
          ExerciseStep('Curl one dumbbell at a time toward shoulder.'),
          ExerciseStep('Keep your upper arm stationary.'),
          ExerciseStep('Lower slowly and alternate arms.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/biceps2.gif', // Hammer curl = bicep variant
      ),
      Exercise(
        name: 'Overhead Tricep Extension',
        duration: '12x',
        description: 'Extends the long head of the tricep.',
        howToDo: [
          ExerciseStep('Hold one dumbbell overhead with both hands.'),
          ExerciseStep('Lower dumbbell behind your head.'),
          ExerciseStep('Press back up by extending your elbows.'),
          ExerciseStep('Keep elbows close to your ears throughout.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/triceps2.gif', // Overhead tricep extension
      ),
      Exercise(
        name: 'Cool Down',
        duration: '02:00',
        description: 'Stretch forearms and upper arms after training.',
        howToDo: [
          ExerciseStep('Tricep stretch: arm overhead, hand down back.'),
          ExerciseStep('Bicep stretch: arm extended, palm up, gently press down.'),
          ExerciseStep('Forearm stretch: arm extended, flex and extend wrist.'),
          ExerciseStep('Shake out arms gently for 20 seconds.'),
        ],
        defaultReps: 5,
        gifPath: 'assets/images/biceps3.gif', // Arm cool-down stretch
      ),
    ],
  ),

  // ── 7. Shoulder Workout ──────────────────────────────────────────────────
  WorkoutModel(
    name: 'Shoulder Workout',
    imagePath: 'assets/images/onboarding1.png',
    duration: '20 Minutes',
    calories: '110 Calories',
    difficulty: 'Intermediate',
    description:
        'Build strong, defined shoulders with pressing and lateral '
        'movements targeting all three deltoid heads.',
    equipment: ['Dumbbell', 'Exercise Mat'],
    exercises: [
      Exercise(
        name: 'Warm Up',
        duration: '03:00',
        description: 'Shoulder mobility warm-up to prevent injury.',
        howToDo: [
          ExerciseStep('Arm circles forward 10 reps, backward 10 reps.'),
          ExerciseStep('Cross-body arm swings, 20 reps.'),
          ExerciseStep('Doorway pec stretch, 20 sec each side.'),
          ExerciseStep('Light band pull-aparts or towel stretch.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Overhead Press',
        duration: '12x',
        description: 'Prime shoulder exercise for all three deltoid heads.',
        howToDo: [
          ExerciseStep('Hold dumbbells at shoulder height, palms forward.'),
          ExerciseStep('Press directly overhead until arms are straight.'),
          ExerciseStep('Lower slowly back to shoulder height.'),
          ExerciseStep('Keep core tight and avoid arching your back.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/shoulder1.gif', // Overhead press = shoulder
      ),
      Exercise(
        name: 'Lateral Raises',
        duration: '15x',
        description: 'Isolates the middle deltoid for shoulder width.',
        howToDo: [
          ExerciseStep('Stand with dumbbells at your sides.'),
          ExerciseStep('Raise arms out to the sides to shoulder height.'),
          ExerciseStep('Lead with your elbows, thumbs slightly down.'),
          ExerciseStep('Lower slowly with control.'),
        ],
        defaultReps: 15,
        gifPath: 'assets/images/shoulder2.gif', // Lateral raise = shoulder
      ),
      Exercise(
        name: 'Front Raises',
        duration: '12x',
        description: 'Targets the front (anterior) deltoid.',
        howToDo: [
          ExerciseStep('Hold dumbbells in front of thighs, palms facing back.'),
          ExerciseStep('Raise one arm forward to shoulder height.'),
          ExerciseStep('Lower and alternate with the other arm.'),
          ExerciseStep('Keep a slight bend in the elbow.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/shoulder3.gif', // Front raise = shoulder
      ),
      Exercise(
        name: 'Reverse Fly',
        duration: '12x',
        description: 'Works rear deltoids and upper back for balanced shoulders.',
        howToDo: [
          ExerciseStep('Hinge forward at the hips, back flat.'),
          ExerciseStep('Hold dumbbells, arms hanging down.'),
          ExerciseStep('Raise arms out to sides, squeezing shoulder blades.'),
          ExerciseStep('Lower slowly and repeat.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/shoulder4.gif', // Reverse fly = rear delt
      ),
      Exercise(
        name: 'Cool Down',
        duration: '03:00',
        description: 'Release shoulder tension after the workout.',
        howToDo: [
          ExerciseStep('Cross-body shoulder stretch, 20 sec each arm.'),
          ExerciseStep('Overhead shoulder stretch, 20 sec each.'),
          ExerciseStep('Neck side stretch, 15 sec each side.'),
          ExerciseStep('Chest opener: clasp hands behind back and breathe.'),
        ],
        defaultReps: 5,
        gifPath: 'assets/images/shoulder5.gif', // Shoulder cool-down stretch
      ),
    ],
  ),

  // ── 8. Leg Workout ───────────────────────────────────────────────────────
  WorkoutModel(
    name: 'Leg Workout',
    imagePath: 'assets/images/onboarding4.png',
    duration: '30 Minutes',
    calories: '200 Calories',
    difficulty: 'Intermediate',
    description:
        'Comprehensive leg training session targeting quads, hamstrings, '
        'glutes and calves for powerful, athletic legs.',
    equipment: ['Dumbbell', 'Exercise Mat', 'Resistance Band'],
    exercises: [
      Exercise(
        name: 'Warm Up',
        duration: '03:00',
        description: 'Dynamic lower-body warm-up before leg day.',
        howToDo: [
          ExerciseStep('Leg swings forward-backward, 10 reps each leg.'),
          ExerciseStep('Lateral leg swings, 10 reps each leg.'),
          ExerciseStep('Hip circles, 10 reps each direction.'),
          ExerciseStep('Bodyweight squats x 10, slow tempo.'),
        ],
        defaultReps: 10,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Squats',
        duration: '20x',
        description: 'King of all leg exercises.',
        howToDo: [
          ExerciseStep('Feet shoulder-width, toes slightly out.'),
          ExerciseStep('Push hips back and lower until thighs parallel.'),
          ExerciseStep('Drive through the heels to stand.'),
          ExerciseStep('Keep chest tall throughout.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/leg.gif', // Squat = leg exercise
      ),
      Exercise(
        name: 'Romanian Deadlift',
        duration: '12x',
        description: 'Hamstring and glute hinge movement.',
        howToDo: [
          ExerciseStep('Hold dumbbells in front of thighs.'),
          ExerciseStep('Hinge at the hips, pushing them back.'),
          ExerciseStep('Lower weights along your legs, keeping back flat.'),
          ExerciseStep('Drive hips forward to return to standing.'),
        ],
        defaultReps: 12,
        gifPath: 'assets/images/leg3.gif', // Romanian deadlift = leg/hamstring
      ),
      Exercise(
        name: 'Walking Lunges',
        duration: '20x',
        description: 'Alternating lunges that build unilateral leg strength.',
        howToDo: [
          ExerciseStep('Step forward into a lunge position.'),
          ExerciseStep('Lower back knee toward the floor.'),
          ExerciseStep('Push forward and bring back foot up.'),
          ExerciseStep('Repeat on the other leg, walking forward.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/leg2.gif', // Walking lunge = leg exercise
      ),
      Exercise(
        name: 'Glute Bridge',
        duration: '15x',
        description: 'Activates and strengthens the glutes.',
        howToDo: [
          ExerciseStep('Lie on back, knees bent, feet flat on floor.'),
          ExerciseStep('Drive hips up by squeezing glutes.'),
          ExerciseStep('Hold at the top for 2 seconds.'),
          ExerciseStep('Lower slowly and repeat.'),
        ],
        defaultReps: 15,
        gifPath: 'assets/images/leg4.gif', // Glute bridge = leg/glute
      ),
      Exercise(
        name: 'Calf Raises',
        duration: '25x',
        description: 'Isolates the gastrocnemius and soleus.',
        howToDo: [
          ExerciseStep('Stand on the edge of a step for full range.'),
          ExerciseStep('Rise up on tiptoes, squeezing calves.'),
          ExerciseStep('Lower heels below the step level.'),
          ExerciseStep('Repeat for all reps.'),
        ],
        defaultReps: 25,
        gifPath: 'assets/images/leg3.gif', // Calf raises = leg exercise
      ),
      Exercise(
        name: 'Cool Down',
        duration: '05:00',
        description: 'Essential leg stretches post-workout.',
        howToDo: [
          ExerciseStep('Standing quad stretch, 20 sec each leg.'),
          ExerciseStep('Seated toe touch hamstring stretch, 30 sec.'),
          ExerciseStep('Pigeon pose for glutes, 20 sec each side.'),
          ExerciseStep('Calf stretch on wall, 20 sec each leg.'),
        ],
        defaultReps: 5,
        gifPath: 'assets/images/leg5.gif', // Leg cool-down stretch
      ),
    ],
  ),

  // ── 9. Cardio Workout ────────────────────────────────────────────────────
  WorkoutModel(
    name: 'Cardio Workout',
    imagePath: 'assets/images/onboarding1.png',
    duration: '30 Minutes',
    calories: '250 Calories',
    difficulty: 'Beginner',
    description:
        'Get your heart pumping with this cardio session designed to '
        'improve endurance and burn calories efficiently.',
    equipment: ['Skipping Rope', 'Exercise Mat'],
    exercises: [
      Exercise(
        name: 'Warm Up March',
        duration: '03:00',
        description: 'Easy marching to gradually raise heart rate.',
        howToDo: [
          ExerciseStep('March in place with high knees.'),
          ExerciseStep('Add arm swings for full body warm-up.'),
          ExerciseStep('Increase pace slightly after 90 seconds.'),
          ExerciseStep('Finish with shoulder and hip circles.'),
        ],
        defaultReps: 10,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Jumping Jack',
        duration: '30x',
        description: 'Full-body cardio that raises heart rate fast.',
        howToDo: [
          ExerciseStep('Stand with feet together, arms at sides.'),
          ExerciseStep('Jump and spread feet while raising arms overhead.'),
          ExerciseStep('Jump back to starting position.'),
          ExerciseStep('Keep a steady, rhythmic pace.'),
        ],
        defaultReps: 30,
        hasVideo: true,
        videoPath: 'assets/videos/jumping rope.mp4', // Video file in assets/videos/
        gifPath: 'assets/images/workout1.gif', // Jumping jack = cardio
      ),
      Exercise(
        name: 'High Knees',
        duration: '30x',
        description: 'Running in place to elevate heart rate.',
        howToDo: [
          ExerciseStep('Run in place, lifting knees as high as possible.'),
          ExerciseStep('Pump your arms with each step.'),
          ExerciseStep('Stay on the balls of your feet.'),
          ExerciseStep('Maintain an upright posture.'),
        ],
        defaultReps: 30,
        gifPath: 'assets/images/workout2.gif', // High knees = cardio run
      ),
      Exercise(
        name: 'Skipping',
        duration: '02:00',
        description: 'Jump rope for excellent cardio conditioning.',
        howToDo: [
          ExerciseStep('Hold handles lightly with relaxed wrists.'),
          ExerciseStep('Keep jumps small, just clearing the rope.'),
          ExerciseStep('Land softly on the balls of your feet.'),
          ExerciseStep('Maintain steady rhythm throughout.'),
        ],
        defaultReps: 30,
        gifPath: 'assets/images/workout2.gif', // Skipping = cardio
      ),
      Exercise(
        name: 'Butt Kicks',
        duration: '30x',
        description: 'Dynamic exercise that works the hamstrings.',
        howToDo: [
          ExerciseStep('Run in place, kicking heels toward your glutes.'),
          ExerciseStep('Keep your thighs vertical and core engaged.'),
          ExerciseStep('Pump your arms in coordination.'),
          ExerciseStep('Keep a fast, rhythmic pace.'),
        ],
        defaultReps: 30,
        gifPath: 'assets/images/workout1.gif', // Butt kicks = cardio run
      ),
      Exercise(
        name: 'Rest and Drink',
        duration: '02:00',
        description: 'Recovery break before the final push.',
        howToDo: [
          ExerciseStep('Drink 200-300 ml of water.'),
          ExerciseStep('Walk slowly to keep blood circulating.'),
          ExerciseStep('Take slow, deep breaths.'),
          ExerciseStep('Shake out legs and arms.'),
        ],
        defaultReps: 1,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Cool Down Walk',
        duration: '05:00',
        description: 'Gradually lower your heart rate with easy walking.',
        howToDo: [
          ExerciseStep('Walk slowly in place for 2 minutes.'),
          ExerciseStep('Standing forward fold, hold 30 seconds.'),
          ExerciseStep('Hip flexor stretch, 20 sec each side.'),
          ExerciseStep('Deep breathing for 30 seconds.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
    ],
  ),

  // ── 10. HIIT Workout ─────────────────────────────────────────────────────
  WorkoutModel(
    name: 'HIIT Workout',
    imagePath: 'assets/images/onboarding4.png',
    duration: '20 Minutes',
    calories: '220 Calories',
    difficulty: 'Advanced',
    description:
        'High-Intensity Interval Training for maximum calorie burn and '
        'cardiovascular fitness in the shortest time possible.',
    equipment: ['Exercise Mat', 'Timer'],
    exercises: [
      Exercise(
        name: 'Warm Up',
        duration: '03:00',
        description: 'Prepare body for high intensity effort.',
        howToDo: [
          ExerciseStep('Jog in place for 60 seconds.'),
          ExerciseStep('Arm circles and leg swings.'),
          ExerciseStep('Bodyweight squats x 10.'),
          ExerciseStep('Hip circles each direction x 10.'),
        ],
        defaultReps: 10,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Burpees',
        duration: '10x',
        description: 'Ultimate full-body HIIT movement.',
        howToDo: [
          ExerciseStep('Stand, then drop hands to floor.'),
          ExerciseStep('Jump feet back into plank position.'),
          ExerciseStep('Do one push-up (optional).'),
          ExerciseStep('Jump feet forward and explode upward with arms overhead.'),
        ],
        defaultReps: 10,
        gifPath: 'assets/images/workout1.gif', // Burpee = full-body HIIT
      ),
      Exercise(
        name: 'Mountain Climbers',
        duration: '20x',
        description: 'Core-intensive cardio exercise.',
        howToDo: [
          ExerciseStep('Start in push-up plank position.'),
          ExerciseStep('Drive one knee toward your chest.'),
          ExerciseStep('Switch legs quickly in a running motion.'),
          ExerciseStep('Keep hips level, move as fast as possible.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/workout4.gif', // Mountain climbers = core cardio
      ),
      Exercise(
        name: 'Jump Squats',
        duration: '15x',
        description: 'Explosive lower-body power movement.',
        howToDo: [
          ExerciseStep('Lower into squat position.'),
          ExerciseStep('Explode upward, jumping as high as possible.'),
          ExerciseStep('Land softly with bent knees.'),
          ExerciseStep('Absorb impact and immediately squat again.'),
        ],
        defaultReps: 15,
        gifPath: 'assets/images/leg.gif', // Jump squats = explosive leg
      ),
      Exercise(
        name: 'Rest',
        duration: '01:00',
        description: 'One minute recovery between rounds.',
        howToDo: [
          ExerciseStep('Walk slowly and catch your breath.'),
          ExerciseStep('Drink water if needed.'),
          ExerciseStep('Shake out your arms and legs.'),
          ExerciseStep('Prepare mentally for the next round.'),
        ],
        defaultReps: 1,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Cool Down',
        duration: '03:00',
        description: 'Essential recovery after intense HIIT.',
        howToDo: [
          ExerciseStep('Walk in place for 2 minutes.'),
          ExerciseStep('Standing forward fold, 30 seconds.'),
          ExerciseStep('Hip flexor stretch, 20 sec each side.'),
          ExerciseStep('Lying spinal twist, 15 sec each side.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
    ],
  ),

  // ── 11. Stretching Workout ───────────────────────────────────────────────
  WorkoutModel(
    name: 'Stretching Workout',
    imagePath: 'assets/images/onboarding2.png',
    duration: '20 Minutes',
    calories: '50 Calories',
    difficulty: 'Beginner',
    description:
        'Improve your flexibility, reduce muscle tension and increase '
        'range of motion with this full-body stretching routine.',
    equipment: ['Exercise Mat', 'Yoga Block (optional)'],
    exercises: [
      Exercise(
        name: 'Neck Stretches',
        duration: '02:00',
        description: 'Release neck and upper trap tension.',
        howToDo: [
          ExerciseStep('Slowly tilt head to the right, hold 15 seconds.'),
          ExerciseStep('Tilt to the left, hold 15 seconds.'),
          ExerciseStep('Look right over your shoulder, hold 10 seconds.'),
          ExerciseStep('Look left over your shoulder, hold 10 seconds.'),
        ],
        defaultReps: 5,
      ),
      Exercise(
        name: 'Chest Opener',
        duration: '01:30',
        description: 'Opens the chest and front shoulder muscles.',
        howToDo: [
          ExerciseStep('Clasp hands behind your lower back.'),
          ExerciseStep('Squeeze shoulder blades together.'),
          ExerciseStep('Lift hands slightly and open chest.'),
          ExerciseStep('Hold 20 seconds, breathe deeply.'),
        ],
        defaultReps: 5,
      ),
      Exercise(
        name: 'Hip Flexor Stretch',
        duration: '02:00',
        description: 'Release tight hip flexors from sitting.',
        howToDo: [
          ExerciseStep('Kneel on one knee, other foot forward.'),
          ExerciseStep('Shift weight forward until you feel a hip stretch.'),
          ExerciseStep('Keep torso upright and core engaged.'),
          ExerciseStep('Hold 20 sec, then switch sides.'),
        ],
        defaultReps: 5,
      ),
      Exercise(
        name: 'Hamstring Stretch',
        duration: '02:00',
        description: 'Lengthen the hamstrings to reduce back tension.',
        howToDo: [
          ExerciseStep('Sit on the floor with legs extended.'),
          ExerciseStep('Hinge forward at the hips toward your toes.'),
          ExerciseStep('Keep your back as flat as possible.'),
          ExerciseStep('Hold 20-30 seconds.'),
        ],
        defaultReps: 5,
      ),
      Exercise(
        name: 'Pigeon Pose',
        duration: '02:00',
        description: 'Deep glute and hip-opening stretch.',
        howToDo: [
          ExerciseStep('From a plank, bring one knee forward behind your wrist.'),
          ExerciseStep('Extend the other leg straight behind you.'),
          ExerciseStep('Lower hips toward the mat and fold forward.'),
          ExerciseStep('Hold 30 seconds each side.'),
        ],
        defaultReps: 5,
      ),
      Exercise(
        name: 'Spinal Twist',
        duration: '02:00',
        description: 'Releases the lower back and improves spinal mobility.',
        howToDo: [
          ExerciseStep('Lie on your back, arms out to the sides.'),
          ExerciseStep('Bring knees to chest, then drop to one side.'),
          ExerciseStep('Look in the opposite direction of your knees.'),
          ExerciseStep('Hold 20 sec, then switch sides.'),
        ],
        defaultReps: 5,
      ),
      Exercise(
        name: 'Child Pose',
        duration: '02:00',
        description: 'Restorative final stretch for back and hips.',
        howToDo: [
          ExerciseStep('Kneel and sit back on your heels.'),
          ExerciseStep('Extend arms forward on the mat.'),
          ExerciseStep('Rest your forehead on the floor.'),
          ExerciseStep('Breathe deeply and hold for 60 seconds.'),
        ],
        defaultReps: 5,
      ),
    ],
  ),

  // ── 12. Core Workout ─────────────────────────────────────────────────────
  WorkoutModel(
    name: 'Core Workout',
    imagePath: 'assets/images/onboarding2.png',
    duration: '20 Minutes',
    calories: '90 Calories',
    difficulty: 'Intermediate',
    description:
        'Develop a rock-solid core with a mix of stabilisation, flexion '
        'and rotation exercises for complete core strength.',
    equipment: ['Exercise Mat'],
    exercises: [
      Exercise(
        name: 'Warm Up',
        duration: '02:00',
        description: 'Activate the core before training.',
        howToDo: [
          ExerciseStep('Cat-cow, 10 slow reps.'),
          ExerciseStep('Dead bug, 5 reps each side.'),
          ExerciseStep('Bird dog, 5 reps each side.'),
          ExerciseStep('Hip circles in both directions.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
      Exercise(
        name: 'Plank',
        duration: '45 sec',
        description: 'Foundational core stability exercise.',
        howToDo: [
          ExerciseStep('Forearm plank, body in straight line.'),
          ExerciseStep('Engage abs, glutes and quads.'),
          ExerciseStep('Breathe steadily, do not hold your breath.'),
          ExerciseStep('Hold for 45 seconds.'),
        ],
        defaultReps: 3,
        gifPath: 'assets/images/workout5.gif', // Plank hold
      ),
      Exercise(
        name: 'Dead Bug',
        duration: '10x',
        description: 'Anti-extension core exercise.',
        howToDo: [
          ExerciseStep('Lie on back, arms up, legs at 90 degrees.'),
          ExerciseStep('Lower opposite arm and leg simultaneously.'),
          ExerciseStep('Keep lower back pressed to the floor.'),
          ExerciseStep('Return and alternate sides.'),
        ],
        defaultReps: 10,
        gifPath: 'assets/images/back4.gif', // Dead bug = core/back stability
      ),
      Exercise(
        name: 'Russian Twists',
        duration: '20x',
        description: 'Rotational exercise for the obliques.',
        howToDo: [
          ExerciseStep('Sit with knees bent, feet slightly elevated.'),
          ExerciseStep('Lean back to 45 degrees, keeping back straight.'),
          ExerciseStep('Rotate torso left, then right.'),
          ExerciseStep('Add a dumbbell for extra challenge.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/workout3.gif', // Rotational core movement
      ),
      Exercise(
        name: 'Hollow Body Hold',
        duration: '30 sec',
        description: 'Advanced core compression exercise.',
        howToDo: [
          ExerciseStep('Lie on back, arms overhead.'),
          ExerciseStep('Lift shoulders and legs off the floor.'),
          ExerciseStep('Press lower back into the floor.'),
          ExerciseStep('Hold like a banana shape for 30 seconds.'),
        ],
        defaultReps: 3,
        gifPath: 'assets/images/workout4.gif', // Core hold/compression
      ),
      Exercise(
        name: 'Flutter Kicks',
        duration: '20x',
        description: 'Lower ab exercise with alternating leg movements.',
        howToDo: [
          ExerciseStep('Lie on back, hands under your hips.'),
          ExerciseStep('Raise both legs 6 inches off the floor.'),
          ExerciseStep('Alternate kicking legs up and down.'),
          ExerciseStep('Keep core tight and lower back pressed down.'),
        ],
        defaultReps: 20,
        gifPath: 'assets/images/leg5.gif', // Flutter kicks = lower abs/leg
      ),
      Exercise(
        name: 'Cool Down',
        duration: '03:00',
        description: 'Core and back stretches to finish.',
        howToDo: [
          ExerciseStep('Cobra stretch, 30 seconds.'),
          ExerciseStep('Child pose, 30 seconds.'),
          ExerciseStep('Lying spinal twist, 15 sec each side.'),
          ExerciseStep('Deep breathing for 30 seconds.'),
        ],
        defaultReps: 5,
        // No matching GIF – keep placeholder
      ),
    ],
  ),
];
