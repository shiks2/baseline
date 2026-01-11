import 'package:flutter/material.dart';

/// Secondary CTA Button - Use for secondary actions (Cancel, Back, Skip)
class SecondaryCTAButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;
  final bool? isSemanticButton;
  final Widget child;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final bool outlined;

  const SecondaryCTAButton({
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
    this.isSemanticButton = true,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
    this.foregroundColor,
    this.borderRadius,
    this.outlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (outlined) {
      return SizedBox(
        width: width,
        height: height ?? 54,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          onLongPress: onLongPress,
          onHover: onHover,
          onFocusChange: onFocusChange,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior ?? Clip.none,
          statesController: statesController,
          style: OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            side: BorderSide(
              color: foregroundColor ?? theme.colorScheme.primary,
              width: 2,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      foregroundColor ?? theme.colorScheme.primary,
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

    return SizedBox(
      width: width,
      height: height ?? 54,
      child: TextButton(
        onPressed: isLoading ? null : onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        isSemanticButton: isSemanticButton,
        style: TextButton.styleFrom(
          foregroundColor: foregroundColor ?? theme.colorScheme.primary,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.hovered)) {
              return (foregroundColor ?? theme.colorScheme.primary).withOpacity(0.08);
            }
            if (states.contains(WidgetState.pressed)) {
              return (foregroundColor ?? theme.colorScheme.primary).withOpacity(0.12);
            }
            return Colors.transparent;
          }),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    foregroundColor ?? theme.colorScheme.primary,
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