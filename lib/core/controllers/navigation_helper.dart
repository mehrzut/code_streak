import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class NavigationHelper {
  NavigatorState get instance;
  GlobalKey<NavigatorState> get key;
}

@LazySingleton(as: NavigationHelper)
class NavigationHelperImpl implements NavigationHelper {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  NavigatorState get instance => _navigatorKey.currentState!;

  @override
  GlobalKey<NavigatorState> get key => _navigatorKey;
}
