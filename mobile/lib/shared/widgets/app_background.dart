import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showBlurShapes;
  final bool showBatikPattern;

  const AppBackground({
    super.key,
    required this.child,
    this.showBlurShapes = true,
    this.showBatikPattern = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // Base gradient — slightly more contrast between top and bottom
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [
                      const Color(0xFF0F0F0F),
                      const Color(0xFF161616),
                      const Color(0xFF0F0F0F),
                    ]
                  : [
                      const Color(0xFFF4F6F8),
                      const Color(0xFFECEFF3),
                      const Color(0xFFF4F6F8),
                    ],
            ),
          ),
        ),

        // Subtle Batik Kawung pattern background watermark (optional)
        if (showBatikPattern)
          Positioned.fill(
            child: CustomPaint(
              painter: BatikKawungPainter(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.045),
              ),
            ),
          ),

        if (showBlurShapes) ...[
          // Top-right emerald accent — more visible
          Positioned(
            top: -80,
            right: -60,
            child: _BlurredShape(
              color: isDark
                  ? Colors.green.withValues(alpha: 0.08)
                  : const Color(0xFF10B981).withValues(alpha: 0.1),
              size: 280,
            ),
          ),

          // Middle-left blue accent
          Positioned(
            top: MediaQuery.of(context).size.height * 0.38,
            left: -90,
            child: _BlurredShape(
              color: isDark
                  ? Colors.teal.withValues(alpha: 0.05)
                  : Colors.blue.withValues(alpha: 0.06),
              size: 360,
            ),
          ),

          // Bottom-right warm accent
          Positioned(
            bottom: -40,
            right: -80,
            child: _BlurredShape(
              color: isDark
                  ? Colors.amber.withValues(alpha: 0.04)
                  : Colors.orange.withValues(alpha: 0.06),
              size: 300,
            ),
          ),
        ],

        // Content
        child,
      ],
    );
  }
}

class BatikKawungPainter extends CustomPainter {
  final Color color;

  BatikKawungPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const double cellSize = 72.0;
    final int cols = (size.width / cellSize).ceil() + 1;
    final int rows = (size.height / cellSize).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final double x = c * cellSize;
        final double y = r * cellSize;
        final double half = cellSize / 2;
        final double quarter = cellSize / 4;

        final center = Offset(x + half, y + half);

        // Top petal
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x + half, y + quarter),
            width: quarter * 1.6,
            height: half,
          ),
          paint,
        );

        // Bottom petal
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x + half, y + cellSize - quarter),
            width: quarter * 1.6,
            height: half,
          ),
          paint,
        );

        // Left petal
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x + quarter, y + half),
            width: half,
            height: quarter * 1.6,
          ),
          paint,
        );

        // Right petal
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(x + cellSize - quarter, y + half),
            width: half,
            height: quarter * 1.6,
          ),
          paint,
        );

        // Center dot
        canvas.drawCircle(center, 2.0, dotPaint);

        // Corner dots
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BlurredShape extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurredShape({
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.55,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    );
  }
}
