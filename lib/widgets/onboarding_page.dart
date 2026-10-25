import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  /// Set to true if the image already has a blob/wave background baked in
  final bool hasBuiltInBackground;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    this.hasBuiltInBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---- TOP: Illustration area ----
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 10),
            child: hasBuiltInBackground
                ? _buildImageWithBuiltInBg()
                : _buildImageWithPaintedBg(),
          ),
        ),

        // ---- BOTTOM: Title and Description ----
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1617),
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7B6F72),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// For images that already have the blob background (onboarding 1 & 4)
  Widget _buildImageWithBuiltInBg() {
    return ClipRect(
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }

  /// For images without background (onboarding 2 & 3) — paint a blob behind them
  Widget _buildImageWithPaintedBg() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Painted blob background
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomPaint(
              painter: _BlobPainter(),
            ),
          ),
        ),
        // Character illustration
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}

/// Custom painter that draws a blue/purple organic wave blob
class _BlobPainter extends CustomPainter {
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
        stops: [0.0, 0.4, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();

    // Create a flowing wave/blob shape similar to the reference
    path.moveTo(size.width * 0.45, size.height * 0.02);

    // Top right
    path.cubicTo(
      size.width * 0.78, -size.height * 0.02,
      size.width * 1.05, size.height * 0.12,
      size.width * 0.98, size.height * 0.32,
    );

    // Right side
    path.cubicTo(
      size.width * 0.92, size.height * 0.48,
      size.width * 1.02, size.height * 0.65,
      size.width * 0.9, size.height * 0.82,
    );

    // Bottom
    path.cubicTo(
      size.width * 0.78, size.height * 0.98,
      size.width * 0.55, size.height * 1.02,
      size.width * 0.35, size.height * 0.95,
    );

    // Bottom left
    path.cubicTo(
      size.width * 0.15, size.height * 0.88,
      size.width * -0.02, size.height * 0.7,
      size.width * 0.02, size.height * 0.5,
    );

    // Left side up
    path.cubicTo(
      size.width * 0.05, size.height * 0.32,
      size.width * 0.0, size.height * 0.2,
      size.width * 0.12, size.height * 0.1,
    );

    // Back to top
    path.cubicTo(
      size.width * 0.22, size.height * 0.02,
      size.width * 0.32, size.height * 0.04,
      size.width * 0.45, size.height * 0.02,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
