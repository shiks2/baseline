import 'package:flutter/material.dart';

/// Primary CTA Button - Use for main actions (Submit, Login, Register, Download)
class PrimaryCTAButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;
  final Widget child;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;

  const PrimaryCTAButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width,
      height: height ?? 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: backgroundColor ?? theme.colorScheme.primary,
              foregroundColor: foregroundColor ?? Colors.white,
              elevation: elevation ?? 2,
              shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
              padding:
                  padding ??
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius ?? BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ).copyWith(
              elevation: WidgetStateProperty.resolveWith<double>((states) {
                if (states.contains(WidgetState.disabled)) return 0;
                if (states.contains(WidgetState.pressed)) return 6;
                if (states.contains(WidgetState.hovered)) return 4;
                return elevation ?? 2;
              }),
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.disabled)) {
                  return isDark ? Colors.grey[800]! : Colors.grey[300]!;
                }
                if (states.contains(WidgetState.pressed)) {
                  return (backgroundColor ?? theme.colorScheme.primary)
                      .withValues(alpha: 0.8);
                }
                if (states.contains(WidgetState.hovered)) {
                  return (backgroundColor ?? theme.colorScheme.primary)
                      .withValues(alpha: 0.9);
                }
                return backgroundColor ?? theme.colorScheme.primary;
              }),
            ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? Colors.white,
                  ),
                ),
              )
            : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 10),
                  child,
                ],
              )
            : child,
      ),
    );
  }
}
