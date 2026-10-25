// ─────────────────────────────────────────────────────────────────────────────
// workout_progress_screen.dart
//
// Walks the user through each exercise one-by-one.
// Shows:
//  - Exercise name & duration
//  - Progress indicator (Exercise X of Y)
//  - Progress bar
//  - Next / Previous buttons
//  - Opens Workout Completed screen after the last exercise
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import 'exercise_details_screen.dart';
import 'workout_completed_screen.dart';

class WorkoutProgressScreen extends StatefulWidget {
  final WorkoutModel workout;

  const WorkoutProgressScreen({super.key, required this.workout});

  @override
  State<WorkoutProgressScreen> createState() => _WorkoutProgressScreenState();
}

class _WorkoutProgressScreenState extends State<WorkoutProgressScreen> {
  // Index of the currently displayed exercise (0-based)
  int _currentIndex = 0;

  // App colour palette
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  List<Exercise> get _exercises => widget.workout.exercises;
  int get _total => _exercises.length;
  Exercise get _current => _exercises[_currentIndex];

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex + 1) / _total;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────
            _buildHeader(),

            // ── Progress counter ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Exercise ${_currentIndex + 1} of $_total',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                        ),
                      ),
                      Text(
                        '${(_currentIndex + 1)}/$_total',
                        style: const TextStyle(
                            fontSize: 13, color: _textGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor:
                          _primary.withValues(alpha: 0.15),
                      valueColor: const AlwaysStoppedAnimation<Color>(_primary),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable exercise content ───────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildExerciseCard(),
                    const SizedBox(height: 24),
                    _buildHowToDoSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            // ── Bottom navigation buttons ─────────────────────────────────
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _bgLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 14, color: _textDark),
            ),
          ),
          Text(
            widget.workout.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(width: 36), // spacer to keep title centred
        ],
      ),
    );
  }

  // ── Current exercise card ───────────────────────────────────────────────
  Widget _buildExerciseCard() {
    return GestureDetector(
      onTap: () {
        // Tap to see full exercise details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ExerciseDetailsScreen(
              exercise: _current,
              workoutName: widget.workout.name,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB8C8FF), _primary],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: _primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.directions_run,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _current.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _current.duration,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _current.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tap to view full details',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Abbreviated How-To-Do for current exercise ──────────────────────────
  Widget _buildHowToDoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Steps',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 12),
        ..._current.howToDo.asMap().entries.map((entry) {
          final idx = entry.key;
          final step = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${idx + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: _primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    step.instruction,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _textGrey,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── Prev / Next navigation ──────────────────────────────────────────────
  Widget _buildBottomButtons(BuildContext context) {
    final isFirst = _currentIndex == 0;
    final isLast = _currentIndex == _total - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Row(
        children: [
          // Previous button (hidden on first exercise)
          if (!isFirst) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() => _currentIndex--);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: _primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Next / Finish button
          Expanded(
            flex: isFirst ? 1 : 1,
            child: SizedBox(
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_primary, _primaryLight],
                  ),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (isLast) {
                      // Last exercise → go to Congratulations screen
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WorkoutCompletedScreen(),
                        ),
                        // Keep only the routes before WorkoutProgressScreen
                        // so the back stack stays clean
                        (route) => route.isFirst,
                      );
                    } else {
                      setState(() => _currentIndex++);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  child: Text(
                    isLast ? 'Finish Workout' : 'Next Exercise',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
