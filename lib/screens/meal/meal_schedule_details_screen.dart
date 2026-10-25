// ─────────────────────────────────────────────────────────────────────────────
// meal_schedule_details_screen.dart
//
// Meal Schedule Details screen showing:
//  - Meal name, date/time, meal type
//  - Nutrition info
//  - "Mark as Done" button
// Local only – no database.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/meal_schedule.dart';

class MealScheduleDetailsScreen extends StatefulWidget {
  final MealScheduleEntry entry;

  const MealScheduleDetailsScreen({super.key, required this.entry});

  @override
  State<MealScheduleDetailsScreen> createState() =>
      _MealScheduleDetailsScreenState();
}

class _MealScheduleDetailsScreenState
    extends State<MealScheduleDetailsScreen> {
  // ── App colour palette ─────────────────────────────────────────────────
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed header
            _buildHeader(),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // ── Meal icon ─────────────────────────────────────
                    _buildMealIcon(entry),
                    const SizedBox(height: 20),

                    // ── Meal name ─────────────────────────────────────
                    Text(
                      entry.mealName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ── Date | Time | Type ────────────────────────────
                    Text(
                      '${entry.dateLabel}  •  ${entry.formattedTime}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: _textGrey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_primary, _primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        entry.mealType,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Nutrition grid ────────────────────────────────
                    _buildNutritionGrid(entry),
                    const SizedBox(height: 28),

                    // ── Status card ───────────────────────────────────
                    _buildStatusCard(entry),
                    const SizedBox(height: 28),

                    // ── Mark as Done button ───────────────────────────
                    if (!entry.completed) _buildMarkDoneButton(entry),

                    if (entry.completed)
                      _buildCompletedBadge(),

                    const SizedBox(height: 20),
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
            'Meal Schedule',
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

  // ── Meal Icon (large coloured circle) ──────────────────────────────────
  Widget _buildMealIcon(MealScheduleEntry entry) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: entry.completed
            ? const LinearGradient(
                colors: [Color(0xFF66BB6A), Color(0xFF81C784)])
            : const LinearGradient(colors: [_primary, _primaryLight]),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (entry.completed
                    ? const Color(0xFF66BB6A)
                    : _primary)
                .withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        entry.completed ? Icons.check : _mealTypeIcon(entry.mealType),
        color: Colors.white,
        size: 42,
      ),
    );
  }

  IconData _mealTypeIcon(String type) {
    switch (type) {
      case 'Breakfast':
        return Icons.wb_sunny_outlined;
      case 'Lunch':
        return Icons.restaurant_outlined;
      case 'Snacks':
        return Icons.apple_outlined;
      default:
        return Icons.nights_stay_outlined;
    }
  }

  // ── Nutrition Grid ─────────────────────────────────────────────────────
  Widget _buildNutritionGrid(MealScheduleEntry entry) {
    final items = [
      {
        'label': 'Calories',
        'value': '${entry.calories}',
        'unit': 'kcal',
        'emoji': '🔥',
      },
      {
        'label': 'Protein',
        'value': '${entry.protein}',
        'unit': 'g',
        'emoji': '💪',
      },
    ];

    return Row(
      children: items.map((item) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  item['emoji'] as String,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  item['value'] as String,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _primary,
                  ),
                ),
                Text(
                  '${item['unit']}',
                  style: const TextStyle(fontSize: 11, color: _textGrey),
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Status card ────────────────────────────────────────────────────────
  Widget _buildStatusCard(MealScheduleEntry entry) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bgLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _statusRow(
              Icons.restaurant_outlined, 'Meal', entry.mealName),
          const Divider(height: 20),
          _statusRow(Icons.category_outlined, 'Type', entry.mealType),
          const Divider(height: 20),
          _statusRow(
              Icons.calendar_today_outlined, 'Date', entry.dateLabel),
          const Divider(height: 20),
          _statusRow(Icons.access_time, 'Time', entry.formattedTime),
          const Divider(height: 20),
          _statusRow(
            Icons.check_circle_outline,
            'Status',
            entry.completed ? '✓ Completed' : 'Pending',
          ),
        ],
      ),
    );
  }

  Widget _statusRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: _primary),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(fontSize: 13, color: _textGrey)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  // ── Mark as Done button ─────────────────────────────────────────────────
  Widget _buildMarkDoneButton(MealScheduleEntry entry) {
    return GestureDetector(
      onTap: () {
        setState(() => entry.completed = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${entry.mealName} marked as done! ✓'),
            backgroundColor: const Color(0xFF66BB6A),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_primary, _primaryLight],
          ),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: _primary.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Mark as Done',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ── Completed badge ─────────────────────────────────────────────────────
  Widget _buildCompletedBadge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            'Completed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
