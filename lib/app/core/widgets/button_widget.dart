import 'package:fakestore/app/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

enum ButtonType {
  dark,
  light;
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    required this.type,
    required this.label,
    required this.onTap,
    super.key,
  });

  final ButtonType type;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: type == ButtonType.dark //
                ? context.themeC.buttonBackground
                : context.themeC.background,
          ),
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Center(
            child: Text(
              label,
              style: context.themeC.textStyle.copyWith(
                color: type == ButtonType.dark //
                    ? context.themeC.background
                    : context.themeC.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
}
