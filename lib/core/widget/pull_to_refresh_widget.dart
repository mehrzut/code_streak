import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class PullToRefreshWidget extends StatelessWidget {
  const PullToRefreshWidget(
      {super.key, required this.child, required this.onRefresh});
  final Widget child;
  final Future Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    const height = 80.0;
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      child: child,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final dy = controller.value.clamp(0.0, 1.0) * (height);
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0.0, dy),
                    child: child,
                  ),
                  Positioned(
                    top: -height,
                    left: 0,
                    right: 0,
                    height: height,
                    child: Container(
                      height: height,
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      transform: Matrix4.translationValues(0.0, dy, 0.0),
                      constraints: const BoxConstraints.expand(),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            shape: BoxShape.circle),
                        child: Icon(
                          Icons.refresh_rounded,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}
