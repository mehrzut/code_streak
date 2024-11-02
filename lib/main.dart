import 'dart:developer';

import 'package:code_streak/router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

void main() async {
  await _loadEnv();
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
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
