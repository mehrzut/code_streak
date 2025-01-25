import 'dart:async';

import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_streak/features/auth/presentation/pages/auth_page.dart';
import 'package:code_streak/features/home/presentation/pages/home_page.dart';
import 'package:code_streak/features/splash/presentation/widgets/version_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  static const pageRoute = '/';

  const SplashPage({super.key});
  @override
  createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  late Timer timer;
  bool _timerFinished = false;
  String? _nextPageRoute;

  @override
  void initState() {
    timer = Timer(const Duration(seconds: 2), () {
      _timerFinished = true;
      _checkTimerAndNavigate();
    });
    _checkAuthenticationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          success: () {
            _nextPageRoute = HomePage.pageRoute;
            _checkTimerAndNavigate();
          },
          failed: (failure) {
            _nextPageRoute = AuthPage.pageRoute;
            _checkTimerAndNavigate();
          },
        );
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'CodeStreak',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                      ),
                )
                    .animate(
                      onComplete: (controller) =>
                          controller.repeat(reverse: true),
                      onInit: (controller) => controller.repeat(reverse: true),
                    )
                    .tint(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      duration: const Duration(seconds: 1),
                    ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 12),
              child: VersionWidget(),
            )
          ],
        ),
      ),
    );
  }

  void _checkAuthenticationStatus() {
    context.read<AuthBloc>().add(AuthEvent.loadCredentials());
  }

  void _checkTimerAndNavigate() {
    if (_timerFinished && _nextPageRoute != null) {
      context.pushReplacementNamed(_nextPageRoute!);
    }
  }
}
