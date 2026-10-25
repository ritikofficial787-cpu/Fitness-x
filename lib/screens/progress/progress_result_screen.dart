// -----------------------------------------------------------------------------
// progress_result_screen.dart
//
// Comparison Result screen � shows side-by-side photos and statistics.
// Tabs:
//  - Photo tab  : side-by-side comparison + dummy metrics
//  - Statistics : progress bars, weight/goal info, line chart
// -----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'progress_photo_screen.dart'; // for ProgressPhoto model

class ProgressResultScreen extends StatefulWidget {
  final ProgressPhoto photo1;
  final ProgressPhoto photo2;

  const ProgressResultScreen({
    super.key,
    required this.photo1,
    required this.photo2,
  });

  @override
  State<ProgressResultScreen> createState() => _ProgressResultScreenState();
}

class _ProgressResultScreenState extends State<ProgressResultScreen>
    with SingleTickerProviderStateMixin {
  // App colour palette
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 16),

            // Tab bar
            _buildTabBar(),
            const SizedBox(height: 4),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPhotoTab(),
                  _buildStatisticsTab(),
                ],
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
            'Result',
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

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: _textGrey,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Photo'),
            Tab(text: 'Statistics'),
          ],
        ),
      ),
    );
  }

  // -- Photo Tab --------------------------------------------------------------
  Widget _buildPhotoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Side-by-side comparison
          _buildSideBySidePhotos(),
          const SizedBox(height: 28),

          // "Your Progress" metrics
          _buildSectionTitle('Your Progress'),
          const SizedBox(height: 16),
          _buildProgressMetrics(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSideBySidePhotos() {
    return Column(
      children: [
        Row(
          children: [
            // Month 1 photo
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        widget.photo1.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: _cardBg,
                          child: const Icon(Icons.person_outline,
                              size: 48, color: _primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.photo1.date,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                  if (widget.photo1.weight.isNotEmpty)
                    Text(
                      widget.photo1.weight,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _textGrey,
                      ),
                    ),
                ],
              ),
            ),

            // VS badge
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'VS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),

            // Month 2 photo
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        widget.photo2.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: _cardBg,
                          child: const Icon(Icons.person_outline,
                              size: 48, color: _primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.photo2.date,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                  ),
                  if (widget.photo2.weight.isNotEmpty)
                    Text(
                      widget.photo2.weight,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _textGrey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressMetrics() {
    // Dummy metrics for UI demo
    final metrics = [
      {
        'label': 'Weight',
        'before': widget.photo1.weight.isNotEmpty ? widget.photo1.weight : '72 kg',
        'after': widget.photo2.weight.isNotEmpty ? widget.photo2.weight : '68 kg',
        'icon': Icons.monitor_weight_outlined,
        'color': const Color(0xFF92A3FD),
      },
      {
        'label': 'Waist',
        'before': '34"',
        'after': '32"',
        'icon': Icons.straighten,
        'color': const Color(0xFFC58BF2),
      },
      {
        'label': 'Body Progress',
        'before': 'Starting',
        'after': 'Improved',
        'icon': Icons.trending_up,
        'color': const Color(0xFF4ADEDE),
      },
    ];

    return Column(
      children: metrics.map((m) {
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: (m['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  m['icon'] as IconData,
                  color: m['color'] as Color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // Label
              Expanded(
                child: Text(
                  m['label'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _textDark,
                  ),
                ),
              ),
              // Before → After
              Text(
                '${m['before']} → ${m['after']}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: m['color'] as Color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // -- Statistics Tab ---------------------------------------------------------
  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Weight progress chart
          _buildSectionTitle('Weight Progress'),
          const SizedBox(height: 14),
          _buildWeightChart(),
          const SizedBox(height: 24),

          // Key stats card
          _buildKeyStatsCard(),
          const SizedBox(height: 24),

          // Progress bars
          _buildSectionTitle('Goal Progress'),
          const SizedBox(height: 14),
          _buildProgressBar(
              label: 'Lose Weight', value: 0.62, color: _primary),
          const SizedBox(height: 12),
          _buildProgressBar(
              label: 'Height Increase',
              value: 0.45,
              color: const Color(0xFFC58BF2)),
          const SizedBox(height: 12),
          _buildProgressBar(
              label: 'Muscle Mass',
              value: 0.55,
              color: const Color(0xFF4ADEDE)),
          const SizedBox(height: 12),
          _buildProgressBar(
              label: 'Abs',
              value: 0.38,
              color: const Color(0xFFFF7F7F)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _textDark,
      ),
    );
  }

  Widget _buildWeightChart() {
    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(16),
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
            'Weight (kg)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['May', 'Jun', 'Jul', 'Aug', 'Sep'];
                        final idx = value.toInt();
                        if (idx >= 0 && idx < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              labels[idx],
                              style: TextStyle(
                                fontSize: 9,
                                color:
                                    Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 24,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 72),
                      FlSpot(1, 70.5),
                      FlSpot(2, 70),
                      FlSpot(3, 69),
                      FlSpot(4, 68),
                    ],
                    isCurved: true,
                    color: Colors.white,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                        radius: 4,
                        color: Colors.white,
                        strokeWidth: 2,
                        strokeColor: const Color(0xFF92A3FD),
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ],
                minY: 65,
                maxY: 75,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          // Weight progress row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                label: 'Weight',
                value: '72 → 68 kg',
                icon: Icons.monitor_weight_outlined,
                color: _primary,
              ),
              // Vertical divider
              Container(width: 1, height: 50, color: const Color(0xFFDDDADA)),
              _buildStatItem(
                label: 'Height',
                value: '175 cm',
                icon: Icons.height,
                color: const Color(0xFFC58BF2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: const Color(0xFFDDDADA)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                label: 'Goal',
                value: 'Lose Weight',
                icon: Icons.flag_outlined,
                color: const Color(0xFF4ADEDE),
              ),
              Container(width: 1, height: 50, color: const Color(0xFFDDDADA)),
              _buildStatItem(
                label: 'Progress',
                value: '62%',
                icon: Icons.trending_up,
                color: const Color(0xFFFF7F7F),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: _textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar({
    required String label,
    required double value, // 0.0 to 1.0
    required Color color,
  }) {
    final percent = (value * 100).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _textDark,
              ),
            ),
            Text(
              '$percent%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
