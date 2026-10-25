// ─────────────────────────────────────────────────────────────────────────────
// meal_planner_screen.dart
//
// Main Meal Planner / Meal Tracker screen showing:
//  - Weekly nutrition chart
//  - Daily Meal Schedule row
//  - Today's Meals section
//  - Category chips (horizontal)
//  - Recommendation for Diet list
//  - Popular Meals list
//  - Search field
// All data is local dummy data – no database, no Firebase.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/meal_model.dart';
import '../../models/meal_schedule.dart';
import 'meal_details_screen.dart';
import 'meal_schedule_screen.dart';

class MealPlannerScreen extends StatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  State<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends State<MealPlannerScreen> {
  // ── App colour palette (same as the rest of the app) ───────────────────
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // ── State ──────────────────────────────────────────────────────────────
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // ── Today's Nutrition (dummy local data) ───────────────────────────────
  final int _calCurrent = 1280;
  final int _calTarget = 2000;
  final int _proteinCurrent = 72;
  final int _proteinTarget = 120;
  final int _carbsCurrent = 160;
  final int _carbsTarget = 250;
  final int _fatCurrent = 42;
  final int _fatTarget = 65;
  final int _fiberCurrent = 24;
  final int _fiberTarget = 30;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Filtered meal list based on category + search ─────────────────────
  List<MealModel> get _filteredMeals {
    List<MealModel> meals = allMeals;

    // Filter by category
    if (_selectedCategory != 'All') {
      meals = meals
          .where((m) =>
              m.category == _selectedCategory ||
              m.tags.contains(_selectedCategory))
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      meals = meals
          .where((m) =>
              m.name.toLowerCase().contains(q) ||
              m.category.toLowerCase().contains(q) ||
              m.tags.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }

    return meals;
  }

  // ── Today's meals from schedule ────────────────────────────────────────
  List<MealScheduleEntry> get _todaysMeals =>
      mealScheduleList.where((m) => m.isToday).toList();

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ── 1. Meal Nutritions (weekly chart) ────────────────
                    _buildNutritionChart(),
                    const SizedBox(height: 20),

                    // ── 2. Daily Meal Schedule row ───────────────────────
                    _buildDailyScheduleRow(),
                    const SizedBox(height: 20),

                    // ── 3. Today's Meals ─────────────────────────────────
                    _buildTodaysMeals(),
                    const SizedBox(height: 20),

                    // ── 4. Search ────────────────────────────────────────
                    _buildSearchField(),
                    const SizedBox(height: 16),

                    // ── 5. Categories ────────────────────────────────────
                    _buildSectionTitle('Categories'),
                    const SizedBox(height: 12),
                    _buildCategoryChips(),
                    const SizedBox(height: 20),

                    // ── 6. Recommendation for Diet ───────────────────────
                    _buildSectionTitle('Recommendation for Diet'),
                    const SizedBox(height: 12),
                    _buildMealList(_filteredMeals.take(6).toList()),
                    const SizedBox(height: 20),

                    // ── 7. Popular Meals ─────────────────────────────────
                    _buildSectionTitle('Popular Meals'),
                    const SizedBox(height: 12),
                    _buildPopularMeals(),
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
          // Back button
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
            'Meal Planner',
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

  // ── Section title helper ────────────────────────────────────────────────
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

  // ── 1. Weekly Nutrition Chart ───────────────────────────────────────────
  Widget _buildNutritionChart() {
    // Dummy weekly calorie values (Sun-Sat)
    final List<double> weekData = [1400, 1800, 1600, 2000, 1750, 1900, 1280];
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      width: double.infinity,
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
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Meal Nutritions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Weekly',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bar chart
          SizedBox(
            height: 90,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2200,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, _) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          days[idx],
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
                barGroups: List.generate(7, (i) {
                  final isToday = i == 6; // Saturday = "today" dummy
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: weekData[i],
                        color: isToday ? Colors.white : Colors.white38,
                        width: 14,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 14),
          // Today's nutrition progress
          _buildTodayNutritionProgress(),
        ],
      ),
    );
  }

  Widget _buildTodayNutritionProgress() {
    final items = [
      {
        'label': 'Calories',
        'cur': _calCurrent,
        'max': _calTarget,
        'unit': 'kcal',
      },
      {
        'label': 'Protein',
        'cur': _proteinCurrent,
        'max': _proteinTarget,
        'unit': 'g',
      },
      {
        'label': 'Carbs',
        'cur': _carbsCurrent,
        'max': _carbsTarget,
        'unit': 'g',
      },
      {'label': 'Fat', 'cur': _fatCurrent, 'max': _fatTarget, 'unit': 'g'},
      {
        'label': 'Fiber',
        'cur': _fiberCurrent,
        'max': _fiberTarget,
        'unit': 'g',
      },
    ];

    return Column(
      children: items.map((item) {
        final cur = (item['cur'] as int).toDouble();
        final max = (item['max'] as int).toDouble();
        final progress = (cur / max).clamp(0.0, 1.0);
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                child: Text(
                  item['label'] as String,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${item['cur']}/${item['max']}${item['unit']}',
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── 2. Daily Meal Schedule row ─────────────────────────────────────────
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
            'Daily Meal Schedule',
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
                    builder: (_) => const MealScheduleScreen()),
              );
              setState(() {});
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
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

  // ── 3. Today's Meals ───────────────────────────────────────────────────
  Widget _buildTodaysMeals() {
    final todayMeals = _todaysMeals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s Meals',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MealScheduleScreen()),
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
        if (todayMeals.isEmpty)
          _buildEmptyHint('No meals scheduled for today')
        else
          ...todayMeals.map((entry) => _buildTodayMealCard(entry)),
      ],
    );
  }

  Widget _buildTodayMealCard(MealScheduleEntry entry) {
    // Map meal type to icon
    IconData icon;
    Color iconColor;
    switch (entry.mealType) {
      case 'Breakfast':
        icon = Icons.wb_sunny_outlined;
        iconColor = const Color(0xFFFFA07A);
        break;
      case 'Lunch':
        icon = Icons.restaurant_outlined;
        iconColor = _primary;
        break;
      case 'Snacks':
        icon = Icons.eco_outlined;
        iconColor = const Color(0xFF4CAF50);
        break;
      default: // Dinner
        icon = Icons.nights_stay_outlined;
        iconColor = const Color(0xFF9B59B6);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
          // Meal type icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.mealType,
                  style: const TextStyle(
                    fontSize: 10,
                    color: _textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.mealName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.calories} kcal  •  ${entry.formattedTime}',
                  style: const TextStyle(fontSize: 11, color: _textGrey),
                ),
              ],
            ),
          ),
          // Completed badge or pending dot
          if (entry.completed)
            const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20)
          else
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: _primary,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyHint(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _bgLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.restaurant_menu_outlined,
              size: 18, color: _textGrey),
          const SizedBox(width: 10),
          Text(message,
              style: const TextStyle(fontSize: 12, color: _textGrey)),
        ],
      ),
    );
  }

  // ── 4. Search Field ─────────────────────────────────────────────────────
  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: _bgLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchQuery = value),
        style: const TextStyle(fontSize: 13, color: _textDark),
        decoration: InputDecoration(
          hintText: 'Search meals...',
          hintStyle: const TextStyle(fontSize: 13, color: _textGrey),
          prefixIcon: const Icon(Icons.search, color: _textGrey, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  child:
                      const Icon(Icons.close, color: _textGrey, size: 18),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ── 5. Category chips ──────────────────────────────────────────────────
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mealCategories.length,
        itemBuilder: (_, index) {
          final cat = mealCategories[index];
          final isSelected = _selectedCategory == cat.name;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat.name),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [_primary, _primaryLight],
                      )
                    : null,
                color: isSelected ? null : _bgLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${cat.emoji} ${cat.name}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : _textGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── 6. Meal list (Recommendation for Diet) ─────────────────────────────
  Widget _buildMealList(List<MealModel> meals) {
    if (meals.isEmpty) {
      return _buildEmptyHint('No meals found. Try a different search or category.');
    }

    return Column(
      children: meals.map((meal) => _buildMealCard(meal)).toList(),
    );
  }

  Widget _buildMealCard(MealModel meal) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MealDetailsScreen(meal: meal),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
            // Meal image / placeholder
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: Image.asset(
                meal.imagePath,
                width: 90,
                height: 95,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) => Container(
                  width: 90,
                  height: 95,
                  color: _cardBg,
                  child: const Icon(Icons.restaurant,
                      color: _primary, size: 28),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${meal.calories} kcal  •  ${meal.protein}g Protein',
                      style: const TextStyle(
                          fontSize: 11, color: _textGrey),
                    ),
                    const SizedBox(height: 8),
                    // Difficulty + time badges
                    Row(
                      children: [
                        _buildBadge(meal.difficulty, _badgeColor(meal.difficulty)),
                        const SizedBox(width: 6),
                        _buildBadge(meal.preparationTime, _textGrey),
                      ],
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

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _badgeColor(String difficulty) {
    switch (difficulty) {
      case 'Hard':
        return const Color(0xFFFF7676);
      case 'Medium':
        return const Color(0xFFFFA07A);
      default:
        return _primary;
    }
  }

  // ── 7. Popular Meals (horizontal scroll cards) ─────────────────────────
  Widget _buildPopularMeals() {
    // Show top 6 meals as horizontal scroll
    final popularMeals = allMeals.take(6).toList();

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularMeals.length,
        itemBuilder: (_, index) {
          final meal = popularMeals[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailsScreen(meal: meal),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    child: Image.asset(
                      meal.imagePath,
                      height: 90,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => Container(
                        height: 90,
                        color: _cardBg,
                        child: const Icon(Icons.restaurant,
                            color: _primary, size: 28),
                      ),
                    ),
                  ),
                  // Info
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${meal.calories} kcal',
                          style: const TextStyle(
                              fontSize: 10, color: _textGrey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          meal.difficulty,
                          style: TextStyle(
                            fontSize: 9,
                            color: _badgeColor(meal.difficulty),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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
}
