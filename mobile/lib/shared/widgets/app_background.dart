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
        // Base Gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF0F0F0F),
                      const Color(0xFF1A1A1A),
                      const Color(0xFF0F0F0F),
                    ]
                  : [
                      const Color(0xFFF8F9FA),
                      const Color(0xFFE9ECEF),
                      const Color(0xFFF8F9FA),
                    ],
            ),
          ),
        ),
        
        if (showBlurShapes) ...[
          // Top Right Shape
          Positioned(
            top: -100,
            right: -50,
            child: _BlurredShape(
              color: isDark 
                  ? Colors.green.withValues(alpha: 0.04)
                  : Colors.green.withValues(alpha: 0.06),
              size: 300,
            ),
          ),
          
          // Middle Left Shape
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: -100,
            child: _BlurredShape(
              color: isDark 
                  ? Colors.blue.withValues(alpha: 0.03)
                  : Colors.blue.withValues(alpha: 0.04),
              size: 400,
            ),
          ),
          
          // Bottom Right Shape
          Positioned(
            bottom: -50,
            right: -100,
            child: _BlurredShape(
              color: isDark 
                  ? Colors.orange.withValues(alpha: 0.03)
                  : Colors.orange.withValues(alpha: 0.05),
              size: 350,
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
        // Using BoxShadow instead of BackdropFilter is MUCH more performant
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.6,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    );
  }
}
