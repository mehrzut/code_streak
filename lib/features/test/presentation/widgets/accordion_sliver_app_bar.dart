import 'dart:developer';

import 'package:code_streak/core/extensions.dart';
import 'package:flutter/material.dart';

class AccordionSliverAppBar extends StatefulWidget {
  AccordionSliverAppBar({super.key, required this.delegate})
      : assert(
            delegate.children.map((e) => e.priority).toSet().length ==
                delegate.children.length,
            'All children priorities must be unique.'),
        assert(
            delegate.children.every(
              (element) => element.priority >= 0,
            ),
            'All children priorities must be greater than or equal to 0.');

  final AccordionSliverDeligate delegate;

  @override
  State<AccordionSliverAppBar> createState() => _AccordionSliverAppBarState();
}

class _AccordionSliverAppBarState extends State<AccordionSliverAppBar> {
  double get expandedHeight => widget.delegate.children.fold(
        0.0,
        (previousValue, element) =>
            previousValue + element.expanded.preferredSize.height,
      );

  double get collapsedHeight => widget.delegate.children.fold(
        0.0,
        (previousValue, element) =>
            previousValue + element.collapsed.preferredSize.height,
      );

  @override
  void didUpdateWidget(covariant AccordionSliverAppBar oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        setState(() {});
      },
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: expandedHeight -
          (widget.delegate.safeArea
              ? 0
              : MediaQuery.paddingOf(context).vertical),
      collapsedHeight: collapsedHeight -
          (widget.delegate.safeArea
              ? 0
              : MediaQuery.paddingOf(context).vertical),
      pinned: widget.delegate.pinned,
      floating: widget.delegate.floating,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.zero,
        expandedTitleScale: 1.0,
        title: SafeArea(
          bottom: widget.delegate.safeArea,
          top: widget.delegate.safeArea,
          left: widget.delegate.safeArea,
          right: widget.delegate.safeArea,
          child: _SliverAnimatedChildrenList(
            delegate: widget.delegate,
          ),
        ),
      ),
    );
  }
}

class _SliverAnimatedChildrenList extends StatefulWidget {
  const _SliverAnimatedChildrenList({required this.delegate});
  final AccordionSliverDeligate delegate;

  @override
  State<_SliverAnimatedChildrenList> createState() =>
      __SliverAnimatedChildrenListState();
}

class __SliverAnimatedChildrenListState
    extends State<_SliverAnimatedChildrenList> {
  List<_SliverChildRange> shrinkPoints = [];

  double get expandedHeight => widget.delegate.children.fold(
        0.0,
        (previousValue, element) =>
            previousValue + element.expanded.preferredSize.height,
      );

  double get collapsedHeight => widget.delegate.children.fold(
        0.0,
        (previousValue, element) =>
            previousValue + element.collapsed.preferredSize.height,
      );

  List<AccordionSliverChild> get _sortedByPriority => [
        ...widget.delegate.children
      ]..sort((a, b) => a.priority.compareTo(b.priority));

  @override
  void initState() {
    _configure();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _SliverAnimatedChildrenList oldWidget) {
    _configure();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final lastPriorityCollapsed =
            _getPriorityOfLastCollapsingItem(constraints.maxHeight);
        log(lastPriorityCollapsed.toString());
        return Align(
          alignment: widget.delegate.animationAlignment,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: widget.delegate.crossAxisAlignment,
              mainAxisAlignment: widget.delegate.mainAxisAlignment,
              children: widget.delegate.children.map((child) {
                final isExpanded = lastPriorityCollapsed == null
                    ? true
                    : child.priority > lastPriorityCollapsed;
                final animatedChild = AnimatedCrossFade(
                  firstChild: child.expanded.child,
                  secondChild: child.collapsed.child,
                  crossFadeState: isExpanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: widget.delegate.duration,
                  layoutBuilder: widget.delegate.layoutBuilder ??
                      AnimatedCrossFade.defaultLayoutBuilder,
                  firstCurve: Curves.easeIn,
                  secondCurve: Curves.easeOut,
                  sizeCurve: Curves.decelerate,
                );
                if (child.wrapperBuilder != null) {
                  return AnimatedContainer(
                    duration: widget.delegate.duration,
                    width: isExpanded
                        ? child.expanded.preferredSize.width
                        : child.collapsed.preferredSize.width,
                    height: isExpanded
                        ? child.expanded.preferredSize.height
                        : child.collapsed.preferredSize.height,
                    child: Align(
                      alignment: widget.delegate.animationAlignment,
                      child: child.wrapperBuilder!(
                          context,
                          animatedChild,
                          isExpanded
                              ? child.expanded.preferredSize
                              : child.collapsed.preferredSize,
                          isExpanded),
                    ),
                  );
                }
                return animatedChild;
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  int? _getPriorityOfLastCollapsingItem(double currentHeight) {
    final firstExpandedIndex = shrinkPoints.indexWhere(
      (element) => element.expandsOnAndAfter <= currentHeight,
    );
    if (firstExpandedIndex == -1) {
      // all items are collapsed
      return _sortedByPriority.last.priority;
    }
    final newCollapsedItemIndex = firstExpandedIndex - 1;
    if (newCollapsedItemIndex < shrinkPoints.length &&
        newCollapsedItemIndex >= 0) {
      final newCollapsedItem = shrinkPoints[newCollapsedItemIndex];
      return newCollapsedItem.priority;
    }
    // all items are expanded
    return null;
  }

  void _configure() {
    for (var i = 0; i < _sortedByPriority.length; i++) {
      final collapsed = _sortedByPriority.splitAtNotContaining(i).first;
      final expanded = _sortedByPriority.splitAtNotContaining(i).last;
      final itemsMinSpaceToExpand = collapsed.fold(
            0.0,
            (previousValue, element) =>
                previousValue + element.collapsed.preferredSize.height,
          ) +
          expanded.fold(
            0.0,
            (previousValue, element) =>
                previousValue + element.expanded.preferredSize.height,
          ) +
          widget.delegate.children[i].expanded.preferredSize.height;
      shrinkPoints = shrinkPoints.addOrUpdateWhere(
          (e) => e.priority == _sortedByPriority[i].priority,
          (e) => (_SliverChildRange(
                priority: _sortedByPriority[i].priority,
                expandsOnAndAfter: itemsMinSpaceToExpand,
              )));
    }
    log(shrinkPoints.toString());
  }
}

class AccordionSliverChild {
  final SizedSliverChild expanded;
  final SizedSliverChild collapsed;
  final Widget Function(
          BuildContext context, Widget child, Size size, bool isExpanded)?
      wrapperBuilder;

  /// The priority of the child
  /// The higher the number the higher the priority
  /// Which means the child with the lowest priority will collapse first
  final int priority;
  final bool isExpanded;

  AccordionSliverChild._({
    required this.expanded,
    required this.collapsed,
    required this.priority,
    this.isExpanded = true,
    this.wrapperBuilder,
  });

  AccordionSliverChild collapse() => copyWith(isExpanded: false);

  factory AccordionSliverChild.vanish({
    required SizedSliverChild expanded,
    required int priority,
  }) =>
      AccordionSliverChild._(
        expanded: expanded,
        collapsed: SizedSliverChild(
          preferredSize: Size.zero,
          child: const SizedBox(),
        ),
        priority: priority,
      );

  factory AccordionSliverChild({
    required SizedSliverChild expanded,
    required SizedSliverChild collapsed,
    required int priority,
    Widget Function(
            BuildContext context, Widget child, Size size, bool isExpanded)?
        wrapperBuilder,
  }) =>
      AccordionSliverChild._(
        expanded: expanded,
        collapsed: collapsed,
        priority: priority,
        wrapperBuilder: wrapperBuilder,
      );

  AccordionSliverChild copyWith(
          {SizedSliverChild? expanded,
          SizedSliverChild? collapsed,
          int? priority,
          bool? isExpanded}) =>
      AccordionSliverChild._(
        expanded: expanded ?? this.expanded,
        collapsed: collapsed ?? this.collapsed,
        priority: priority ?? this.priority,
        isExpanded: isExpanded ?? this.isExpanded,
      );
}

class _SliverChildRange {
  final double expandsOnAndAfter;
  final int priority;

  _SliverChildRange({required this.expandsOnAndAfter, required this.priority});

  @override
  String toString() {
    return '_SliverChildRange(expandsOnAndAfter: $expandsOnAndAfter, priority: $priority)';
  }
}

class AccordionSliverDeligate {
  final List<AccordionSliverChild> children;
  final bool safeArea;
  final bool floating;
  final bool pinned;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final AlignmentGeometry animationAlignment;
  final AnimatedCrossFadeBuilder? layoutBuilder;
  final Duration duration;

  AccordionSliverDeligate({
    required this.children,
    this.safeArea = true,
    this.floating = false,
    this.pinned = false,
    this.layoutBuilder,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.animationAlignment = AlignmentDirectional.bottomCenter,
    required this.duration,
  });
}

class SizedSliverChild {
  final Widget child;
  final Size preferredSize;
  SizedSliverChild({required this.child, required this.preferredSize});
}
