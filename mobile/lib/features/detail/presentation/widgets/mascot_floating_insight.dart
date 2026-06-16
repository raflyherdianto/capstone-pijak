import 'package:flutter/material.dart';
import '../../../../shared/domain/models.dart';
import '../../../../shared/widgets/arjuna_brand.dart';

class MascotFloatingInsight extends StatefulWidget {
  final Insight? insight;
  final bool isLoading;
  final int initialPerspective;

  const MascotFloatingInsight({
    super.key,
    this.insight,
    this.isLoading = false,
    this.initialPerspective = 0,
  });

  @override
  State<MascotFloatingInsight> createState() => _MascotFloatingInsightState();
}

class _MascotFloatingInsightState extends State<MascotFloatingInsight>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  int _perspective = 0; // 0: Masyarakat, 1: Pedagang
  double _rotationAngle = 0.0;
  double _scale = 1.0;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _perspective = widget.initialPerspective;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant MascotFloatingInsight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isOpen && oldWidget.initialPerspective != widget.initialPerspective) {
      _perspective = widget.initialPerspective;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleMascot() {
    if (!_isOpen) {
      setState(() {
        _isOpen = true;
        _scale = 1.15;
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        setState(() {
          _scale = 1.0;
        });
      });
    } else if (widget.isLoading) {
      setState(() {
        _scale = 0.92;
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        setState(() {
          _scale = 1.0;
        });
      });
    } else {
      // Toggle perspective if already open
      setState(() {
        _perspective = _perspective == 0 ? 1 : 0;
        _rotationAngle += 1.0; // Rotate 360 degrees (1.0 * 2 * pi)
        _scale = 0.85;
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        setState(() {
          _scale = 1.0;
        });
      });
    }
  }

  void _closeBubble() {
    setState(() {
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading && widget.insight == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Theme color based on current perspective
    final activeColor = _perspective == 0
        ? (isDark ? ArjunaColors.teal : ArjunaColors.tealDark)
        : ArjunaColors.gold;

    final bubbleText = widget.isLoading
        ? 'Arjuna sedang menyusun rekomendasi AI terbaru. Data harga dan prediksi sudah bisa dilihat dulu, insight akan muncul otomatis sebentar lagi.'
        : (_perspective == 0
              ? widget.insight!.masyarakat
              : widget.insight!.pedagang);
    final perspectiveLabel = widget.isLoading
        ? 'Menyiapkan Insight'
        : (_perspective == 0 ? 'Masyarakat' : 'Pedagang');
    final perspectiveIcon = widget.isLoading
        ? Icons.auto_awesome_rounded
        : (_perspective == 0
              ? Icons.shopping_basket_rounded
              : Icons.storefront_rounded);
    final bubbleWidth = (screenWidth - 48).clamp(240.0, 320.0);

    return SizedBox(
      width: _isOpen ? bubbleWidth : 58,
      height: _isOpen ? 410 : 58,
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          // Speech Bubble Card Overlay
          if (_isOpen)
            Positioned(
              bottom: 74,
              right: 0,
              child: AnimatedOpacity(
                opacity: _isOpen ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  width: bubbleWidth,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF072135).withValues(alpha: 0.98)
                        : Colors.white.withValues(alpha: 0.98),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: activeColor.withValues(alpha: isDark ? 0.3 : 0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withValues(
                          alpha: isDark ? 0.12 : 0.08,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.3 : 0.08,
                        ),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.fromLTRB(12, 2, 6, 2),
                          decoration: BoxDecoration(
                            color: activeColor.withValues(alpha: 0.06),
                            border: Border(
                              bottom: BorderSide(
                                color: activeColor.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      perspectiveIcon,
                                      size: 16,
                                      color: activeColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        widget.isLoading
                                            ? perspectiveLabel
                                            : 'Tips $perspectiveLabel',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: activeColor,
                                          fontFamily: 'Outfit',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, size: 16),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints.tightFor(
                                  width: 30,
                                  height: 30,
                                ),
                                onPressed: _closeBubble,
                                color: isDark ? Colors.white54 : Colors.black45,
                              ),
                            ],
                          ),
                        ),
                        // Content Body
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bubbleText,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  height: 1.5,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : Colors.black87,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (widget.isLoading)
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: activeColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Memuat insight AI...',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontStyle: FontStyle.italic,
                                        color: isDark
                                            ? Colors.white38
                                            : Colors.black45,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                )
                              else
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.touch_app_outlined,
                                      size: 12,
                                      color: isDark
                                          ? Colors.white30
                                          : Colors.black38,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Tap maskot untuk ganti perspektif',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontStyle: FontStyle.italic,
                                        color: isDark
                                            ? Colors.white30
                                            : Colors.black38,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Mascot FAB Button
          GestureDetector(
            onTap: _toggleMascot,
            child: AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutBack,
              child: AnimatedRotation(
                turns: _rotationAngle,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOutBack,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pulse outer ring
                    ScaleTransition(
                      scale: Tween<double>(begin: 1.0, end: 1.25).animate(
                        CurvedAnimation(
                          parent: _pulseController,
                          curve: Curves.easeOut,
                        ),
                      ),
                      child: FadeTransition(
                        opacity: Tween<double>(begin: 0.6, end: 0.0).animate(
                          CurvedAnimation(
                            parent: _pulseController,
                            curve: Curves.easeOut,
                          ),
                        ),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: activeColor,
                          ),
                        ),
                      ),
                    ),
                    // Mascot main badge
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF031827),
                                  const Color(0xFF07345A),
                                ]
                              : [
                                  const Color(0xFFFFFDF8),
                                  const Color(0xFFEAF8F4),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: activeColor, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: isDark
                                ? ArjunaColors.deepNavy
                                : ArjunaColors.ivory,
                          ),
                          child: Image.asset(
                            widget.isLoading
                                ? ArjunaAssets.mascotThinking
                                : ArjunaAssets.mascotAlert,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            filterQuality: FilterQuality.high,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.smart_toy_rounded,
                                  color: activeColor,
                                  size: 26,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Notification indicator if bubble is not open yet
                    if (!_isOpen)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: ArjunaColors.gold,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? ArjunaColors.deepNavy
                                  : Colors.white,
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: widget.isLoading
                                ? SizedBox(
                                    width: 8,
                                    height: 8,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 1.6,
                                      color: isDark
                                          ? ArjunaColors.deepNavy
                                          : Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.psychology,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
