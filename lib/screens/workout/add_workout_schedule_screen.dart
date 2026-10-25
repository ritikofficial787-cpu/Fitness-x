// ─────────────────────────────────────────────────────────────────────────────
// add_workout_schedule_screen.dart
//
// Screen for adding a new scheduled workout.
// Lets the user pick: date, time, workout, difficulty, reps, weight.
// On Save the new WorkoutSchedule is appended to the global scheduleList.
// No database – data is local for this app session only.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/workout_model.dart';
import '../../models/workout_schedule.dart';

class AddWorkoutScheduleScreen extends StatefulWidget {
  const AddWorkoutScheduleScreen({super.key});

  @override
  State<AddWorkoutScheduleScreen> createState() =>
      _AddWorkoutScheduleScreenState();
}

class _AddWorkoutScheduleScreenState extends State<AddWorkoutScheduleScreen> {
  // App colour palette – same as the rest of the app
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // ── Form state fields ────────────────────────────────────────────────────
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  WorkoutModel? _selectedWorkout;
  String _difficulty = 'Beginner';
  int _repetitions = 10;
  String _weight = 'No Weight';

  // Options for pickers
  final List<String> _difficulties = ['Beginner', 'Intermediate', 'Advanced'];
  final List<int> _repOptions = [5, 10, 15, 20, 25, 30, 40, 50];
  final List<String> _weightOptions = [
    'No Weight', '2 kg', '5 kg', '10 kg', '15 kg', '20 kg',
  ];

  // The Save button is enabled only when all required fields are filled
  bool get _canSave =>
      _selectedDate != null &&
      _selectedTime != null &&
      _selectedWorkout != null;

  // ── Helpers ──────────────────────────────────────────────────────────────
  String get _formattedDate {
    if (_selectedDate == null) return 'Select Date';
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const weekdays = [
      '', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
    ];
    return '${weekdays[_selectedDate!.weekday]}, '
        '${_selectedDate!.day} ${months[_selectedDate!.month]} '
        '${_selectedDate!.year}';
  }

  String get _formattedTime {
    if (_selectedTime == null) return 'Select Time';
    final hour = _selectedTime!.hourOfPeriod == 0
        ? 12
        : _selectedTime!.hourOfPeriod;
    final minute = _selectedTime!.minute.toString().padLeft(2, '0');
    final period = _selectedTime!.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildDateSection(),
                    const SizedBox(height: 20),
                    _buildTimeSection(),
                    const SizedBox(height: 28),
                    _buildDetailsSection(),
                    const SizedBox(height: 36),
                    _buildSaveButton(),
                    const SizedBox(height: 24),
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
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
                color: _textDark,
              ),
            ),
          ),
          const Text(
            'Add Schedule',
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

  // ── Date Section ────────────────────────────────────────────────────────
  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _bgLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: _primary),
                const SizedBox(width: 10),
                Text(
                  _formattedDate,
                  style: TextStyle(
                    fontSize: 14,
                    color: _selectedDate == null ? _textGrey : _textDark,
                    fontWeight: _selectedDate == null
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Time Section ────────────────────────────────────────────────────────
  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickTime,
          child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _bgLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: _primary),
                const SizedBox(width: 10),
                Text(
                  _formattedTime,
                  style: TextStyle(
                    fontSize: 14,
                    color: _selectedTime == null ? _textGrey : _textDark,
                    fontWeight: _selectedTime == null
                        ? FontWeight.normal
                        : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Details Workout Section ─────────────────────────────────────────────
  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Details Workout',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: _bgLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Choose Workout
              _buildOptionRow(
                icon: Icons.fitness_center,
                label: 'Choose Workout',
                value: _selectedWorkout?.name,
                onTap: _showWorkoutPicker,
              ),
              _divider(),
              // Difficulty
              _buildOptionRow(
                icon: Icons.bar_chart,
                label: 'Difficulty',
                value: _difficulty,
                onTap: _showDifficultyPicker,
              ),
              _divider(),
              // Custom Repetitions
              _buildOptionRow(
                icon: Icons.repeat,
                label: 'Custom Repetitions',
                value: '$_repetitions reps',
                onTap: _showRepetitionsPicker,
              ),
              _divider(),
              // Custom Weights
              _buildOptionRow(
                icon: Icons.monitor_weight_outlined,
                label: 'Custom Weights',
                value: _weight,
                onTap: _showWeightPicker,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => const Divider(
        height: 1,
        indent: 52,
        color: Color(0xFFEEEEEE),
      );

  Widget _buildOptionRow({
    required IconData icon,
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: _primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: _textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: 12,
                color: value != null ? _primary : _textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 18, color: _textGrey),
          ],
        ),
      ),
    );
  }

  // ── Save Button ─────────────────────────────────────────────────────────
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: _canSave
              ? const LinearGradient(colors: [_primary, _primaryLight])
              : const LinearGradient(
                  colors: [Color(0xFFD0D0D0), Color(0xFFE0E0E0)]),
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            if (_canSave)
              BoxShadow(
                color: _primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _canSave ? _saveSchedule : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          child: Text(
            'Save',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _canSave ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  // ── Date Picker ─────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        // Apply app's colour to the date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  // ── Time Picker ─────────────────────────────────────────────────────────
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // ── Workout Picker (bottom sheet list of all 12 workouts) ───────────────
  void _showWorkoutPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Choose Workout',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 12),
              // Scrollable list
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: allWorkouts.length,
                  itemBuilder: (_, index) {
                    final w = allWorkouts[index];
                    final isSelected = _selectedWorkout?.name == w.name;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedWorkout = w);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? _cardBg : _bgLight,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(color: _primary, width: 1.5)
                              : null,
                        ),
                        child: Row(
                          children: [
                            // Workout image thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                w.imagePath,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 40,
                                  height: 40,
                                  color: _cardBg,
                                  child: const Icon(Icons.fitness_center,
                                      color: _primary, size: 20),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    w.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _textDark,
                                    ),
                                  ),
                                  Text(
                                    w.duration,
                                    style: const TextStyle(
                                        fontSize: 11, color: _textGrey),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle,
                                  color: _primary, size: 18),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Difficulty Picker ───────────────────────────────────────────────────
  void _showDifficultyPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Select Difficulty',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 12),
              ..._difficulties.map((d) {
                final isSelected = _difficulty == d;
                return GestureDetector(
                  onTap: () {
                    setState(() => _difficulty = d);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? _cardBg : _bgLight,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: _primary, width: 1.5)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          d,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? _primary : _textDark,
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check, color: _primary, size: 18),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // ── Repetitions Picker ──────────────────────────────────────────────────
  void _showRepetitionsPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        // Local state inside the sheet using a StatefulBuilder
        int tempReps = _repetitions;
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Text(
                    'Custom Repetitions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // +/- control
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _circleButton(
                        icon: Icons.remove,
                        onTap: () {
                          if (tempReps > 5) {
                            setLocal(() => tempReps -= 5);
                          }
                        },
                      ),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          Text(
                            '$tempReps',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: _textDark,
                            ),
                          ),
                          const Text(
                            'reps',
                            style: TextStyle(fontSize: 12, color: _textGrey),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      _circleButton(
                        icon: Icons.add,
                        onTap: () {
                          if (tempReps < 100) {
                            setLocal(() => tempReps += 5);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Quick-select chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _repOptions.map((r) {
                      final isSel = tempReps == r;
                      return GestureDetector(
                        onTap: () => setLocal(() => tempReps = r),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? _primary : _bgLight,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            '$r',
                            style: TextStyle(
                              fontSize: 13,
                              color: isSel ? Colors.white : _textDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_primary, _primaryLight]),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _repetitions = tempReps);
                          Navigator.pop(ctx);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99)),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Weight Picker ───────────────────────────────────────────────────────
  void _showWeightPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Custom Weights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 12),
              ..._weightOptions.map((w) {
                final isSelected = _weight == w;
                return GestureDetector(
                  onTap: () {
                    setState(() => _weight = w);
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? _cardBg : _bgLight,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: _primary, width: 1.5)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          w,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected ? _primary : _textDark,
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check, color: _primary, size: 18),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // ── Reusable circle +/- button ──────────────────────────────────────────
  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _cardBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: _primary),
      ),
    );
  }

  // ── Save Schedule ───────────────────────────────────────────────────────
  void _saveSchedule() {
    // Build a new WorkoutSchedule and add it to the global list
    final newEntry = WorkoutSchedule(
      workoutName: _selectedWorkout!.name,
      imagePath: _selectedWorkout!.imagePath,
      date: _selectedDate!,
      time: _selectedTime!,
      difficulty: _difficulty,
      repetitions: _repetitions,
      weight: _weight,
    );

    // Add to the shared global list (no database needed)
    scheduleList.add(newEntry);

    // Go back to the schedule screen
    Navigator.pop(context);
  }
}
