import 'package:code_streak/core/enums.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DialogWidget extends StatelessWidget {
  DialogWidget({
    super.key,
    this.primary,
    this.icon,
    required this.title,
    required this.description,
    required this.buttons,
    this.iconColor,
  }) : assert(buttons.isNotEmpty);
  final Color? primary;
  final Color? iconColor;
  final IconData? icon;
  final String title, description;
  final List<DialogButton> buttons;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 460),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x14111827),
              blurRadius: 32,
              offset: Offset(0, 16),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) _iconWidget,
            if (icon != null)
              const SizedBox(
                height: 16,
              ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 32,
            ),
            Row(
              children: [
                for (DialogButton button in buttons)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: button.type == ButtonType.primary
                          ? ElevatedButton(
                              onPressed: () => context.pop(button.value),
                              child: Text(button.title),
                            )
                          : TextButton(
                              onPressed: () => context.pop(button.value),
                              child: Text(button.title),
                            ),
                    ),
                  )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget get _iconWidget => Builder(builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (iconColor ??
                    primary ??
                    Theme.of(context).colorScheme.onPrimaryContainer)
                .withOpacity(0.2),
          ),
          child: SizedBox.square(
            dimension: 28,
            child: FittedBox(
              child: Icon(
                icon,
                color: (iconColor ?? primary),
              ),
            ),
          ),
        );
      });
}

class DialogButton<T> {
  final String title;
  final T value;
  final ButtonType type;

  DialogButton({
    required this.title,
    required this.value,
    required this.type,
  });
}
