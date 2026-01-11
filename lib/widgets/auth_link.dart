import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthLink extends StatelessWidget {
  final String promptText;
  final String linkText;
  final String route;
  final TextStyle? promptStyle;
  final TextStyle? linkStyle;

  const AuthLink({
    super.key,
    required this.promptText,
    required this.linkText,
    required this.route,
    this.promptStyle,
    this.linkStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            promptText,
            style:
                promptStyle ??
                TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: () => context.go(route),
          child: Text(
            linkText,
            style:
                linkStyle ??
                TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
