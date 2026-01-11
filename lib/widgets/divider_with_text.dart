import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Color? dividerColor;

  const DividerWithText({
    super.key,
    required this.text,
    this.textStyle,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: Divider(
            color:
                dividerColor ?? (isDark ? Colors.grey[700] : Colors.grey[300]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style:
                textStyle ??
                TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          child: Divider(
            color:
                dividerColor ?? (isDark ? Colors.grey[700] : Colors.grey[300]),
          ),
        ),
      ],
    );
  }
}
