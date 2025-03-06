import 'dart:math';

import 'package:flutter/material.dart';

class GlowingText extends StatefulWidget {
  const GlowingText(this.data,
      {super.key, this.style, required this.shadowColor});
  final String data;
  final TextStyle? style;
  final Color? shadowColor;

  @override
  State<GlowingText> createState() => _GlowingTextState();
}

class _GlowingTextState extends State<GlowingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final Random _random = Random();
  Offset _currentOffset = Offset.zero;
  Offset _targetOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _targetOffset = _generateRandomOffset();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _setupAnimation();
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Once an animation completes, update current offset and choose a new random target.
        _currentOffset = _targetOffset;
        _targetOffset = _generateRandomOffset();
        _setupAnimation();
        _controller.forward(from: 0);
      }
    });
  }

  /// Creates a new Tween animation from the current offset to a new random target.
  void _setupAnimation() {
    _animation = Tween<Offset>(
      begin: _currentOffset,
      end: _targetOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  /// Generates a random offset within a specified range.
  Offset _generateRandomOffset() {
    // Adjust these values to control the range of movement.
    double dx = (_random.nextDouble() * 10) - 5;
    double dy = (_random.nextDouble() * 10) - 5;
    return Offset(dx, dy);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          widget.data,
          style: (widget.style ?? const TextStyle()).copyWith(
            shadows: [
              Shadow(
                offset: _animation.value,
                blurRadius: 20.0,
                color:
                    widget.shadowColor ?? widget.style?.color ?? Colors.black45,
              ),
            ],
          ),
        );
      },
    );
  }
}
