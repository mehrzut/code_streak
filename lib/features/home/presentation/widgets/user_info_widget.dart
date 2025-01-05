import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class UserInfoWidget extends StatelessWidget {
  const UserInfoWidget({super.key, required this.state});
  final UserInfoState state;

  double get _imageSize => 64;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: state.maybeWhen(
        orElse: () => false,
        loading: () => true,
      ),
      enableSwitchAnimation: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            _imageWidget,
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nameWidget,
                _usernameWidget,
              ],
            ))
          ],
        ),
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

  Widget get _imageWidget => Builder(builder: (context) {
        return Container(
          width: _imageSize,
          height: _imageSize,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_imageSize / 2),
              image: DecorationImage(
                  image: NetworkImage(
                state.maybeWhen(
                  orElse: () => '',
                  loading: () => 'https://picsum.photos/${_imageSize.toInt()}',
                  success: (data) => data.avatarUrl ?? '',
                ),
              ))),
        );
      });
}
