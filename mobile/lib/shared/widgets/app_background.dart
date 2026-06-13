import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showBlurShapes;

  const AppBackground({
    super.key,
    required this.child,
    this.showBlurShapes = true,
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
