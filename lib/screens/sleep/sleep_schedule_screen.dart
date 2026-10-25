// ─────────────────────────────────────────────────────────────────────────────
// sleep_schedule_screen.dart
//
// Sleep Schedule screen showing:
//  - Ideal hours banner card
//  - Horizontal 7-day date selector
//  - Sleep schedule list (Bedtime + Alarm entries)
//  - "You will get X hours tonight" summary
//  - FAB to add a new alarm
//
// NOTE:
// Full background alarm support requires a proper alarm manager plugin.
// The alarm here is triggered manually via the "Test Alarm" button or
// automatically when the app is running at the alarm time.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/sleep_model.dart';
import 'add_sleep_alarm_screen.dart';
import 'alarm_ringing_screen.dart';

class SleepScheduleScreen extends StatefulWidget {
  const SleepScheduleScreen({super.key});

  @override
  State<SleepScheduleScreen> createState() => _SleepScheduleScreenState();
}

class _SleepScheduleScreenState extends State<SleepScheduleScreen> {
  // ── App colour palette ─────────────────────────────────────────────────
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // ── Date state ─────────────────────────────────────────────────────────
  late DateTime _selectedDate;

  // ── Alarm checker timer ─────────────────────────────────────────────────
  // NOTE:
  // Full background/locked-screen alarm support can be added later.
  // This timer checks every 30 seconds while the app is running.
  Timer? _alarmChecker;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    // Check alarm status every 30 seconds while screen is visible
    _alarmChecker = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkAlarms(),
    );
  }

  @override
  void dispose() {
    _alarmChecker?.cancel();
    super.dispose();
  }

  // ── Check if any alarm should ring now ─────────────────────────────────
  void _checkAlarms() {
    final now = TimeOfDay.now();
    for (final schedule in sleepScheduleList) {
      if (!schedule.enabled) continue;
      if (schedule.alarmTime.hour == now.hour &&
          schedule.alarmTime.minute == now.minute) {
        // Alarm matches current minute — show ringing screen
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AlarmRingingScreen(
                alarmTime: schedule.formattedAlarmTime,
                label: schedule.label,
              ),
            ),
          );
        }
        break;
      }
    }
  }

  // ── Week dates (7 days starting Monday) ───────────────────────────────
  List<DateTime> get _weekDates {
    final weekday = _selectedDate.weekday;
    final monday = _selectedDate.subtract(Duration(days: weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dayAbbr(int weekday) {
    const abbrs = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return abbrs[weekday];
  }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // ── Ideal hours banner ────────────────────────────
                    _buildIdealHoursBanner(),
                    const SizedBox(height: 20),
                    // ── "Your Schedule" + date row ────────────────────
                    _buildSectionHeader('Your Schedule'),
                    const SizedBox(height: 12),
                    _buildDateRow(),
                    const SizedBox(height: 16),
                    // ── Schedule list ─────────────────────────────────
                    _buildScheduleList(),
                    // ── Tonight summary ───────────────────────────────
                    if (sleepScheduleList.isNotEmpty)
                      _buildTonightSummary(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // FAB to add new alarm
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const AddSleepAlarmScreen()),
          );
          setState(() {});
        },
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
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
          const Text(
            'Sleep Schedule',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _bgLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.more_horiz, size: 20, color: _textDark),
          ),
        ],
      ),
    );
  }

  // ── Ideal Hours Banner ─────────────────────────────────────────────────
  Widget _buildIdealHoursBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB8C8FF), Color(0xFF9DCEFF)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ideal Hours for Sleep',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '8 hours 30 minutes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Moon & stars illustration using icons
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                ),
                const Icon(
                  Icons.bedtime,
                  color: Colors.white,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: _textDark,
        ),
      ),
    );
  }

  // ── 7-day horizontal date row ───────────────────────────────────────────
  Widget _buildDateRow() {
    final days = _weekDates;
    return SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: days.length,
        itemBuilder: (_, i) {
          final day = days[i];
          final isSelected = _isSameDay(day, _selectedDate);
          final isToday = _isSameDay(day, DateTime.now());

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = day),
            child: Container(
              width: 46,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [_primary, _primaryLight],
                      )
                    : null,
                color: isSelected ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayAbbr(day.weekday),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white70 : _textGrey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : _textDark,
                    ),
                  ),
                  if (isToday && !isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: _primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Schedule list ───────────────────────────────────────────────────────
  Widget _buildScheduleList() {
    if (sleepScheduleList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.bedtime_outlined, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 12),
              Text(
                'No sleep schedule yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: sleepScheduleList
          .map((schedule) => _buildScheduleCard(schedule))
          .toList(),
    );
  }

  Widget _buildScheduleCard(SleepSchedule schedule) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Column(
        children: [
          // ── Bedtime row ─────────────────────────────────────────────
          _buildTimeRow(
            icon: Icons.bedtime_outlined,
            title: 'Bedtime',
            time: schedule.formattedBedtime,
            subtitle: schedule.timeUntilBedtime(),
            schedule: schedule,
            isBedtime: true,
          ),
          const SizedBox(height: 10),
          // ── Alarm row ───────────────────────────────────────────────
          _buildTimeRow(
            icon: Icons.alarm,
            title: 'Alarm',
            time: schedule.formattedAlarmTime,
            subtitle: schedule.timeUntilAlarm(),
            schedule: schedule,
            isBedtime: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow({
    required IconData icon,
    required String title,
    required String time,
    required String subtitle,
    required SleepSchedule schedule,
    required bool isBedtime,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$title, ',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _textDark,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 13,
                        color: _primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 11, color: _textGrey),
                ),
              ],
            ),
          ),
          // Toggle + test button
          Column(
            children: [
              Switch(
                value: schedule.enabled,
                activeThumbColor: _primary,
                onChanged: (val) {
                  setState(() => schedule.enabled = val);
                },
              ),
              // "Test" button to simulate alarm ringing
              if (!isBedtime && schedule.enabled)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlarmRingingScreen(
                          alarmTime: schedule.formattedAlarmTime,
                          label: schedule.label,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Test',
                    style: TextStyle(
                      fontSize: 10,
                      color: _primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Tonight's sleep summary ─────────────────────────────────────────────
  Widget _buildTonightSummary() {
    final schedule = sleepScheduleList.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _primary.withValues(alpha: 0.12),
              _primaryLight.withValues(alpha: 0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _primary.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Text(
              'You will get ${schedule.sleepDuration} for tonight',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _sleepProgress(schedule.sleepDuration),
                backgroundColor: _primary.withValues(alpha: 0.15),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(_primary),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(_sleepProgress(schedule.sleepDuration) * 100).toInt()}% of recommended 8h 30m',
              style: const TextStyle(fontSize: 10, color: _textGrey),
            ),
          ],
        ),
      ),
    );
  }

  double _sleepProgress(String duration) {
    if (duration.contains('6')) return 6 / 8.5;
    if (duration.contains('7')) return 7 / 8.5;
    if (duration == '8 hours') return 8 / 8.5;
    if (duration.contains('8 hours 30')) return 1.0;
    if (duration.contains('9')) return 1.0;
    return 0.8;
  }
}
