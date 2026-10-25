import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/workout_model.dart';
import '../../models/workout_schedule.dart';
import 'workout_details_screen.dart';
import 'workout_schedule_screen.dart';

class WorkoutTrackerScreen extends StatefulWidget {
  const WorkoutTrackerScreen({super.key});

  @override
  State<WorkoutTrackerScreen> createState() => _WorkoutTrackerScreenState();
}

class _WorkoutTrackerScreenState extends State<WorkoutTrackerScreen> {
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // Upcoming workouts shown in the schedule area
  final List<Map<String, dynamic>> _upcoming = [
    {
      'name': 'Fullbody Workout',
      'time': 'Today | 09:00 am',
      'enabled': true,
      'workout': allWorkouts[0],
    },
    {
      'name': 'Lowerbody Workout',
      'time': 'June 09 | 10:30 pm',
      'enabled': false,
      'workout': allWorkouts[1],
    },
  ];

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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildWeeklyChart(),
                    const SizedBox(height: 25),
                    _buildScheduleSection(),
                    const SizedBox(height: 20),
                    _buildDailyScheduleRow(),
                    const SizedBox(height: 20),
                    _buildUpcomingSection(),
                    const SizedBox(height: 25),
                    _buildSectionTitle('What Do You Want To Train'),
                    const SizedBox(height: 15),
                    _buildWorkoutGrid(),
                    const SizedBox(height: 30),
                  ],
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
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 14, color: _textDark),
            ),
          ),
          const Text(
            'Workout Tracker',
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

  Widget _buildWeeklyChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB8C8FF), Color(0xFF92A3FD)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Workout',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Fullbody Workout',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 90,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, _) {
                        const days = [
                          'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
                        ];
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white70,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _chartBar(0, 50),
                  _chartBar(1, 75),
                  _chartBar(2, 60),
                  _chartBar(3, 90, highlighted: true),
                  _chartBar(4, 45),
                  _chartBar(5, 80),
                  _chartBar(6, 55),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _chartBar(int x, double y, {bool highlighted = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: highlighted ? Colors.white : Colors.white38,
          width: 14,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  Widget _buildScheduleSection() {
    final today = scheduleList
        .where((s) => s.isToday)
        .toList()
      ..sort((a, b) {
        final aMin = a.time.hour * 60 + a.time.minute;
        final bMin = b.time.hour * 60 + b.time.minute;
        return aMin.compareTo(bMin);
      });

    final upcoming = scheduleList
        .where((s) => !s.isToday && !s.completed)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Workout Schedule',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WorkoutScheduleScreen(),
                  ),
                );
                setState(() {});
              },
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 12,
                  color: _primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Today\'s Schedule',
          style: TextStyle(
            fontSize: 12,
            color: _textGrey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        if (today.isEmpty)
          _buildEmptyScheduleHint('No workout scheduled for today')
        else
          ...today.take(2).map((s) => _buildSchedulePreviewCard(s)),
        if (upcoming.isNotEmpty) ...[  
          const SizedBox(height: 12),
          const Text(
            'Upcoming Workout',
            style: TextStyle(
              fontSize: 12,
              color: _textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          ...upcoming.take(1).map((s) => _buildSchedulePreviewCard(s)),
        ],
      ],
    );
  }

  /// A compact preview card for one schedule entry
  Widget _buildSchedulePreviewCard(WorkoutSchedule schedule) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const WorkoutScheduleScreen(),
          ),
        );
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_primary, _primaryLight],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.formattedTime,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _textGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    schedule.workoutName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${schedule.repetitions} reps  •  ${schedule.difficulty}',
                    style: const TextStyle(fontSize: 10, color: _textGrey),
                  ),
                ],
              ),
            ),
            if (schedule.completed)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '✓ Done',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else if (schedule.isToday)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 10,
                    color: _primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFA07A).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  schedule.dateLabel,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFCC6600),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Small hint when no workout is scheduled
  Widget _buildEmptyScheduleHint(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _bgLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.event_available, size: 18, color: _textGrey),
          const SizedBox(width: 10),
          Text(
            message,
            style: const TextStyle(fontSize: 12, color: _textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyScheduleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Daily Workout Schedule',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WorkoutScheduleScreen(),
                ),
              );
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primary, _primaryLight],
                ),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Text(
                'Check',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Upcoming Workout ────────────────────────────────────────────────────
  Widget _buildUpcomingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Workout',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'See more',
                style: TextStyle(fontSize: 12, color: _textGrey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._upcoming.map((item) => _buildUpcomingCard(item)),
      ],
    );
  }

  Widget _buildUpcomingCard(Map<String, dynamic> item) {
    final workout = item['workout'] as WorkoutModel;
    return GestureDetector(
      onTap: () {
        // Tapping an upcoming workout also opens Workout Details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkoutDetailsScreen(workout: workout),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
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
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                workout.imagePath,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 50,
                  height: 50,
                  color: _cardBg,
                  child: const Icon(Icons.fitness_center, color: _primary),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Name and time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['time'] as String,
                    style:
                        const TextStyle(fontSize: 11, color: _textGrey),
                  ),
                ],
              ),
            ),
            // Toggle switch
            Switch(
              value: item['enabled'] as bool,
              activeThumbColor: _primary,
              onChanged: (val) {
                setState(() => item['enabled'] = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Section Title ───────────────────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _textDark,
      ),
    );
  }

  // ── 12 Workout Cards Grid ───────────────────────────────────────────────
  Widget _buildWorkoutGrid() {
    return Column(
      children: allWorkouts
          .map((workout) => _buildWorkoutCard(workout))
          .toList(),
    );
  }

  Widget _buildWorkoutCard(WorkoutModel workout) {
    // Difficulty badge colour
    Color diffColor;
    switch (workout.difficulty) {
      case 'Advanced':
        diffColor = const Color(0xFFFF7676);
        break;
      case 'Intermediate':
        diffColor = const Color(0xFFFFA07A);
        break;
      default:
        diffColor = const Color(0xFF92A3FD);
    }

    return GestureDetector(
      onTap: () {
        // Navigate to Workout Details, passing the selected workout
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkoutDetailsScreen(workout: workout),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Workout image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: Image.asset(
                workout.imagePath,
                width: 100,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 110,
                  color: _cardBg,
                  child: const Icon(Icons.fitness_center,
                      color: _primary, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${workout.exercises.length} Exercises | '
                      '${workout.duration}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: _textGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Difficulty badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: diffColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        workout.difficulty,
                        style: TextStyle(
                          fontSize: 10,
                          color: diffColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // View more button
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_primary, _primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        'View more',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
