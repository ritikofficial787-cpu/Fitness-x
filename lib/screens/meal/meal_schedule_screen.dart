// ─────────────────────────────────────────────────────────────────────────────
// meal_schedule_screen.dart
//
// Meal Schedule screen similar to the Workout Schedule screen.
// Shows:
//  - Month navigator
//  - Horizontal 7-day date selector
//  - Meals grouped by type: Breakfast, Lunch, Snacks, Dinner
//  - Today's Meal Nutrition progress bars at the bottom
//  - "+" FAB to go to Meal Planner to add a new meal
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/meal_schedule.dart';
import 'meal_schedule_details_screen.dart';

class MealScheduleScreen extends StatefulWidget {
  const MealScheduleScreen({super.key});

  @override
  State<MealScheduleScreen> createState() => _MealScheduleScreenState();
}

class _MealScheduleScreenState extends State<MealScheduleScreen> {
  // ── App colour palette ─────────────────────────────────────────────────
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);

  // ── Date state ─────────────────────────────────────────────────────────
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = now;
    _currentMonth = DateTime(now.year, now.month, 1);
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  List<DateTime> get _weekDates {
    final weekday = _selectedDate.weekday;
    final monday = _selectedDate.subtract(Duration(days: weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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

  /// Meals for the selected date
  List<MealScheduleEntry> get _mealsForSelectedDay =>
      mealScheduleList
          .where((m) => _isSameDay(m.date, _selectedDate))
          .toList()
        ..sort((a, b) {
          final aMin = a.time.hour * 60 + a.time.minute;
          final bMin = b.time.hour * 60 + b.time.minute;
          return aMin.compareTo(bMin);
        });

  /// Get meals of a specific type for the selected day
  List<MealScheduleEntry> _mealsOfType(String type) =>
      _mealsForSelectedDay.where((m) => m.mealType == type).toList();

  /// Total calories for selected day
  int get _totalCalories =>
      _mealsForSelectedDay.fold(0, (sum, m) => sum + m.calories);

  /// Total protein for selected day
  int get _totalProtein =>
      _mealsForSelectedDay.fold(0, (sum, m) => sum + m.protein);

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
                    _buildMonthNavigator(),
                    _buildDateRow(),
                    const SizedBox(height: 8),
                    // Meal sections grouped by type
                    ..._buildMealSections(),
                    // Today's nutrition summary
                    _buildNutritionSummary(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // "+" FAB to add a meal (goes back to open Meal Planner)
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
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
            'Meal Schedule',
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

  // ── Horizontal date row ─────────────────────────────────────────────────
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

  // ── Meal sections (Breakfast, Lunch, Snacks, Dinner) ───────────────────
  List<Widget> _buildMealSections() {
    const types = ['Breakfast', 'Lunch', 'Snacks', 'Dinner'];
    final allMeals = _mealsForSelectedDay;

    if (allMeals.isEmpty) {
      return [_buildEmptyState()];
    }

    List<Widget> sections = [];
    for (final type in types) {
      final meals = _mealsOfType(type);
      if (meals.isNotEmpty) {
        sections.add(_buildMealTypeSection(type, meals));
      }
    }
    return sections;
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.no_meals, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'No meals scheduled\nfor this day',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
            const SizedBox(height: 6),
            Text(
              'Tap a meal to schedule it!',
              style: TextStyle(fontSize: 12, color: Colors.grey[350]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeSection(String type, List<MealScheduleEntry> meals) {
    // Calculate total calories for this type
    final typeCalories = meals.fold(0, (sum, m) => sum + m.calories);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_mealTypeIcon(type),
                      size: 16, color: _mealTypeColor(type)),
                  const SizedBox(width: 6),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                ],
              ),
              Text(
                '${meals.length} meal${meals.length > 1 ? 's' : ''} • $typeCalories kcal',
                style:
                    const TextStyle(fontSize: 11, color: _textGrey),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Meal cards for this type
          ...meals.map((meal) => _buildScheduleCard(meal)),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(MealScheduleEntry entry) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MealScheduleDetailsScreen(entry: entry),
          ),
        );
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: entry.completed
              ? const LinearGradient(
                  colors: [Color(0xFFB0EDB0), Color(0xFFD4F5D4)])
              : LinearGradient(
                  colors: [
                    _primary.withValues(alpha: 0.85),
                    _primaryLight.withValues(alpha: 0.85),
                  ],
                ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // Time label
            Text(
              entry.formattedTime,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            // Vertical divider
            Container(
              width: 1,
              height: 30,
              color: Colors.white.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 12),
            // Meal name + calories
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.mealName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${entry.calories} kcal  •  ${entry.protein}g Protein',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            if (entry.completed)
              const Icon(Icons.check_circle,
                  color: Colors.white, size: 18),
          ],
        ),
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

  Color _mealTypeColor(String type) {
    switch (type) {
      case 'Breakfast':
        return const Color(0xFFFFA07A);
      case 'Lunch':
        return _primary;
      case 'Snacks':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF9B59B6);
    }
  }

  // ── Today's Nutrition Summary ───────────────────────────────────────────
  Widget _buildNutritionSummary() {
    final totalCal = _totalCalories;
    final totalProtein = _totalProtein;
    // Dummy targets
    const calTarget = 2000;
    const proteinTarget = 120;
    const carbsTarget = 250;
    const fatTarget = 65;
    const fiberTarget = 30;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today\'s Meal Nutrition',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 14),
          _buildNutritionBar(
              'Calories 🔥', totalCal, calTarget, 'kcal', _primary),
          _buildNutritionBar(
              'Protein 💪', totalProtein, proteinTarget, 'g', _primaryLight),
          _buildNutritionBar('Carbs 🌾', 160, carbsTarget, 'g',
              const Color(0xFFFFA07A)),
          _buildNutritionBar(
              'Fat 🧈', 42, fatTarget, 'g', const Color(0xFFFFD700)),
          _buildNutritionBar(
              'Fiber 🌿', 24, fiberTarget, 'g', const Color(0xFF4CAF50)),
        ],
      ),
    );
  }

  Widget _buildNutritionBar(
      String label, int current, int target, String unit, Color color) {
    final progress = (current / target).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(fontSize: 12, color: _textDark)),
              Text('$current / $target $unit',
                  style: const TextStyle(
                      fontSize: 11,
                      color: _textGrey,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
