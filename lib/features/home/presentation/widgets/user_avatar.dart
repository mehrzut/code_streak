import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart';
import 'package:code_streak/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.state, required this.size});
  final UserInfoState state;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: state.maybeWhen(
        orElse: () => false,
        loading: () => true,
      ),
      child: state.maybeWhen(
        success: (data) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              image: DecorationImage(
                  image: data.avatarUrl.isNotNullOrEmpty
                      ? NetworkImage(data.avatarUrl ?? '')
                      : Assets.images.avatar.provider())),
        ),
        orElse: () => _defaultAvatar,
      ),
    );
  }

  Widget get _defaultAvatar => ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Assets.images.avatar.image(
          width: size,
          height: size,
        ),
      );
}
