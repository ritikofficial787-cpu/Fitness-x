import 'package:flutter/material.dart';
import '../main_nav_screen.dart';

class WorkoutCompletedScreen extends StatelessWidget {
  const WorkoutCompletedScreen({super.key});

  static const Color _primary = Color(0xFF92A3FD);
  static const Color _primaryLight = Color(0xFF9DCEFF);
  static const Color _textDark = Color(0xFF1D1617);
  static const Color _textGrey = Color(0xFF7B6F72);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),

            SizedBox(
              width: double.infinity,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: CustomPaint(
                        painter: _CongratsBlobPainter(),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/Frame (2).png',
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: _primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          color: _primary,
                          size: 80,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Congratulations, You Have\nFinished Your Workout',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _textDark,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 14),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                '"Exercise is king and nutrition is queen.\n'
                'Combine the two and you will have a kingdom."\n'
                '– Jack LaLanne',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: _textGrey,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const Spacer(flex: 3),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                height: 58,
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainNavScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    child: const Text(
                      'Back To Home',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Blob background painter ─────────────────────────────────────────────────
// Same organic blob shape as the one in success_screen.dart for consistency.
class _CongratsBlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFB6C4FF),
          Color(0xFF92A3FD),
          Color(0xFF9DCEFF),
        ],
        stops: [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.02);
    path.cubicTo(
      size.width * 0.8, -size.height * 0.02,
      size.width * 1.05, size.height * 0.15,
      size.width * 0.95, size.height * 0.35,
    );
    path.cubicTo(
      size.width * 0.88, size.height * 0.5,
      size.width * 1.0, size.height * 0.65,
      size.width * 0.88, size.height * 0.82,
    );
    path.cubicTo(
      size.width * 0.75, size.height * 1.0,
      size.width * 0.5, size.height * 1.02,
      size.width * 0.3, size.height * 0.92,
    );
    path.cubicTo(
      size.width * 0.1, size.height * 0.82,
      size.width * -0.02, size.height * 0.65,
      size.width * 0.05, size.height * 0.45,
    );
    path.cubicTo(
      size.width * 0.1, size.height * 0.28,
      size.width * 0.05, size.height * 0.15,
      size.width * 0.18, size.height * 0.08,
    );
    path.cubicTo(
      size.width * 0.3, size.height * 0.01,
      size.width * 0.38, size.height * 0.04,
      size.width * 0.5, size.height * 0.02,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
