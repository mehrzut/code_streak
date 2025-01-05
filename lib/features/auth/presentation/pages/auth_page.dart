import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/core/widget/gradient_image.dart';
import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_streak/features/home/presentation/pages/home_page.dart';
import 'package:code_streak/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AuthPage extends StatefulWidget {
  static const pageRoute = '/auth';
  const AuthPage({super.key});

  @override
  createState() => _AuthPage();
}

class _AuthPage extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          success: () {
            _navigateToHomePage();
          },
        );
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: GradientImage(
                    image: Assets.images.loginImage.image(
              fit: BoxFit.cover,
              width: MediaQuery.sizeOf(context).width,
            ))),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                children: [
                  Center(
                    child: Text(
                      'CodeStreak',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w700),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Build your daily coding streak',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                  Center(
                    child: Text(
                      'This app integrates with GitHub to monitor your coding activity. It utilizes your GitHub data to track and display your coding streak.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.maybeWhen(
                          orElse: () => _login,
                          loading: () => null,
                        ),
                        child: Skeletonizer(
                          enabled: state.maybeWhen(
                            orElse: () => false,
                            loading: () => true,
                          ),
                          enableSwitchAnimation: true,
                          child: const Text('Login'),
                        ),
                      );
                    },
                  ),
                ].verticalPadding(24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() {
    context.read<AuthBloc>().add(AuthEvent.loginWithGitHub());
  }

  void _navigateToHomePage() {
    context.pushReplacementNamed(HomePage.pageRoute);
  }
}
