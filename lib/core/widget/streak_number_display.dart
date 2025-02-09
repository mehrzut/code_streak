import 'dart:async';
import 'package:flutter/material.dart';

class StreakNumberDisplay extends StatefulWidget {
  final BuildContext pageContext;
  final String number;
  final Widget? topWidget;
  final Widget? bottomWidget;
  final Duration animationDuration;
  final Color overlayColor;
  final Color numberColor;
  final Color textColor;
  final double numberFontSize;
  final double trailMaxOpacity;
  final int trailCount;
  final double trailScaleReduction;
  final double peakHeightFraction;
  final double startScale;
  final VoidCallback onClose; // Callback to close/remove the overlay

  const StreakNumberDisplay(
    this.pageContext, {
    super.key,
    required this.number,
    this.topWidget,
    this.bottomWidget,
    this.animationDuration = const Duration(milliseconds: 1500),
    this.overlayColor = Colors.black38,
    this.numberColor = Colors.amber,
    this.textColor = Colors.white,
    this.numberFontSize = 160,
    this.trailMaxOpacity = 0.4,
    this.trailCount = 5,
    this.trailScaleReduction = 0.2,
    this.peakHeightFraction = 0.9,
    this.startScale = 0.8,
    required this.onClose,
  });

  @override
  State<StreakNumberDisplay> createState() => _StreakNumberDisplayState();
}

class _StreakNumberDisplayState extends State<StreakNumberDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _overlayOpacity;
  late Animation<double> _positionY;
  late Animation<double> _scale;
  late Animation<double> _textOpacity;
  final List<TrailParticle> _trailParticles = [];
  Timer? _trailTimer;

  // Getter to determine if we are in the first tween sequence of _positionY.
  bool get isInFirstTweenSequence {
    const double firstTweenWeight = 70.0;
    const double totalWeight = 70.0 + 30.0;
    return _controller.value < (firstTweenWeight / totalWeight);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..addListener(_handleTrail);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && _trailParticles.isNotEmpty) {
        _startTrailTimer();
      }
    });

    _setupAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  void _setupAnimations() {
    final screenHeight = MediaQuery.sizeOf(widget.pageContext).height;

    _overlayOpacity = Tween(begin: 0.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _positionY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: screenHeight * 2,
          end: screenHeight * (1 - widget.peakHeightFraction),
        ).chain(CurveTween(curve: Curves.easeOutExpo)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: screenHeight * (1 - widget.peakHeightFraction),
          end: screenHeight * 0.3,
        ).chain(CurveTween(curve: Curves.easeInExpo)),
        weight: 30,
      ),
    ]).animate(_controller);

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: widget.startScale, end: widget.startScale),
        weight: 80,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.startScale, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInExpo)),
        weight: 20,
      ),
    ]).animate(_controller);

    _textOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void _updateTrailParticles({bool addNewParticle = false}) {
    final now = DateTime.now();
    if (addNewParticle) {
      _trailParticles.add(TrailParticle(
        y: _positionY.value,
        scale: _scale.value,
        opacity: widget.trailMaxOpacity,
        createdDateTime: now,
      ));
    }

    for (var particle in _trailParticles) {
      final elapsed = now.difference(particle.createdDateTime).inMilliseconds;
      final fraction = (elapsed / 1000).clamp(0.0, 1.0);
      particle.opacity = widget.trailMaxOpacity * (1 - fraction);
    }
    _trailParticles.removeWhere((particle) =>
        now.difference(particle.createdDateTime).inMilliseconds >= 300);
  }

  void _handleTrail() {
    if (_controller.isAnimating) {
      setState(() {
        _updateTrailParticles(addNewParticle: true);
      });
    }
  }

  void _startTrailTimer() {
    _trailTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() {
        _updateTrailParticles();
        if (_trailParticles.isEmpty) {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _trailTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Dark Overlay
          AnimatedBuilder(
            animation: _overlayOpacity,
            builder: (context, _) => Container(
              color: widget.overlayColor.withOpacity(_overlayOpacity.value),
            ),
          ),

          // Trail Effect
          ..._trailParticles.map((particle) => Positioned(
                top: particle.y,
                width: size.width,
                child: Transform.scale(
                  scale: particle.scale - widget.trailScaleReduction,
                  child: Opacity(
                    opacity: particle.opacity,
                    child: Text(
                      widget.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.transparent,
                        shadows: [
                          Shadow(
                            color: widget.numberColor,
                            blurRadius: 200,
                          ),
                        ],
                        fontSize: widget.numberFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),

          // Main Number
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => Positioned(
              top: _positionY.value,
              width: size.width,
              child: Transform.scale(
                scale: _scale.value,
                child: _buildNumberText(),
              ),
            ),
          ),

          // Top Widget
          Positioned(
            top: size.height * 0.3,
            width: size.width,
            child: AnimatedBuilder(
              animation: _textOpacity,
              builder: (context, _) =>
                  Opacity(opacity: _textOpacity.value, child: widget.topWidget),
            ),
          ),
          // Bottom Widget
          Positioned(
            top: size.height * 0.5,
            width: size.width,
            child: AnimatedBuilder(
              animation: _textOpacity,
              builder: (context, _) => Opacity(
                  opacity: _textOpacity.value, child: widget.bottomWidget),
            ),
          ),

          // Close Button
          Positioned(
            bottom: 40,
            width: size.width,
            child: Center(
              child: TextButton(
                onPressed: widget.onClose,
                style: TextButton.styleFrom(
                  foregroundColor: widget.textColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('CLOSE'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberText() {
    return Text(
      widget.number,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: widget.numberColor,
        fontSize: widget.numberFontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class TrailParticle {
  double y;
  double scale;
  double opacity;
  final DateTime createdDateTime;

  TrailParticle({
    required this.y,
    required this.scale,
    required this.opacity,
    required this.createdDateTime,
  });
}

// Function to show StreakNumberDisplay as an overlay.
void showStreakNumberOverlay({
  required BuildContext context,
  required String number,
  Widget? topWidget,
  Widget? bottomWidget,
  Duration animationDuration = const Duration(milliseconds: 1500),
  Color overlayColor = Colors.black38,
  Color numberColor = Colors.amber,
  Color textColor = Colors.white,
  double numberFontSize = 160,
  double trailMaxOpacity = 0.4,
  int trailCount = 5,
  double trailScaleReduction = 0.2,
  double peakHeightFraction = 0.9,
  double startScale = 0.8,
}) {
  final overlayState = Overlay.of(context);
  late OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => StreakNumberDisplay(
      context,
      number: number,
      topWidget: topWidget,
      bottomWidget: bottomWidget,
      animationDuration: animationDuration,
      overlayColor: overlayColor,
      numberColor: numberColor,
      textColor: textColor,
      numberFontSize: numberFontSize,
      trailMaxOpacity: trailMaxOpacity,
      trailCount: trailCount,
      trailScaleReduction: trailScaleReduction,
      peakHeightFraction: peakHeightFraction,
      startScale: startScale,
      onClose: () {
        overlayEntry.remove();
      },
    ),
  );
  overlayState.insert(overlayEntry);
}
