import 'package:flutter/material.dart';
import '../widgets/gradient_button.dart';
import 'main_nav_screen.dart';

/// Shown after the full registration flow completes
/// (Register → Profile → Goal → Success).
/// Displays a welcome message with the user's name and a "Go To Home" button.
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const userName = 'TukaRam';

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
                        painter: _SuccessBlobPainter(),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/images/Group.png',
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Welcome, $userName',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1617),
              ),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                'You are all set now, let\'s reach your\ngoals together with us',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF7B6F72),
                  height: 1.6,
                ),
              ),
            ),

            const Spacer(flex: 3),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GradientButton(
                text: 'Go To Home',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MainNavScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// Custom painter for the blue blob behind the success illustration
class _SuccessBlobPainter extends CustomPainter {
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
