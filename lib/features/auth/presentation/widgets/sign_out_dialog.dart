import 'package:code_streak/core/enums.dart';
import 'package:code_streak/core/widget/dialog_widget.dart';
import 'package:flutter/material.dart';

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
        title: 'Sign Out',
        description: 'Are you sure you want to sign out?',
        primary: Theme.of(context).colorScheme.errorContainer,
        buttons: [
          DialogButton(
            title: 'Cancel',
            type: ButtonType.text,
            value: false,
          ),
          DialogButton(
            title: 'Sign Out',
            type: ButtonType.warning,
            value: true,
          ),
        ]);
  }
}
