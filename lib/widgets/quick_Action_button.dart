import 'package:flutter/material.dart';

/// Quick Action Button - Lightweight button for secondary actions like Create, Add, Edit, Filter, etc.
class QuickActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final void Function(bool)? onHover;
  final void Function(bool)? onFocusChange;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;
  final Widget? icon;
  final IconData? iconData;
  final Widget label;
  final String? labelText;
  final IconAlignment iconAlignment;
  
  // Custom styling properties
  final QuickActionStyle actionStyle;
  final QuickActionSize actionSize;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool showBorder;

  const QuickActionButton({
    Key? key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
    this.icon,
    this.iconData,
    required this.label,
    this.labelText,
    this.iconAlignment = IconAlignment.start,
    this.actionStyle = QuickActionStyle.filled,
    this.actionSize = QuickActionSize.medium,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.isLoading = false,
    this.showBorder = false,
  }) : super(key: key);

  // Convenience constructors
  factory QuickActionButton.create({
    Key? key,
    required VoidCallback? onPressed,
    String label = 'Create',
    IconData icon = Icons.add,
    QuickActionStyle style = QuickActionStyle.filled,
    QuickActionSize size = QuickActionSize.medium,
    bool isLoading = false,
  }) {
    return QuickActionButton(
      key: key,
      onPressed: onPressed,
      iconData: icon,
      label: Text(label),
      actionStyle: style,
      actionSize: size,
      isLoading: isLoading,
    );
  }

  factory QuickActionButton.add({
    Key? key,
    required VoidCallback? onPressed,
    String label = 'Add',
    IconData icon = Icons.add_circle_outline,
    QuickActionStyle style = QuickActionStyle.filled,
    QuickActionSize size = QuickActionSize.medium,
    bool isLoading = false,
  }) {
    return QuickActionButton(
      key: key,
      onPressed: onPressed,
      iconData: icon,
      label: Text(label),
      actionStyle: style,
      actionSize: size,
      isLoading: isLoading,
    );
  }

  factory QuickActionButton.edit({
    Key? key,
    required VoidCallback? onPressed,
    String label = 'Edit',
    IconData icon = Icons.edit_outlined,
    QuickActionStyle style = QuickActionStyle.outlined,
    QuickActionSize size = QuickActionSize.medium,
  }) {
    return QuickActionButton(
      key: key,
      onPressed: onPressed,
      iconData: icon,
      label: Text(label),
      actionStyle: style,
      actionSize: size,
    );
  }

  factory QuickActionButton.filter({
    Key? key,
    required VoidCallback? onPressed,
    String label = 'Filter',
    IconData icon = Icons.filter_list,
    QuickActionStyle style = QuickActionStyle.outlined,
    QuickActionSize size = QuickActionSize.medium,
  }) {
    return QuickActionButton(
      key: key,
      onPressed: onPressed,
      iconData: icon,
      label: Text(label),
      actionStyle: style,
      actionSize: size,
    );
  }

  factory QuickActionButton.export({
    Key? key,
    required VoidCallback? onPressed,
    String label = 'Export',
    IconData icon = Icons.download,
    QuickActionStyle style = QuickActionStyle.text,
    QuickActionSize size = QuickActionSize.medium,
  }) {
    return QuickActionButton(
      key: key,
      onPressed: onPressed,
      iconData: icon,
      label: Text(label),
      actionStyle: style,
      actionSize: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Get size properties
    final sizeProps = _getSizeProperties();
    
    // Build icon widget
    final iconWidget = isLoading
        ? SizedBox(
            width: sizeProps.iconSize,
            height: sizeProps.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getForegroundColor(theme),
              ),
            ),
          )
        : icon ?? Icon(iconData, size: sizeProps.iconSize);

    switch (actionStyle) {
      case QuickActionStyle.filled:
        return _buildFilledButton(context, theme, isDark, sizeProps, iconWidget);
      case QuickActionStyle.outlined:
        return _buildOutlinedButton(context, theme, isDark, sizeProps, iconWidget);
      case QuickActionStyle.text:
        return _buildTextButton(context, theme, isDark, sizeProps, iconWidget);
    }
  }

  Widget _buildFilledButton(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    _QuickActionSizeProperties props,
    Widget iconWidget,
  ) {
    final color = foregroundColor ?? theme.colorScheme.primary;
    final bgColor = isDark 
        ? color.withOpacity(0.15)
        : color.withOpacity(0.1);

    return SizedBox(
      height: props.height,
      child: TextButton.icon(
        onPressed: isLoading ? null : onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        icon: iconWidget,
        label: label,
        iconAlignment: iconAlignment,
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: padding ?? props.padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            side: showBorder 
                ? BorderSide(color: color.withOpacity(0.3), width: 1)
                : BorderSide.none,
          ),
          textStyle: TextStyle(
            fontSize: props.fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return isDark ? Colors.grey[800]! : Colors.grey[200]!;
            }
            if (states.contains(WidgetState.pressed)) {
              return color.withOpacity(0.2);
            }
            if (states.contains(WidgetState.hovered)) {
              return color.withOpacity(0.15);
            }
            return bgColor;
          }),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    _QuickActionSizeProperties props,
    Widget iconWidget,
  ) {
    final color = foregroundColor ?? theme.colorScheme.primary;

    return SizedBox(
      height: props.height,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        icon: iconWidget,
        label: label,
        iconAlignment: iconAlignment,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          padding: padding ?? props.padding,
          side: BorderSide(color: color.withOpacity(0.5), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: props.fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ).copyWith(
          side: WidgetStateProperty.resolveWith<BorderSide>((states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1.2,
              );
            }
            if (states.contains(WidgetState.hovered)) {
              return BorderSide(color: color, width: 1.5);
            }
            return BorderSide(color: color.withOpacity(0.5), width: 1.2);
          }),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.hovered)) {
              return color.withOpacity(0.05);
            }
            if (states.contains(WidgetState.pressed)) {
              return color.withOpacity(0.1);
            }
            return Colors.transparent;
          }),
        ),
      ),
    );
  }

  Widget _buildTextButton(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    _QuickActionSizeProperties props,
    Widget iconWidget,
  ) {
    final color = foregroundColor ?? theme.colorScheme.primary;

    return SizedBox(
      height: props.height,
      child: TextButton.icon(
        onPressed: isLoading ? null : onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        icon: iconWidget,
        label: label,
        iconAlignment: iconAlignment,
        style: TextButton.styleFrom(
          foregroundColor: color,
          padding: padding ?? props.padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
          ),
          textStyle: TextStyle(
            fontSize: props.fontSize,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.hovered)) {
              return color.withOpacity(0.08);
            }
            if (states.contains(WidgetState.pressed)) {
              return color.withOpacity(0.12);
            }
            return Colors.transparent;
          }),
        ),
      ),
    );
  }

  Color _getForegroundColor(ThemeData theme) {
    return foregroundColor ?? theme.colorScheme.primary;
  }

  _QuickActionSizeProperties _getSizeProperties() {
    switch (actionSize) {
      case QuickActionSize.compact:
        return _QuickActionSizeProperties(
          height: 32,
          fontSize: 13,
          iconSize: 16,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        );
      case QuickActionSize.medium:
        return _QuickActionSizeProperties(
          height: 38,
          fontSize: 14,
          iconSize: 18,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        );
      case QuickActionSize.large:
        return _QuickActionSizeProperties(
          height: 42,
          fontSize: 15,
          iconSize: 20,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        );
    }
  }
}

enum QuickActionStyle {
  filled,    // Subtle filled background
  outlined,  // Border only
  text,      // Text only, no background
}

enum QuickActionSize {
  compact,   // 32px height - for toolbars
  medium,    // 38px height - default
  large,     // 42px height - for headers
}

class _QuickActionSizeProperties {
  final double height;
  final double fontSize;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  _QuickActionSizeProperties({
    required this.height,
    required this.fontSize,
    required this.iconSize,
    required this.padding,
  });
}
