// ─────────────────────────────────────────────────────────────────────────────
// alarm_ringing_screen.dart
//
// Shown when the alarm triggers.
// Displays: Good Morning!, alarm time, STOP ALARM button.
//
// NOTE:
// Full background/locked-screen alarm support can be added later
// using a proper local notification/alarm solution.
// This implementation works when the Flutter app is in the foreground.
//
// AUDIO:
// Add your alarm sound file here: assets/audio/alarm.mp3
// If the file does not exist, the app uses vibration as a fallback.
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class AlarmRingingScreen extends StatefulWidget {
  /// The formatted alarm time string, e.g. "05:10 AM"
  final String alarmTime;

  /// The alarm label, e.g. "Morning Workout"
  final String label;

  const AlarmRingingScreen({
    super.key,
    required this.alarmTime,
    required this.label,
  });

  @override
  State<AlarmRingingScreen> createState() => _AlarmRingingScreenState();
}

class _AlarmRingingScreenState extends State<AlarmRingingScreen>
    with SingleTickerProviderStateMixin {
  // ── App colour palette ─────────────────────────────────────────────────
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);

  // ── Audio & timer ──────────────────────────────────────────────────────
  // Add your alarm sound file here: assets/audio/alarm.mp3
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _repeatTimer;
  bool _audioAvailable = false;

  // ── Pulsing animation ──────────────────────────────────────────────────
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Pulsing animation for the bell icon
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Start alarm (safe — no crash if file missing)
    _startAlarm();
  }

  Future<void> _startAlarm() async {
    try {
      // Attempt to play the alarm sound
      // Add your alarm.mp3 file to: assets/audio/alarm.mp3
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      await _audioPlayer.play(AssetSource('audio/alarm.mp3'));
      if (mounted) setState(() => _audioAvailable = true);

      // Repeat the sound every 5 seconds
      _repeatTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
        try {
          await _audioPlayer.stop();
          await _audioPlayer.play(AssetSource('audio/alarm.mp3'));
        } catch (_) {
          // Audio failed mid-repeat — switch to vibration
          HapticFeedback.heavyImpact();
        }
      });
    } catch (_) {
      // Audio file not found or playback failed — use vibration fallback
      if (mounted) setState(() => _audioAvailable = false);
      HapticFeedback.heavyImpact();

      _repeatTimer = Timer.periodic(const Duration(seconds: 5), (_) {
        HapticFeedback.heavyImpact();
      });
    }
  }

  Future<void> _stopAlarm() async {
    _repeatTimer?.cancel();
    _repeatTimer = null;
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // ── Pulsing Bell ──────────────────────────────────────
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_primary, _primaryLight],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _primary.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.alarm,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ── Good Morning! ─────────────────────────────────────
                const Text(
                  'Good Morning! 🌅',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: _textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'It\'s time to wake up.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF7B6F72),
                  ),
                ),
                const SizedBox(height: 30),

                // ── Alarm time card ───────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FE),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7B6F72),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.alarmTime,
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: _primary,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Alarm status line ─────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.notifications_active,
                        color: _primary, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      _audioAvailable
                          ? '🔔 Alarm is ringing'
                          : '📳 Alarm is ringing (vibration)',
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF7B6F72)),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // ── STOP ALARM button ─────────────────────────────────
                GestureDetector(
                  onTap: _stopAlarm,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.alarm_off,
                            color: Colors.white, size: 22),
                        SizedBox(width: 10),
                        Text(
                          'STOP ALARM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
