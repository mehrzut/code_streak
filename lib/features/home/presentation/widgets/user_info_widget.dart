import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart';
import 'package:code_streak/features/home/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key, required this.state});
  final UserInfoState state;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: state.isLoading,
      enableSwitchAnimation: true,
      child: Row(
        children: [
          UserAvatar(
            state: state,
            size: 48,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _nameWidget,
              _usernameWidget,
              state.maybeWhen(
                orElse: () => const SizedBox(),
                success: (data) =>
                    data.location != null ? _addressWidget : const SizedBox(),
              )
            ],
          ))
        ].horizontalPadding(16),
      ),
    );
  }

  Widget get _nameWidget => Builder(builder: (context) {
        return Text(
          state.maybeWhen(
            orElse: () => '',
            loading: () => 'John Doe',
            success: (data) => data.fullName,
          ),
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
        );
      });

  Widget get _usernameWidget => Builder(builder: (context) {
        return Text(
          state.maybeWhen(
            orElse: () => '',
            loading: () => '@johndoe',
            success: (data) => '@${data.username}',
          ),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        );
      });

  Widget get _addressWidget => Builder(builder: (context) {
        return Text(
          state.maybeWhen(
            orElse: () => '',
            loading: () => 'San Francisco, CA',
            success: (data) => '${data.location}',
          ),
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        );
      });
}
