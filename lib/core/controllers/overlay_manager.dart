import 'package:code_streak/features/auth/presentation/widgets/sign_out_dialog.dart';
import 'package:flutter/material.dart';

class OverlayManager {
  static Future<T?> _showDialog<T>(BuildContext context,
      {required Widget child}) {
    return showDialog<T>(
      context: context,
      builder: (context) => child,
    );
  }

  static Future<bool?> showSignOutDialog(BuildContext context) async {
    return _showDialog<bool>(context, child: const SignOutDialog());
  }
}
