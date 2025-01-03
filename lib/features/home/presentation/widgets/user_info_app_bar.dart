import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart';
import 'package:flutter/material.dart';

class UserInfoAppBar extends StatelessWidget {
  const UserInfoAppBar(
      {super.key,
      required this.state,
      required this.expandedHeight,
      required this.collapsedHeight});
  final UserInfoState state;
  final double expandedHeight;
  final double collapsedHeight;

  double get imageCollapsedSize => 48;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final progress = 1 -
          ((constraints.biggest.height - collapsedHeight) /
              (expandedHeight - collapsedHeight));
      return Column(
        children: [
          state.maybeWhen(
            success: (data) => ClipRRect(
              borderRadius: BorderRadius.circular(
                  0 + (progress * imageCollapsedSize / 2)),
              child: Image.network(
                data.avatarUrl ?? '',
                height: expandedHeight -
                    ((expandedHeight - imageCollapsedSize) * progress),
              ),
            ),
            orElse: () => const SizedBox(),
          )
        ],
      );
    });
  }
}
