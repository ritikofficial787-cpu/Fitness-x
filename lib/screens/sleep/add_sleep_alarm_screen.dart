// ─────────────────────────────────────────────────────────────────────────────
// add_sleep_alarm_screen.dart
//
// Screen to create a new sleep schedule entry.
// Options:
//  - Bedtime (time picker)
//  - Hours of Sleep (dropdown)
//  - Repeat (Every Day / Mon-Fri / Weekends / Custom)
//  - Vibrate toggle
//  - Alarm Label
// Saves to the in-memory sleepScheduleList (no database).
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../../models/sleep_model.dart';

class AddSleepAlarmScreen extends StatefulWidget {
  const AddSleepAlarmScreen({super.key});

  @override
  State<AddSleepAlarmScreen> createState() => _AddSleepAlarmScreenState();
}

class _AddSleepAlarmScreenState extends State<AddSleepAlarmScreen> {
  // ── App colour palette ─────────────────────────────────────────────────
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // ── Form state ─────────────────────────────────────────────────────────
  TimeOfDay _bedtime = const TimeOfDay(hour: 21, minute: 0);
  String _sleepDuration = '8 hours';
  String _repeat = 'Every Day';
  bool _vibrate = true;
  String _label = 'Morning Alarm';
  final String _sound = 'Default Alarm';

  // Custom day selection (for 'Custom' repeat)
  final List<String> _allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final Set<String> _selectedCustomDays = {'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};

  final List<String> _sleepOptions = [
    '6 hours',
    '7 hours',
    '8 hours',
    '8 hours 30 minutes',
    '9 hours',
  ];

  final List<String> _repeatOptions = [
    'Every Day',
    'Mon - Fri',
    'Weekends',
    'Custom',
  ];

  // ── Computed wake-up time ───────────────────────────────────────────────
  TimeOfDay get _wakeTime {
    int bedMinutes = _bedtime.hour * 60 + _bedtime.minute;
    int sleepMinutes = _parseDurationToMinutes(_sleepDuration);
    int wakeMinutes = (bedMinutes + sleepMinutes) % (24 * 60);
    return TimeOfDay(hour: wakeMinutes ~/ 60, minute: wakeMinutes % 60);
  }

  int _parseDurationToMinutes(String duration) {
    if (duration == '6 hours') return 6 * 60;
    if (duration == '7 hours') return 7 * 60;
    if (duration == '8 hours') return 8 * 60;
    if (duration == '8 hours 30 minutes') return 8 * 60 + 30;
    if (duration == '9 hours') return 9 * 60;
    return 8 * 60;
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Bedtime ───────────────────────────────────────
                    _buildRowOption(
                      icon: Icons.bedtime_outlined,
                      label: 'Bedtime',
                      value: _formatTime(_bedtime),
                      onTap: _pickBedtime,
                    ),
                    _buildDivider(),

                    // ── Hours of Sleep ────────────────────────────────
                    _buildRowOption(
                      icon: Icons.access_time_outlined,
                      label: 'Hours of Sleep',
                      value: _sleepDuration,
                      onTap: _pickSleepDuration,
                    ),
                    _buildDivider(),

                    // ── Repeat ────────────────────────────────────────
                    _buildRowOption(
                      icon: Icons.repeat_outlined,
                      label: 'Repeat',
                      value: _repeat,
                      onTap: _pickRepeat,
                    ),
                    _buildDivider(),

                    // ── Custom days (shown only for 'Custom' repeat) ──
                    if (_repeat == 'Custom') ...[
                      _buildCustomDays(),
                      _buildDivider(),
                    ],

                    // ── Vibrate toggle ────────────────────────────────
                    _buildToggleOption(
                      icon: Icons.vibration,
                      label: 'Vibrate When Alarm Sounds',
                      value: _vibrate,
                      onChanged: (val) => setState(() => _vibrate = val),
                    ),
                    _buildDivider(),

                    // ── Alarm Label ───────────────────────────────────
                    _buildRowOption(
                      icon: Icons.label_outline,
                      label: 'Alarm Label',
                      value: _label,
                      onTap: _pickLabel,
                    ),
                    _buildDivider(),

                    // ── Sound ─────────────────────────────────────────
                    _buildRowOption(
                      icon: Icons.music_note_outlined,
                      label: 'Sound',
                      value: _sound,
                      onTap: null, // simple — no extra screen
                    ),

                    const SizedBox(height: 30),

                    // ── Wake-up time preview ──────────────────────────
                    _buildWakeUpPreview(),
                    const SizedBox(height: 30),

                    // ── Add button ────────────────────────────────────
                    _buildAddButton(),
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
            'Add Alarm',
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

  // ── Row option row (e.g. Bedtime, Hours of Sleep) ──────────────────────
  Widget _buildRowOption({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: _textGrey),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: _textDark,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: _textGrey,
              ),
            ),
            const SizedBox(width: 6),
            if (onTap != null)
              const Icon(Icons.chevron_right, size: 18, color: _textGrey),
          ],
        ),
      ),
    );
  }

  // ── Toggle option row ───────────────────────────────────────────────────
  Widget _buildToggleOption({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: _textGrey),
          const SizedBox(width: 14),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: _textDark,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Switch(
            value: value,
            activeThumbColor: _primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFE8F0FE));
  }

  // ── Custom days selector ────────────────────────────────────────────────
  Widget _buildCustomDays() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _allDays.map((day) {
          final isSelected = _selectedCustomDays.contains(day);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedCustomDays.remove(day);
                } else {
                  _selectedCustomDays.add(day);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [_primary, _primaryLight])
                    : null,
                color: isSelected ? null : _bgLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : _textGrey,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Wake-up time preview ────────────────────────────────────────────────
  Widget _buildWakeUpPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny_outlined, color: _primary, size: 24),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'You will wake up at',
                style: TextStyle(fontSize: 12, color: _textGrey),
              ),
              Text(
                _formatTime(_wakeTime),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                ),
              ),
              Text(
                'after $_sleepDuration of sleep',
                style: const TextStyle(fontSize: 11, color: _textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Add button ──────────────────────────────────────────────────────────
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _saveAlarm,
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
            'Add',
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

  // ── Pickers ─────────────────────────────────────────────────────────────

  Future<void> _pickBedtime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _bedtime,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _bedtime = picked);
  }

  Future<void> _pickSleepDuration() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Hours of Sleep',
            style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        children: _sleepOptions.map((opt) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, opt),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                opt,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      opt == _sleepDuration ? _primary : _textDark,
                  fontWeight: opt == _sleepDuration
                      ? FontWeight.bold
                      : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
    if (result != null) setState(() => _sleepDuration = result);
  }

  Future<void> _pickRepeat() async {
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Repeat',
            style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        children: _repeatOptions.map((opt) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, opt),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                opt,
                style: TextStyle(
                  fontSize: 14,
                  color: opt == _repeat ? _primary : _textDark,
                  fontWeight:
                      opt == _repeat ? FontWeight.bold : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
    if (result != null) setState(() => _repeat = result);
  }

  Future<void> _pickLabel() async {
    final controller = TextEditingController(text: _label);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Alarm Label'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g. Morning Workout',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text('OK',
                style: const TextStyle(color: _primary)),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      setState(() => _label = result);
    }
  }

  // ── Save alarm ──────────────────────────────────────────────────────────
  void _saveAlarm() {
    final entry = SleepSchedule(
      label: _label,
      bedtime: _bedtime,
      alarmTime: _wakeTime,
      sleepDuration: _sleepDuration,
      repeat: _repeat == 'Custom'
          ? _selectedCustomDays.join(', ')
          : _repeat,
      vibrate: _vibrate,
      enabled: true,
    );

    sleepScheduleList.add(entry);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Alarm set for ${entry.formattedAlarmTime}  •  $_sleepDuration'),
        backgroundColor: _primary,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Navigator.pop(context);
  }
}
