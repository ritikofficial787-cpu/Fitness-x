import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Activity Tracker screen showing today's targets, progress charts,
/// and a list of latest activities.
class ActivityTrackerScreen extends StatefulWidget {
  const ActivityTrackerScreen({super.key});

  @override
  State<ActivityTrackerScreen> createState() => _ActivityTrackerScreenState();
}

class _ActivityTrackerScreenState extends State<ActivityTrackerScreen> {
  final List<Map<String, dynamic>> _workouts = [
    {
      'name': 'Fullbody Workout',
      'durationMinutes': 30,
      'calories': 180,
    },
    {
      'name': 'Lowerbody Workout',
      'durationMinutes': 25,
      'calories': 150,
    },
    {
      'name': 'Ab Workout',
      'durationMinutes': 20,
      'calories': 120,
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildHeader(),
              const SizedBox(height: 25),
              _buildTodayTarget(),
              const SizedBox(height: 25),
              _buildActivityProgress(),
              const SizedBox(height: 25),
              _buildLatestActivity(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                size: 14, color: Color(0xFF1D1617)),
          ),
        ),
        const Text(
          'Activity Tracker',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1D1617),
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.more_horiz,
              size: 18, color: Color(0xFF1D1617)),
        ),
      ],
    );
  }

  Widget _buildTodayTarget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today Target',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1617),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Text(
                  'Check',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildTargetItem(
                icon: Icons.water_drop_outlined,
                value: '8L',
                label: 'Water Intake',
                color: const Color(0xFF92A3FD),
              ),
              const SizedBox(width: 15),
              _buildTargetItem(
                icon: Icons.directions_walk,
                value: '2400',
                label: 'Foot Steps',
                color: const Color(0xFFC58BF2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF7B6F72),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activity Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1617),
          ),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          height: 220,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = [
                        'Sun',
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat'
                      ];
                      if (value.toInt() < days.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF7B6F72),
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 30,
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
              barGroups: List.generate(7, (index) {
                final values1 = [40, 55, 30, 65, 45, 70, 50];
                final values2 = [30, 45, 55, 40, 60, 35, 45];
                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: values1[index].toDouble(),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                      ),
                      width: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    BarChartRodData(
                      toY: values2[index].toDouble(),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Color(0xFFC58BF2), Color(0xFFEEA4CE)],
                      ),
                      width: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLatestActivity() {
    final activities = [
      {
        'name': 'Drinking 300ml Water',
        'time': 'About 3 minutes ago',
        'icon': Icons.water_drop_outlined,
        'color': const Color(0xFF92A3FD),
      },
      {
        'name': 'Eat Snack (Protein)',
        'time': 'About 10 minutes ago',
        'icon': Icons.restaurant_outlined,
        'color': const Color(0xFFC58BF2),
      },
      ..._workouts.take(3).map((w) => {
            'name': w['name'],
            'time': '${w['durationMinutes']} minutes | ${w['calories']} Cal',
            'icon': Icons.fitness_center,
            'color': const Color(0xFF92A3FD),
          }),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Latest Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1617),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                'See more',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFADA4A5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        ...activities.map(
          (a) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (a['color'] as Color).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    a['icon'] as IconData,
                    color: a['color'] as Color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a['name'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1D1617),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        a['time'] as String,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFADA4A5),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.more_vert,
                  color: Color(0xFFADA4A5),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
