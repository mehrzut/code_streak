import 'package:flutter/material.dart';

class GradientImage extends StatelessWidget {
  const GradientImage({super.key, required this.image, this.gradientColor});
  final Widget image;
  final Color? gradientColor;

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      image,
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              gradientColor ?? Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent,
            ],
          ),
        ),
      ),
    ]);
  }
}
