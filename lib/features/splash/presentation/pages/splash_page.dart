import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_streak/features/auth/presentation/pages/auth_page.dart';
import 'package:code_streak/features/home/presentation/pages/home_page.dart';
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
  @override
  void initState() {
    _checkAuthenticationStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          success: () => _navigateToHomePage(),
          failed: (failure) => _navigateToLoginPage(),
        );
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'CodeStreak',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              )
                  .animate(
                    onComplete: (controller) =>
                        controller.repeat(reverse: true),
                    onInit: (controller) => controller.repeat(reverse: true),
                  )
                  .tint(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    duration: const Duration(seconds: 1),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkAuthenticationStatus() {
    context.read<AuthBloc>().add(AuthEvent.loadCredentials());
  }

  void _navigateToHomePage() {
    context.pushReplacementNamed(HomePage.pageRoute);
  }

  void _navigateToLoginPage() {
    context.pushReplacementNamed(AuthPage.pageRoute);
  }
}
