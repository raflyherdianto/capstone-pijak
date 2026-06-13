import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final bool isDark;

  const SplashContent({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLogo(),
            const SizedBox(height: 40),
            _buildAppName(),
            const SizedBox(height: 12),
            _buildTagline(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset('assets/images/app_logo.png'),
      ),
    );
  }

  Widget _buildAppName() {
    return Text(
      'ARJUNA',
      style: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w900,
        letterSpacing: 10,
        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildTagline() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        'ANALISIS HARGA & TINJAUAN PANGAN NUSANTARA',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
          color: isDark ? Colors.white54 : Colors.black45,
        ),
      ),
    );
  }
}
