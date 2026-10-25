// ─────────────────────────────────────────────────────────────────────────────
// sleep_model.dart
//
// Simple data models for the Sleep Tracker feature.
// All data is local dummy data — no database, no Firebase.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SleepSchedule — represents one bedtime + alarm entry
// ─────────────────────────────────────────────────────────────────────────────

class SleepSchedule {
  /// Label for the alarm, e.g. "Morning Workout"
  String label;

  /// The time the user wants to go to bed
  TimeOfDay bedtime;

  /// The time the alarm should ring (wake-up time)
  TimeOfDay alarmTime;

  /// How many hours of sleep the user wants (e.g. "8 hours")
  String sleepDuration;

  /// Repeat option: 'Every Day', 'Mon - Fri', 'Weekends', 'Custom'
  String repeat;

  /// Days selected for custom repeat (e.g. ['Mon', 'Wed', 'Fri'])
  List<String> customDays;

  /// Whether vibration is enabled when alarm rings
  bool vibrate;

  /// Whether this schedule is currently active
  bool enabled;

  /// Whether the user has completed this sleep session
  bool sleepCompleted;

  /// How long the user actually slept (filled after completion)
  String actualSleepDuration;

  SleepSchedule({
    required this.label,
    required this.bedtime,
    required this.alarmTime,
    required this.sleepDuration,
    this.repeat = 'Every Day',
    this.customDays = const [],
    this.vibrate = true,
    this.enabled = true,
    this.sleepCompleted = false,
    this.actualSleepDuration = '',
  });

  /// Human-readable bedtime string, e.g. "09:00 PM"
  String get formattedBedtime => _formatTime(bedtime);

  /// Human-readable alarm time string, e.g. "05:10 AM"
  String get formattedAlarmTime => _formatTime(alarmTime);

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Returns how long until the alarm fires from now (rough estimate)
  String timeUntilAlarm() {
    final now = TimeOfDay.now();
    int nowMinutes = now.hour * 60 + now.minute;
    int alarmMinutes = alarmTime.hour * 60 + alarmTime.minute;
    int diff = alarmMinutes - nowMinutes;
    if (diff < 0) diff += 24 * 60; // next day
    final hours = diff ~/ 60;
    final mins = diff % 60;
    if (hours == 0) return 'in $mins minutes';
    if (mins == 0) return 'in $hours hours';
    return 'in $hours hours $mins minutes';
  }

  /// Returns how long until bedtime from now
  String timeUntilBedtime() {
    final now = TimeOfDay.now();
    int nowMinutes = now.hour * 60 + now.minute;
    int bedMinutes = bedtime.hour * 60 + bedtime.minute;
    int diff = bedMinutes - nowMinutes;
    if (diff < 0) diff += 24 * 60;
    final hours = diff ~/ 60;
    final mins = diff % 60;
    if (hours == 0) return 'in $mins minutes';
    if (mins == 0) return 'in $hours hours';
    return 'in $hours hours $mins minutes';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GLOBAL SLEEP SCHEDULE LIST
//
// Pre-seeded with two example entries so the UI looks populated.
// All data is local — no database.
// ─────────────────────────────────────────────────────────────────────────────

final List<SleepSchedule> sleepScheduleList = [
  SleepSchedule(
    label: 'Bedtime',
    bedtime: const TimeOfDay(hour: 21, minute: 0), // 9:00 PM
    alarmTime: const TimeOfDay(hour: 5, minute: 10), // 5:10 AM
    sleepDuration: '8 hours 10 minutes',
    repeat: 'Every Day',
    vibrate: true,
    enabled: true,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Weekly dummy sleep data (hours per night, Sun–Sat)
// ─────────────────────────────────────────────────────────────────────────────

const List<double> weeklySleepHours = [7.0, 6.0, 8.0, 7.0, 8.33, 7.0, 8.0];
const List<String> weekDayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

/// Today's index in the week (0=Sun … 6=Sat)
int get todayWeekIndex => DateTime.now().weekday % 7;
