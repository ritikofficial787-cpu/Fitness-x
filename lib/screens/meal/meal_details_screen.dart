// ─────────────────────────────────────────────────────────────────────────────
// meal_details_screen.dart
//
// Meal Details screen showing:
//  - Meal image
//  - Meal name + description
//  - Nutrition chips (Calories, Protein, Carbs, Fat, Fiber)
//  - Ingredients list
//  - Step-by-step cooking instructions
//  - Favourite toggle
//  - "Add To Meal Schedule" button
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/meal_model.dart';
import 'add_meal_schedule_screen.dart';

class MealDetailsScreen extends StatefulWidget {
  final MealModel meal;

  const MealDetailsScreen({super.key, required this.meal});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  // ── App colour palette ─────────────────────────────────────────────────
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // Local favourite state (no database)
  bool _isFavourite = false;

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Meal Image ──────────────────────────────────────
                    _buildMealImage(meal),
                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Meal Name + Category ────────────────────
                          _buildMealTitle(meal),
                          const SizedBox(height: 16),

                          // ── Nutrition Chips ──────────────────────────
                          _buildSectionLabel('Nutrition'),
                          const SizedBox(height: 10),
                          _buildNutritionChips(meal),
                          const SizedBox(height: 20),

                          // ── Description ──────────────────────────────
                          _buildSectionLabel('Description'),
                          const SizedBox(height: 8),
                          Text(
                            meal.description,
                            style: const TextStyle(
                              fontSize: 13,
                              color: _textGrey,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Ingredients ──────────────────────────────
                          _buildSectionLabel(
                              'Ingredients That You Will Need'),
                          const SizedBox(height: 12),
                          _buildIngredientsList(meal),
                          const SizedBox(height: 20),

                          // ── Cooking Steps ────────────────────────────
                          _buildSectionLabel(
                              'Step by Step  (${meal.steps.length} Steps)'),
                          const SizedBox(height: 12),
                          _buildCookingSteps(meal),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Add To Meal Schedule button ─────────────────────────────
            _buildAddToScheduleButton(meal),
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
          // Back
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
            'Meal Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          // Favourite heart button
          GestureDetector(
            onTap: () => setState(() => _isFavourite = !_isFavourite),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _bgLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _isFavourite ? Icons.favorite : Icons.favorite_border,
                size: 18,
                color: _isFavourite ? const Color(0xFFFF6B6B) : _textGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Meal Image ─────────────────────────────────────────────────────────
  Widget _buildMealImage(MealModel meal) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F0FE), Color(0xFFB8C8FF)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          meal.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.restaurant, color: _primary, size: 60),
                const SizedBox(height: 8),
                Text(
                  meal.name,
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Meal Title ─────────────────────────────────────────────────────────
  Widget _buildMealTitle(MealModel meal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                meal.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_primary, _primaryLight]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                meal.category,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.timer_outlined, size: 14, color: _textGrey),
            const SizedBox(width: 4),
            Text(
              meal.preparationTime,
              style: const TextStyle(fontSize: 12, color: _textGrey),
            ),
            const SizedBox(width: 14),
            const Icon(Icons.bar_chart, size: 14, color: _textGrey),
            const SizedBox(width: 4),
            Text(
              meal.difficulty,
              style: const TextStyle(fontSize: 12, color: _textGrey),
            ),
          ],
        ),
      ],
    );
  }

  // ── Section label ──────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: _textDark,
      ),
    );
  }

  // ── Nutrition Chips ────────────────────────────────────────────────────
  Widget _buildNutritionChips(MealModel meal) {
    final items = [
      {'label': 'Calories', 'value': '${meal.calories}', 'unit': 'kcal'},
      {'label': 'Protein', 'value': '${meal.protein}', 'unit': 'g'},
      {'label': 'Carbs', 'value': '${meal.carbs}', 'unit': 'g'},
      {'label': 'Fat', 'value': '${meal.fat}', 'unit': 'g'},
      {'label': 'Fiber', 'value': '${meal.fiber}', 'unit': 'g'},
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        return Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                item['value'] as String,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${item['label']} (${item['unit']})',
                style: const TextStyle(
                  fontSize: 10,
                  color: _textGrey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Ingredients List ───────────────────────────────────────────────────
  Widget _buildIngredientsList(MealModel meal) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: meal.ingredients.length,
      itemBuilder: (_, index) {
        // Split "ingredient - quantity" on " - "
        final parts = meal.ingredients[index].split(' - ');
        final name = parts[0];
        final qty = parts.length > 1 ? parts[1] : '';

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_dining, color: _primary, size: 22),
              const SizedBox(height: 5),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              if (qty.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  qty,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9,
                    color: _textGrey,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // ── Cooking Steps (vertical stepper) ───────────────────────────────────
  Widget _buildCookingSteps(MealModel meal) {
    return Column(
      children: List.generate(meal.steps.length, (index) {
        final isLast = index == meal.steps.length - 1;
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step number column with connecting line
              Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_primary, _primaryLight],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: _cardBg,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              // Step content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${index + 1}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal.steps[index],
                        style: const TextStyle(
                          fontSize: 12,
                          color: _textGrey,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ── Add To Meal Schedule button ─────────────────────────────────────────
  Widget _buildAddToScheduleButton(MealModel meal) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddMealScheduleScreen(meal: meal),
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
              'Add To Meal Schedule',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
