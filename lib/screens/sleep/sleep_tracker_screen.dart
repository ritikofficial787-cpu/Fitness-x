// ─────────────────────────────────────────────────────────────────────────────
// sleep_tracker_screen.dart
//
// Main Sleep Tracker screen showing:
//  - Weekly sleep bar chart (Sun–Sat)
//  - "Last Night Sleep" card (8h 20m)
//  - Daily Sleep Schedule → Check button
//  - Today's Schedule (Bedtime + Alarm cards with toggles)
//  - Sleep Summary section (average, target, quality, goal)
//  - Sleep Quality selector (Poor / Average / Good / Excellent)
//  - Sleep Goal progress bar
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/sleep_model.dart';
import 'sleep_schedule_screen.dart';
import 'alarm_ringing_screen.dart';

class SleepTrackerScreen extends StatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  State<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends State<SleepTrackerScreen> {
  // ── App colour palette ─────────────────────────────────────────────────
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // ── Local state ─────────────────────────────────────────────────────────
  String _sleepQuality = 'Good'; // Poor / Average / Good / Excellent
  bool _sleepCompleted = false;

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

                    // ── 1. Weekly Sleep Chart ─────────────────────────
                    _buildWeeklyChart(),
                    const SizedBox(height: 20),

                    // ── 2. Last Night Sleep card ──────────────────────
                    _buildLastNightCard(),
                    const SizedBox(height: 16),

                    // ── 3. Daily Sleep Schedule row ───────────────────
                    _buildDailyScheduleRow(),
                    const SizedBox(height: 20),

                    // ── 4. Today's Schedule ───────────────────────────
                    _buildSectionTitle("Today's Schedule"),
                    const SizedBox(height: 12),
                    _buildTodaySchedule(),
                    const SizedBox(height: 20),

                    // ── 5. Sleep Summary ──────────────────────────────
                    _buildSectionTitle('Sleep Summary'),
                    const SizedBox(height: 12),
                    _buildSleepSummary(),
                    const SizedBox(height: 20),

                    // ── 6. Sleep Goal ─────────────────────────────────
                    _buildSectionTitle('Sleep Goal'),
                    const SizedBox(height: 12),
                    _buildSleepGoal(),
                    const SizedBox(height: 20),

                    // ── 7. Sleep Quality ──────────────────────────────
                    _buildSectionTitle('Sleep Quality'),
                    const SizedBox(height: 12),
                    _buildSleepQuality(),
                    const SizedBox(height: 20),

                    // ── 8. Mark Sleep Complete ────────────────────────
                    _buildMarkCompleteSection(),
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
            'Sleep Tracker',
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

  // ── 1. Weekly Sleep Bar Chart ───────────────────────────────────────────
  Widget _buildWeeklyChart() {
    final today = todayWeekIndex;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + weekly badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Sleep',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _cardBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'This Week',
                  style: TextStyle(
                    color: _primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // "63% increase" pill (dummy)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '▲ 13% Increase',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Bar chart
          SizedBox(
            height: 110,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => _primary.withValues(alpha: 0.8),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final h = weeklySleepHours[group.x];
                      final hInt = h.floor();
                      final m = ((h - hInt) * 60).round();
                      return BarTooltipItem(
                        m == 0 ? '${hInt}h' : '${hInt}h ${m}m',
                        const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= weekDayLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          weekDayLabels[idx],
                          style: TextStyle(
                            fontSize: 10,
                            color: idx == today ? _primary : _textGrey,
                            fontWeight: idx == today
                                ? FontWeight.bold
                                : FontWeight.w400,
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 2,
                      getTitlesWidget: (value, _) => Text(
                        '${value.toInt()}h',
                        style: const TextStyle(
                            fontSize: 9, color: _textGrey),
                      ),
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Color(0xFFE8F0FE),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(7, (i) {
                  final isToday = i == today;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: weeklySleepHours[i],
                        gradient: isToday
                            ? const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [_primary, _primaryLight],
                              )
                            : null,
                        color: isToday ? null : _cardBg,
                        width: 18,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 2. Last Night Sleep card ────────────────────────────────────────────
  Widget _buildLastNightCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
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
          const Text(
            'Last Night Sleep',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '8h 20m',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          // Mini wave decoration (simple line pattern)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 30,
              child: CustomPaint(
                painter: _WavePainter(),
                size: const Size(double.infinity, 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. Daily Sleep Schedule row ─────────────────────────────────────────
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
            'Daily Sleep Schedule',
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
                    builder: (_) => const SleepScheduleScreen()),
              );
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 6),
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

  // ── 4. Today's Schedule ─────────────────────────────────────────────────
  Widget _buildTodaySchedule() {
    if (sleepScheduleList.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _bgLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(Icons.bedtime_outlined, size: 18, color: _textGrey),
            SizedBox(width: 10),
            Text('No schedule set. Tap "Check" to add one.',
                style: TextStyle(fontSize: 12, color: _textGrey)),
          ],
        ),
      );
    }

    final schedule = sleepScheduleList.first;
    return Column(
      children: [
        // Bedtime card
        _buildScheduleCard(
          icon: Icons.bedtime_outlined,
          title: 'Bedtime',
          time: schedule.formattedBedtime,
          subtitle: schedule.timeUntilBedtime(),
          enabled: schedule.enabled,
          onToggle: (val) => setState(() => schedule.enabled = val),
          onTap: null,
        ),
        const SizedBox(height: 10),
        // Alarm card
        _buildScheduleCard(
          icon: Icons.alarm,
          title: 'Alarm',
          time: schedule.formattedAlarmTime,
          subtitle: schedule.timeUntilAlarm(),
          enabled: schedule.enabled,
          onToggle: (val) => setState(() => schedule.enabled = val),
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
        ),
      ],
    );
  }

  Widget _buildScheduleCard({
    required IconData icon,
    required String title,
    required String time,
    required String subtitle,
    required bool enabled,
    required ValueChanged<bool> onToggle,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: _textGrey),
                ),
              ],
            ),
          ),
          // More icon / tap area
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.play_circle_outline,
                    color: _primary, size: 20),
              ),
            ),
          Switch(
            value: enabled,
            activeThumbColor: _primary,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }

  // ── 5. Sleep Summary ────────────────────────────────────────────────────
  Widget _buildSleepSummary() {
    final items = [
      {'label': 'Average Sleep', 'value': '7h 40m', 'emoji': '😴'},
      {'label': 'Target Sleep', 'value': '8h', 'emoji': '🎯'},
      {'label': 'Sleep Quality', 'value': _sleepQuality, 'emoji': '⭐'},
      {'label': 'Sleep Goal', 'value': '8 hours', 'emoji': '🏆'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item['emoji'] as String,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                item['value'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                ),
              ),
              Text(
                item['label'] as String,
                style: const TextStyle(
                  fontSize: 10,
                  color: _textGrey,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── 6. Sleep Goal ───────────────────────────────────────────────────────
  Widget _buildSleepGoal() {
    // Dummy: 8h achieved out of 8h goal
    const double achieved = 8.0;
    const double goal = 8.0;
    final progress = (achieved / goal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '8h / 8h',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '✓ Goal Met',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _cardBg,
              valueColor: const AlwaysStoppedAnimation<Color>(_primary),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ── 7. Sleep Quality selector ────────────────────────────────────────────
  Widget _buildSleepQuality() {
    const options = ['Poor', 'Average', 'Good', 'Excellent'];
    return Row(
      children: options.map((opt) {
        final isSelected = _sleepQuality == opt;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _sleepQuality = opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 6),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [_primary, _primaryLight])
                    : null,
                color: isSelected ? null : _bgLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    _qualityEmoji(opt),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    opt,
                    style: TextStyle(
                      fontSize: 9,
                      color: isSelected ? Colors.white : _textGrey,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _qualityEmoji(String quality) {
    switch (quality) {
      case 'Poor':
        return '😴';
      case 'Average':
        return '😐';
      case 'Good':
        return '🙂';
      case 'Excellent':
        return '😃';
      default:
        return '😐';
    }
  }

  // ── 8. Mark Sleep Complete ──────────────────────────────────────────────
  Widget _buildMarkCompleteSection() {
    if (_sleepCompleted) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 36),
            SizedBox(height: 8),
            Text(
              '✓ Sleep Completed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Duration: 8h 20m',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _sleepCompleted = true),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: _primary, width: 2),
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: _primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Mark Sleep Complete',
              style: TextStyle(
                color: _primary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _WavePainter — simple wave decoration for the Last Night Sleep card
// ─────────────────────────────────────────────────────────────────────────────

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.6);

    final waveWidth = size.width / 5;
    for (int i = 0; i < 5; i++) {
      path.quadraticBezierTo(
        waveWidth * i + waveWidth / 4,
        size.height * 0.1,
        waveWidth * i + waveWidth / 2,
        size.height * 0.6,
      );
      path.quadraticBezierTo(
        waveWidth * i + 3 * waveWidth / 4,
        size.height * 1.0,
        waveWidth * (i + 1),
        size.height * 0.6,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
