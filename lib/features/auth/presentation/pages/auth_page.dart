import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_streak/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(onPressed: _login, child: const Text('login')),
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
