// ─────────────────────────────────────────────────────────────────────────────
// add_meal_schedule_screen.dart
//
// Screen to schedule a meal by choosing:
//  - Meal type (Breakfast / Lunch / Snacks / Dinner)
//  - Date (Today / Tomorrow / custom date picker)
//  - Time (time picker)
// Saves to the in-memory mealScheduleList (no database).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/meal_model.dart';
import '../../models/meal_schedule.dart';

class AddMealScheduleScreen extends StatefulWidget {
  final MealModel meal;

  const AddMealScheduleScreen({super.key, required this.meal});

  @override
  State<AddMealScheduleScreen> createState() => _AddMealScheduleScreenState();
}

class _AddMealScheduleScreenState extends State<AddMealScheduleScreen> {
  // ── App colour palette ─────────────────────────────────────────────────
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // ── Form state ─────────────────────────────────────────────────────────
  String _selectedMealType = 'Lunch';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Snacks', 'Dinner'];

  // ── Helpers ────────────────────────────────────────────────────────────
  String get _formattedDate {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    if (_isSameDay(_selectedDate, now)) return 'Today';
    if (_isSameDay(_selectedDate, tomorrow)) return 'Tomorrow';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[_selectedDate.month]} ${_selectedDate.day}';
  }

  String get _formattedTime {
    final hour = _selectedTime.hourOfPeriod == 0
        ? 12
        : _selectedTime.hourOfPeriod;
    final minute = _selectedTime.minute.toString().padLeft(2, '0');
    final period = _selectedTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Meal preview card ─────────────────────────────
                    _buildMealPreviewCard(),
                    const SizedBox(height: 24),

                    // ── Meal type selection ───────────────────────────
                    _buildSectionLabel('Meal Type'),
                    const SizedBox(height: 12),
                    _buildMealTypeSelector(),
                    const SizedBox(height: 24),

                    // ── Date selection ────────────────────────────────
                    _buildSectionLabel('Date'),
                    const SizedBox(height: 12),
                    _buildDateSelector(),
                    const SizedBox(height: 24),

                    // ── Time selection ────────────────────────────────
                    _buildSectionLabel('Time'),
                    const SizedBox(height: 12),
                    _buildTimeSelector(),
                    const SizedBox(height: 32),

                    // ── Summary preview ───────────────────────────────
                    _buildSummaryCard(),
                    const SizedBox(height: 24),

                    // ── Save button ───────────────────────────────────
                    _buildSaveButton(),
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
            'Add To Schedule',
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

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: _textDark,
      ),
    );
  }

  // ── Meal preview card ──────────────────────────────────────────────────
  Widget _buildMealPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F0FE), Color(0xFFB8C8FF)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // Meal icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.restaurant, color: _primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.meal.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.meal.calories} kcal  •  ${widget.meal.protein}g Protein',
                  style: const TextStyle(fontSize: 12, color: _textGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Meal type selector ─────────────────────────────────────────────────
  Widget _buildMealTypeSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _mealTypes.map((type) {
        final isSelected = _selectedMealType == type;
        return GestureDetector(
          onTap: () => setState(() => _selectedMealType = type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(colors: [_primary, _primaryLight])
                  : null,
              color: isSelected ? null : _bgLight,
              borderRadius: BorderRadius.circular(14),
              border: isSelected
                  ? null
                  : Border.all(color: _cardBg, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _mealTypeIcon(type),
                  size: 16,
                  color: isSelected ? Colors.white : _textGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  type,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isSelected ? Colors.white : _textGrey,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _mealTypeIcon(String type) {
    switch (type) {
      case 'Breakfast':
        return Icons.wb_sunny_outlined;
      case 'Lunch':
        return Icons.restaurant_outlined;
      case 'Snacks':
        return Icons.eco_outlined;
      default:
        return Icons.nights_stay_outlined;
    }
  }

  // ── Date selector ──────────────────────────────────────────────────────
  Widget _buildDateSelector() {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    final quickDates = [
      {'label': 'Today', 'date': now},
      {'label': 'Tomorrow', 'date': tomorrow},
    ];

    return Row(
      children: [
        // Quick date chips
        ...quickDates.map((item) {
          final date = item['date'] as DateTime;
          final isSelected = _isSameDay(_selectedDate, date);
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [_primary, _primaryLight])
                    : null,
                color: isSelected ? null : _bgLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                item['label'] as String,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : _textGrey,
                ),
              ),
            ),
          );
        }),

        // Custom date picker button
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _bgLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 14, color: _textGrey),
                const SizedBox(width: 6),
                Text(
                  _formattedDate,
                  style: const TextStyle(fontSize: 12, color: _textGrey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: _primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // ── Time selector ──────────────────────────────────────────────────────
  Widget _buildTimeSelector() {
    return GestureDetector(
      onTap: _pickTime,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _bgLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [_primary, _primaryLight]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.access_time,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Time',
                  style: TextStyle(fontSize: 11, color: _textGrey),
                ),
                Text(
                  _formattedTime,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: _textGrey),
          ],
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: _primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // ── Summary card ───────────────────────────────────────────────────────
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Schedule Summary',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow('Meal', widget.meal.name),
          _summaryRow('Type', _selectedMealType),
          _summaryRow('Date', _formattedDate),
          _summaryRow('Time', _formattedTime),
          _summaryRow('Calories', '${widget.meal.calories} kcal'),
          _summaryRow('Protein', '${widget.meal.protein}g'),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: _textGrey)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _textDark)),
        ],
      ),
    );
  }

  // ── Save button ────────────────────────────────────────────────────────
  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _saveSchedule,
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
            'Save',
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

  // ── Save logic (in-memory only) ─────────────────────────────────────────
  void _saveSchedule() {
    final entry = MealScheduleEntry(
      mealName: widget.meal.name,
      mealType: _selectedMealType,
      date: _selectedDate,
      time: _selectedTime,
      calories: widget.meal.calories,
      protein: widget.meal.protein,
      completed: false,
    );

    mealScheduleList.add(entry);

    // Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${widget.meal.name} added to $_selectedMealType on $_formattedDate at $_formattedTime'),
        backgroundColor: _primary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Go back to Meal Details
    Navigator.pop(context);
  }
}
