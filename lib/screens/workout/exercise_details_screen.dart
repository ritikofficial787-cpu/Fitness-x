

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../models/workout_model.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final Exercise exercise;
  final String workoutName; // just for display/context

  const ExerciseDetailsScreen({
    super.key,
    required this.exercise,
    required this.workoutName,
  });

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  // App colour palette
  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);
  static const Color _bgLight = Color(0xFFF7F8F8);
  static const Color _cardBg = Color(0xFFE8F0FE);

  // Repetitions counter
  late int _reps;

  // Video player – only used when exercise.hasVideo == true
  VideoPlayerController? _videoController;
  bool _videoReady = false;   // true once the controller is initialised
  bool _videoFailed = false;  // true if the video asset failed to load
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _reps = widget.exercise.defaultReps;
    _initVideo();
  }

  // Initialise the video player only if this exercise has a video path
  Future<void> _initVideo() async {
    final path = widget.exercise.videoPath;
    if (!widget.exercise.hasVideo || path == null) return;

    try {
      final controller = VideoPlayerController.asset(path);
      _videoController = controller;

      await controller.initialize();

      controller.setLooping(true);

      // Listen so we can rebuild the play/pause icon
      controller.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = controller.value.isPlaying;
          });
        }
      });

      if (mounted) {
        setState(() => _videoReady = true);
      }
    } catch (e) {
      // Video file missing or corrupt – show safe placeholder instead of crashing
      if (mounted) {
        setState(() => _videoFailed = true);
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    final ctrl = _videoController;
    if (ctrl == null) return;
    setState(() {
      if (ctrl.value.isPlaying) {
        ctrl.pause();
      } else {
        ctrl.play();
      }
      _isPlaying = ctrl.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercise = widget.exercise;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top video / image area ────────────────────────────────────
            _buildMediaArea(exercise),

            // ── Scrollable details ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildExerciseHeader(exercise),
                    const SizedBox(height: 10),
                    _buildDescription(exercise),
                    const SizedBox(height: 20),
                    _buildHowToDo(exercise),
                    const SizedBox(height: 24),
                    _buildRepsSelector(),
                    const SizedBox(height: 28),
                    _buildSaveButton(),
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

  // ── Media area ─────────────────────────────────────────────────────────
  Widget _buildMediaArea(Exercise exercise) {
    return SizedBox(
      height: 240,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Video (if loaded) ──────────────────────────────────────────
          if (_videoReady && _videoController != null)
            GestureDetector(
              onTap: _togglePlayPause,
              child: AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            )

          // ── Placeholder when video is loading ─────────────────────────
          else if (exercise.hasVideo && !_videoFailed)
            Container(
              color: Colors.black87,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            )

          // ── Placeholder when video file is missing or failed ───────────
          else if (_videoFailed)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.videocam_off, color: Colors.white54, size: 48),
                    SizedBox(height: 10),
                    Text(
                      'Video not available',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            )

          // ── Generic icon background for non-video exercises ────────────
          else
            Container(
              color: _cardBg,
              child: const Center(
                child: Icon(Icons.fitness_center, color: _primary, size: 60),
              ),
            ),

          // ── Animated GIF (shown when gifPath is set and no video playing) ─
          // Flutter's Image.asset handles GIF animation natively — no extra package.
          // To remap an exercise to a different GIF, change gifPath in workout_model.dart.
          if (exercise.gifPath != null && !_videoReady)
            Positioned.fill(
              child: Image.asset(
                exercise.gifPath!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(), // silently ignore missing GIF
              ),
            ),
          // ── Play / Pause overlay button (only for video) ───────────────
          if (_videoReady)
            Center(
              child: GestureDetector(
                onTap: _togglePlayPause,
                child: AnimatedOpacity(
                  opacity: _isPlaying ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),

          // ── Video progress bar at the bottom ───────────────────────────
          if (_videoReady && _videoController != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _videoController!,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: _primary,
                  bufferedColor: Colors.white38,
                  backgroundColor: Colors.white12,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              ),
            ),

          // ── Back button ────────────────────────────────────────────────
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 14, color: _textDark),
              ),
            ),
          ),

          // ── More button ────────────────────────────────────────────────
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  const Icon(Icons.more_horiz, size: 20, color: _textDark),
            ),
          ),

          // ── "Video coming soon" label – only for non-video, non-GIF exercises
          if (!exercise.hasVideo && exercise.gifPath == null)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Video coming soon',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Exercise name + subtitle ────────────────────────────────────────────
  Widget _buildExerciseHeader(Exercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.workoutName}  •  ${exercise.duration}',
          style: const TextStyle(fontSize: 12, color: _textGrey),
        ),
      ],
    );
  }

  // ── Description ─────────────────────────────────────────────────────────
  Widget _buildDescription(Exercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descriptions',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          exercise.description,
          style: const TextStyle(
            fontSize: 13,
            color: _textGrey,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ── How To Do steps ────────────────────────────────────────────────────
  Widget _buildHowToDo(Exercise exercise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'How To Do',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            Text(
              '${exercise.howToDo.length} Steps',
              style: const TextStyle(fontSize: 12, color: _primary),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...exercise.howToDo.asMap().entries.map((entry) {
          return _buildStep(entry.key, entry.value.instruction);
        }),
      ],
    );
  }

  Widget _buildStep(int index, String instruction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primary, _primaryLight],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                (index + 1).toString().padLeft(2, '0'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                instruction,
                style: const TextStyle(
                  fontSize: 13,
                  color: _textGrey,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Custom Repetitions selector ─────────────────────────────────────────
  Widget _buildRepsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Custom Repetitions',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _bgLight,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Minus button
              GestureDetector(
                onTap: () {
                  if (_reps > 1) setState(() => _reps--);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.remove, color: _primary, size: 20),
                ),
              ),
              // Value
              Text(
                '$_reps times',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              // Plus button
              GestureDetector(
                onTap: () {
                  if (_reps < 200) setState(() => _reps++);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add, color: _primary, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Save button ─────────────────────────────────────────────────────────
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_primary, _primaryLight],
          ),
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: _primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Pause video before leaving
            _videoController?.pause();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Saved: ${widget.exercise.name} – $_reps reps'),
                backgroundColor: _primary,
                duration: const Duration(seconds: 2),
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
