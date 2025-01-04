import 'dart:developer';
import 'package:code_streak/core/controllers/navigation_helper.dart';
import 'package:code_streak/features/auth/presentation/bloc/sign_out_bloc.dart';
import 'package:code_streak/features/auth/presentation/pages/auth_page.dart';
import 'package:code_streak/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_streak/injector.dart';
import 'package:code_streak/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnv();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await configureDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => sl<AuthBloc>(),
      ),
      BlocProvider(
        create: (context) => sl<SignOutBloc>(),
      ),
    ],
    child: const MainApp(),
  ));
}

Future _loadEnv() async {
  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    log('env file not found!');
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignOutBloc, SignOutState>(
      listener: (context, state) {
        state.whenOrNull(
          success: () => _handleSignOut(),
        );
      },
      child: MaterialApp.router(
        theme: FlexThemeData.dark(
          scheme: FlexScheme.hippieBlue,
          subThemesData: const FlexSubThemesData(
            interactionEffects: true,
            tintedDisabledControls: true,
            blendOnColors: true,
            useM2StyleDividerInM3: true,
            inputDecoratorIsFilled: true,
            inputDecoratorBorderType: FlexInputBorderType.outline,
            alignedDropdown: true,
            navigationRailUseIndicator: true,
            navigationRailLabelType: NavigationRailLabelType.all,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          cupertinoOverrideTheme:
              const CupertinoThemeData(applyThemeToAll: true),
        ),
        routerConfig: router,
      ),
    );
  }

  void _handleSignOut() {
    sl<NavigationHelper>()
        .key
        .currentContext
        ?.pushReplacementNamed(AuthPage.pageRoute);
  }
}
