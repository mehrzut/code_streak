import 'package:code_streak/features/auth/presentation/pages/auth_page.dart';
import 'package:code_streak/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(initialLocation: AuthPage.pageRoute, routes: [
  GoRoute(
    path: AuthPage.pageRoute,
    name: AuthPage.pageRoute,
    builder: (context, state) => const AuthPage(),
  ),
  GoRoute(
    path: HomePage.pageRoute,
    name: HomePage.pageRoute,
    builder: (context, state) => const HomePage(),
  ),
]);
