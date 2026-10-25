// ─────────────────────────────────────────────────────────────────────────────
// workout_details_screen.dart
//
// Shows full details for a selected workout:
//  - Image, name, duration, calories
//  - Favourite heart button
//  - Schedule Workout option
//  - Difficulty badge
//  - "You'll Need" equipment list
//  - Exercise list (Set 1 / Set 2 layout)
//  - "Start Workout" button at the bottom
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import 'exercise_details_screen.dart';
import 'workout_progress_screen.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  // The workout selected by the user – passed from WorkoutTrackerScreen
  final WorkoutModel workout;

  const WorkoutDetailsScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  bool _isFavourite = false;

  // App colour palette
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  @override
  Widget build(BuildContext context) {
    final workout = widget.workout;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header image with overlaid back / more buttons ───────────
            _buildImageHeader(workout),

            // ── Scrollable body ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWorkoutTitle(workout),
                    const SizedBox(height: 16),
                    _buildScheduleRow(),
                    const SizedBox(height: 16),
                    _buildDifficultyRow(workout),
                    const SizedBox(height: 20),
                    _buildYoullNeed(workout),
                    const SizedBox(height: 20),
                    _buildExerciseList(workout),
                    const SizedBox(height: 30),
                    _buildStartButton(workout),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Image header with gradient overlay ─────────────────────────────────
  Widget _buildImageHeader(WorkoutModel workout) {
    return SizedBox(
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Workout image
          Image.asset(
            workout.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: _cardBg,
              child: const Center(
                child: Icon(Icons.fitness_center,
                    color: _primary, size: 60),
              ),
            ),
          ),
          // Dark gradient overlay at top for button readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 14, color: _textDark),
              ),
            ),
          ),
          // More button
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.more_horiz, size: 20, color: _textDark),
            ),
          ),
        ],
      ),
    );
  }

  // ── Workout title + stats + favourite ──────────────────────────────────
  Widget _buildWorkoutTitle(WorkoutModel workout) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workout.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${workout.exercises.length} Exercises | '
                '${workout.duration} | ${workout.calories} Burn',
                style: const TextStyle(fontSize: 12, color: _textGrey),
              ),
            ],
          ),
        ),
        // Favourite / heart button
        GestureDetector(
          onTap: () => setState(() => _isFavourite = !_isFavourite),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _bgLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isFavourite ? Icons.favorite : Icons.favorite_border,
              color: _isFavourite ? Colors.red : _textGrey,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  // ── Schedule Workout row ────────────────────────────────────────────────
  Widget _buildScheduleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _bgLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today_outlined, size: 18, color: _primary),
              SizedBox(width: 8),
              Text(
                'Schedule Workout',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: _textGrey),
        ],
      ),
    );
  }

  // ── Difficulty badge ────────────────────────────────────────────────────
  Widget _buildDifficultyRow(WorkoutModel workout) {
    Color diffColor;
    switch (workout.difficulty) {
      case 'Advanced':
        diffColor = const Color(0xFFFF7676);
        break;
      case 'Intermediate':
        diffColor = const Color(0xFFFFA07A);
        break;
      default:
        diffColor = _primary;
    }

    return Row(
      children: [
        const Icon(Icons.bar_chart, size: 18, color: _primary),
        const SizedBox(width: 6),
        const Text(
          'Difficulty',
          style: TextStyle(fontSize: 13, color: _textGrey),
        ),
        const SizedBox(width: 10),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: diffColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            workout.difficulty,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: diffColor,
            ),
          ),
        ),
      ],
    );
  }

  // ── You'll Need (equipment) ─────────────────────────────────────────────
  Widget _buildYoullNeed(WorkoutModel workout) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "You'll Need",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            Text(
              '${workout.equipment.length} Items',
              style: const TextStyle(fontSize: 12, color: _textGrey),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: workout.equipment.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return _buildEquipmentCard(workout.equipment[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentCard(String name) {
    // Map equipment names to icons
    final icons = {
      'Dumbbell': Icons.fitness_center,
      'Skipping Rope': Icons.cable,
      'Exercise Mat': Icons.crop_square,
      'Resistance Band': Icons.radio_button_unchecked,
      'Pull-up Bar (optional)': Icons.arrow_upward,
      'Bench (optional)': Icons.airline_seat_recline_normal,
      'Timer': Icons.timer,
      'Yoga Block (optional)': Icons.square,
    };

    return Container(
      width: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icons[name] ?? Icons.sports_gymnastics,
            color: _primary,
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(fontSize: 9, color: _textGrey),
          ),
        ],
      ),
    );
  }

  // ── Exercise List ───────────────────────────────────────────────────────
  Widget _buildExerciseList(WorkoutModel workout) {
    final exercises = workout.exercises;
    // Split into two sets if more than 5 exercises
    final set1 = exercises.length > 5
        ? exercises.sublist(0, exercises.length ~/ 2)
        : exercises;
    final set2 = exercises.length > 5
        ? exercises.sublist(exercises.length ~/ 2)
        : <Exercise>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Exercises',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            Text(
              '${exercises.length} Sets',
              style: const TextStyle(fontSize: 12, color: _textGrey),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Set 1',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _textGrey,
          ),
        ),
        const SizedBox(height: 10),
        ...set1.map((e) => _buildExerciseRow(e, workout)),
        if (set2.isNotEmpty) ...[
          const SizedBox(height: 10),
          const Text(
            'Set 2',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textGrey,
            ),
          ),
          const SizedBox(height: 10),
          ...set2.map((e) => _buildExerciseRow(e, workout)),
        ],
      ],
    );
  }

  Widget _buildExerciseRow(Exercise exercise, WorkoutModel workout) {
    return GestureDetector(
      onTap: () {
        // Open Exercise Details screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseDetailsScreen(
              exercise: exercise,
              workoutName: workout.name,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Exercise icon placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.directions_run,
                  color: _primary, size: 24),
            ),
            const SizedBox(width: 14),
            // Name and duration
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    exercise.duration,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _textGrey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.info_outline, color: _textGrey, size: 20),
          ],
        ),
      ),
    );
  }

  // ── Start Workout button ────────────────────────────────────────────────
  Widget _buildStartButton(WorkoutModel workout) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_primary, _primaryLight],
          ),
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: _primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkoutProgressScreen(workout: workout),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          child: const Text(
            'Start Workout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
