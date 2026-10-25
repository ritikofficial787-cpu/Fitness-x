import 'package:flutter/material.dart';
import '../../models/workout_schedule.dart';

class WorkoutScheduleDetailsScreen extends StatefulWidget {
  /// The schedule entry to display
  final WorkoutSchedule schedule;

  const WorkoutScheduleDetailsScreen({
    super.key,
    required this.schedule,
  });

  @override
  State<WorkoutScheduleDetailsScreen> createState() =>
      _WorkoutScheduleDetailsScreenState();
}

class _WorkoutScheduleDetailsScreenState
    extends State<WorkoutScheduleDetailsScreen> {
  // App colour palette – same as the rest of the app
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildDetailsCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: _textDark,
              ),
            ),
          ),
          const Text(
            'Workout Schedule',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    final schedule = widget.schedule;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Workout name
          Text(
            schedule.workoutName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 8),

          // Date and time row
          Row(
            children: [
              const Icon(Icons.access_time, size: 15, color: _textGrey),
              const SizedBox(width: 6),
              Text(
                '${schedule.dateLabel} | ${schedule.formattedTime}',
                style: const TextStyle(fontSize: 13, color: _textGrey),
              ),
            ],
          ),

          // Completed badge (shown only when marked done)
          if (schedule.completed) ...[
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle,
                      size: 14, color: Color(0xFF4CAF50)),
                  SizedBox(width: 4),
                  Text(
                    'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 20),

          // Details rows
          _detailRow('Difficulty', schedule.difficulty),
          _detailRow('Repetitions', '${schedule.repetitions} reps'),
          _detailRow('Weight', schedule.weight),

          const SizedBox(height: 30),

          // Mark as Done button (disabled once completed)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: schedule.completed
                    ? const LinearGradient(
                        colors: [Color(0xFFB0B0B0), Color(0xFFD0D0D0)],
                      )
                    : const LinearGradient(
                        colors: [_primary, _primaryLight],
                      ),
                borderRadius: BorderRadius.circular(99),
                boxShadow: [
                  if (!schedule.completed)
                    BoxShadow(
                      color: _primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: ElevatedButton(
                onPressed: schedule.completed ? null : _markAsDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                child: Text(
                  schedule.completed ? '✓  Completed' : 'Mark as Done',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: _textGrey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
        ],
      ),
    );
  }

  void _markAsDone() {
    setState(() {
      widget.schedule.completed = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Workout marked as completed! 🎉'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
