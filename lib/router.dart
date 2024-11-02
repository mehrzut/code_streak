import 'package:code_streak/features/auth/presentation/pages/auth_page.dart';
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart';
import 'package:code_streak/features/home/presentation/pages/home_page.dart';
import 'package:code_streak/features/splash/presentation/pages/splash_page.dart';
import 'package:code_streak/injector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: SplashPage.pageRoute,
  routes: [
    GoRoute(
      path: AuthPage.pageRoute,
      name: AuthPage.pageRoute,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: HomePage.pageRoute,
      name: HomePage.pageRoute,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<UserInfoBloc>(),
        child: const HomePage(),
      ),
    ),
    GoRoute(
      path: SplashPage.pageRoute,
      name: SplashPage.pageRoute,
      builder: (context, state) => const SplashPage(),
    ),
  ],
);
