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

  @override
  void initState() {
    super.initState();
    // Duration controls the speed of the animation.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Compute the angle for the circular movement.
        final angle = _controller.value * 2 * pi;
        // Set the maximum offset (radius) of the shadow.
        const double radius = 4.0;
        final offset = Offset(radius * cos(angle), radius * sin(angle));

        return Text(
          widget.data,
          style: (widget.style ?? const TextStyle()).copyWith(
            shadows: [
              Shadow(
                offset: offset,
                blurRadius: 30.0,
                color: widget.style?.color ?? Colors.black45,
              ),
            ],
          ),
        );
      },
    );
  }
}
