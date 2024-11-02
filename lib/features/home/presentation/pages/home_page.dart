import 'package:code_streak/features/home/presentation/bloc/contributions_bloc.dart';
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  static const pageRoute = '/home';
  const HomePage({super.key});

  @override
  createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) => _getContributionsData(data.username),
        );
      },
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: [
            BlocBuilder<UserInfoBloc, UserInfoState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  success: (data) => Text(data.toString()),
                  orElse: () => const SizedBox(),
                );
              },
            ),
            BlocBuilder<ContributionsBloc, ContributionsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  success: (data) => Text(data.toString()),
                  orElse: () => const SizedBox(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getUserInfo() {
    context.read<UserInfoBloc>().add(UserInfoEvent.getUserInfo());
  }

  void _getContributionsData(String username) {
    context
        .read<ContributionsBloc>()
        .add(ContributionsEvent.get(username: username));
  }
}
