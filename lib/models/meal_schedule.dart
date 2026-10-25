// ─────────────────────────────────────────────────────────────────────────────
// meal_schedule.dart
//
// Simple data model for a scheduled meal entry.
// No database – data lives in memory during the app session.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

/// Represents one scheduled meal entry (e.g. Paneer Roti at 1:00 PM for Lunch).
class MealScheduleEntry {
  /// Name of the meal (e.g. "Paneer Roti")
  String mealName;

  /// Meal type: 'Breakfast', 'Lunch', 'Snacks', 'Dinner'
  String mealType;

  /// The date this meal is scheduled for
  DateTime date;

  /// The time this meal is scheduled for
  TimeOfDay time;

  /// Calories for the meal
  int calories;

  /// Protein in grams
  int protein;

  /// Whether the user has marked this meal as done
  bool completed;

  MealScheduleEntry({
    required this.mealName,
    required this.mealType,
    required this.date,
    required this.time,
    required this.calories,
    required this.protein,
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

  /// Returns a short date label like "Today" or "Oct 05"
  String get dateLabel {
    if (isToday) return 'Today';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month]} ${date.day}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GLOBAL MEAL SCHEDULE LIST
//
// All scheduled meal entries live here.
// Pre-seeded with today's meals so the UI looks populated from the start.
// ─────────────────────────────────────────────────────────────────────────────

final List<MealScheduleEntry> mealScheduleList = [
  MealScheduleEntry(
    mealName: 'Idli + Sambar',
    mealType: 'Breakfast',
    date: DateTime.now(),
    time: const TimeOfDay(hour: 7, minute: 30),
    calories: 320,
    protein: 12,
    completed: false,
  ),
  MealScheduleEntry(
    mealName: 'Paneer Roti',
    mealType: 'Lunch',
    date: DateTime.now(),
    time: const TimeOfDay(hour: 13, minute: 0),
    calories: 480,
    protein: 22,
    completed: false,
  ),
  MealScheduleEntry(
    mealName: 'Sprouts Chaat',
    mealType: 'Snacks',
    date: DateTime.now(),
    time: const TimeOfDay(hour: 16, minute: 30),
    calories: 180,
    protein: 10,
    completed: false,
  ),
  MealScheduleEntry(
    mealName: 'Dal Rice',
    mealType: 'Dinner',
    date: DateTime.now(),
    time: const TimeOfDay(hour: 20, minute: 0),
    calories: 420,
    protein: 15,
    completed: false,
  ),
];
