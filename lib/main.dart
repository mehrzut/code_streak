import 'dart:developer';
import 'package:code_streak/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:code_streak/injector.dart';
import 'package:code_streak/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadEnv();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.instance.requestPermission();
  await configureDependencies();
  runApp(const MainApp());
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
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
