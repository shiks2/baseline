import 'package:flutter/material.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/utilties/utilities.dart';

class AuthFormCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final double? maxWidth;

  const AuthFormCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.icon,
    this.maxWidth = 400,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(doubleDefaultMargin),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth!),
          child: Card(
            elevation: defaultElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(doubleDefaultMargin),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                  ],
                  if (title != null) ...[
                    Text(
                      title!,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (subtitle != null) ...[
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                  ],
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
