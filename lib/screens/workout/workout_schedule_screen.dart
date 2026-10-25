
import 'package:flutter/material.dart';
import '../../models/workout_schedule.dart';
import 'add_workout_schedule_screen.dart';
import 'workout_schedule_details_screen.dart';

class WorkoutScheduleScreen extends StatefulWidget {
  const WorkoutScheduleScreen({super.key});

  @override
  State<WorkoutScheduleScreen> createState() => _WorkoutScheduleScreenState();
}

class _WorkoutScheduleScreenState extends State<WorkoutScheduleScreen> {
  // App colour palette – same as the rest of the app
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);

  // Currently displayed month start (first day of the shown month)
  late DateTime _currentMonth;

  // The date the user has selected in the date row
  late DateTime _selectedDate;

  // Hour range shown in the time-slot list
  final List<int> _hours = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = now;
    _currentMonth = DateTime(now.year, now.month, 1);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Returns a list of 7 dates centred on _selectedDate for the horizontal row
  List<DateTime> get _weekDates {
    // Show a 7-day window starting from Monday of the selected week
    final weekday = _selectedDate.weekday; // 1=Mon … 7=Sun
    final monday = _selectedDate.subtract(Duration(days: weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  String _monthName(int month) {
    const names = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return names[month];
  }

  String _dayAbbr(int weekday) {
    const abbrs = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return abbrs[weekday];
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Returns schedules that fall on _selectedDate
  List<WorkoutSchedule> get _schedulesForSelectedDay => scheduleList
      .where((s) => _isSameDay(s.date, _selectedDate))
      .toList()
    ..sort((a, b) {
      final aMin = a.time.hour * 60 + a.time.minute;
      final bMin = b.time.hour * 60 + b.time.minute;
      return aMin.compareTo(bMin);
    });

  /// Find a schedule that matches a given hour slot
  WorkoutSchedule? _scheduleAt(int hour) {
    for (final s in _schedulesForSelectedDay) {
      if (s.time.hour == hour) return s;
    }
    return null;
  }

  String _hourLabel(int hour) {
    if (hour == 0 || hour == 12) return '12:00 ${hour == 0 ? "AM" : "PM"}';
    if (hour < 12) return '${hour.toString().padLeft(2, "0")}:00 AM';
    return '${(hour - 12).toString().padLeft(2, "0")}:00 PM';
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
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildMonthNavigator()),
                  SliverToBoxAdapter(child: _buildDateRow()),
                  SliverToBoxAdapter(
                    child: _schedulesForSelectedDay.isEmpty
                        ? _buildEmptyState()
                        : const SizedBox(height: 8),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, index) => _buildTimeSlot(_hours[index]),
                      childCount: _hours.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating "+" button
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSchedule,
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
            'Workout Schedule',
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

  // ── Month Navigator ─────────────────────────────────────────────────────
  Widget _buildMonthNavigator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                // Move selected date to the first of the new month
                _selectedDate =
                    DateTime(_currentMonth.year, _currentMonth.month, 1);
              });
            },
            child: const Icon(Icons.chevron_left, color: _textDark),
          ),
          const SizedBox(width: 12),
          Text(
            '${_monthName(_currentMonth.month)} ${_currentMonth.year}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                _selectedDate =
                    DateTime(_currentMonth.year, _currentMonth.month, 1);
              });
            },
            child: const Icon(Icons.chevron_right, color: _textDark),
          ),
        ],
      ),
    );
  }

  // ── Horizontal Date Row (7 days) ────────────────────────────────────────
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
                  // Small dot under "today"
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

  // ── Empty state ─────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.event_busy, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No workout scheduled\nfor this day',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap + to add one!',
              style: TextStyle(fontSize: 12, color: Colors.grey[350]),
            ),
          ],
        ),
      ),
    );
  }

  // ── Time slot row ───────────────────────────────────────────────────────
  Widget _buildTimeSlot(int hour) {
    final schedule = _scheduleAt(hour);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time label
            SizedBox(
              width: 68,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _hourLabel(hour),
                  style: TextStyle(
                    fontSize: 11,
                    color: schedule != null ? _textDark : _textGrey,
                    fontWeight: schedule != null
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),

            // Vertical line + dot
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 14),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: schedule != null ? _primary : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                // Line going down
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // Schedule card (if any) or empty space
            Expanded(
              child: schedule != null
                  ? _buildScheduleCard(schedule)
                  : const SizedBox(height: 44),
            ),
          ],
        ),
      ),
    );
  }

  // ── Schedule card ───────────────────────────────────────────────────────
  Widget _buildScheduleCard(WorkoutSchedule schedule) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                WorkoutScheduleDetailsScreen(schedule: schedule),
          ),
        );
        // Refresh state after returning (e.g. "Mark as Done" was pressed)
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6, top: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: schedule.completed
              ? const LinearGradient(
                  colors: [Color(0xFFB0EDB0), Color(0xFFD4F5D4)])
              : LinearGradient(
                  colors: [
                    _primary.withValues(alpha: 0.85),
                    _primaryLight.withValues(alpha: 0.85),
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.workoutName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${schedule.formattedTime}  •  ${schedule.difficulty}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            if (schedule.completed)
              const Icon(Icons.check_circle, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  // ── Open Add Schedule screen ────────────────────────────────────────────
  Future<void> _openAddSchedule() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddWorkoutScheduleScreen()),
    );
    // Refresh after returning so the new schedule shows up
    setState(() {});
  }
}
