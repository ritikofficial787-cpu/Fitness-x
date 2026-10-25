// ─────────────────────────────────────────────────────────────────────────────
// workout_schedule.dart
//
// Simple data model for a scheduled workout session.
// No database, no Firebase – data lives in memory during the app session.
// Easy to edit: just update the fields below if you need more data.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Represents one scheduled workout entry.
class WorkoutSchedule {
  /// Name of the workout (e.g. "Fullbody Workout")
  String workoutName;

  /// Image path for the workout (reused from WorkoutModel.imagePath)
  String imagePath;

  /// The date this workout is scheduled for
  DateTime date;

  /// The time this workout is scheduled for
  TimeOfDay time;

  /// Difficulty level: 'Beginner', 'Intermediate', or 'Advanced'
  String difficulty;

  /// Number of repetitions the user wants to do
  int repetitions;

  /// Weight selection (e.g. 'No Weight', '5 kg', '10 kg')
  String weight;

  /// Whether the user has marked this as completed
  bool completed;

  WorkoutSchedule({
    required this.workoutName,
    required this.imagePath,
    required this.date,
    required this.time,
    this.difficulty = 'Beginner',
    this.repetitions = 10,
    this.weight = 'No Weight',
    this.completed = false,
  });

  /// Returns a human-readable time string like "09:00 AM"
  String get formattedTime {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Returns true if the schedule is for today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Returns true if the schedule is for tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Returns a label like "Today", "Tomorrow", or "Oct 05"
  String get dateLabel {
    if (isToday) return 'Today';
    if (isTomorrow) return 'Tomorrow';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month]} ${date.day}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GLOBAL SCHEDULE LIST
//
// All schedule entries live here. Since we have no database, this list
// acts as our in-memory "store". It's pre-seeded with two example entries
// so the UI looks populated from the start.
//
// To reset: just clear this list –  scheduleList.clear();
// ─────────────────────────────────────────────────────────────────────────────

final List<WorkoutSchedule> scheduleList = [
  WorkoutSchedule(
    workoutName: 'Fullbody Workout',
    imagePath: 'assets/images/onboarding1.png',
    date: DateTime.now(),
    time: const TimeOfDay(hour: 9, minute: 0),
    difficulty: 'Beginner',
    repetitions: 20,
    weight: 'No Weight',
    completed: false,
  ),
  WorkoutSchedule(
    workoutName: 'Lowerbody Workout',
    imagePath: 'assets/images/onboarding4.png',
    date: DateTime.now().add(const Duration(days: 1)),
    time: const TimeOfDay(hour: 15, minute: 0),
    difficulty: 'Intermediate',
    repetitions: 15,
    weight: '5 kg',
    completed: false,
  ),
];
