import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'dart:ui';

import 'package:sentio/constant.dart';

class CustomFormTextField extends StatelessWidget {
  final String name;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final dynamic Function(String?)? valueTransformer;
  final bool enabled;
  final void Function(String?)? onSaved;
  final AutovalidateMode? autovalidateMode;
  final void Function()? onReset;
  final FocusNode? focusNode;
  final String? restorationId;
  final String? initialValue;
  final Widget Function(BuildContext, String)? errorBuilder;
  final bool readOnly;
  final int? maxLines;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final TextAlign textAlign;
  final bool autofocus;
  final bool autocorrect;
  final double cursorWidth;
  final double? cursorHeight;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final int? maxLength;
  final void Function()? onEditingComplete;
  final void Function(String?)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final Widget? Function(
    BuildContext, {
    required int currentLength,
    required bool isFocused,
    required int? maxLength,
  })?
  buildCounter;
  final bool expands;
  final int? minLines;
  final bool? showCursor;
  final void Function()? onTap;
  final void Function(PointerDownEvent)? onTapOutside;
  final bool enableSuggestions;
  final TextAlignVertical? textAlignVertical;
  final DragStartBehavior dragStartBehavior;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final BoxWidthStyle selectionWidthStyle;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final BoxHeightStyle selectionHeightStyle;
  final Iterable<String>? autofillHints;
  final String obscuringCharacter;
  final MouseCursor? mouseCursor;
  final Widget Function(BuildContext, EditableTextState)? contextMenuBuilder;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final Clip clipBehavior;
  final bool canRequestFocus;
  final Color? cursorErrorColor;
  final bool? cursorOpacityAnimates;
  final bool enableIMEPersonalizedLearning;
  final Object groupId;
  final void Function(String, Map<String, dynamic>)? onAppPrivateCommand;
  final bool onTapAlwaysCalled;
  final bool scribbleEnabled;
  final bool stylusHandwritingEnabled;
  final TextSelectionControls? selectionControls;
  final WidgetStatesController? statesController;
  final UndoHistoryController? undoController;

  const CustomFormTextField({
    Key? key,
    required this.name,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.validator,
    this.onChanged,
    this.valueTransformer,
    this.enabled = true,
    this.onSaved,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onReset,
    this.focusNode,
    this.restorationId,
    this.initialValue,
    this.errorBuilder,
    this.readOnly = false,
    this.maxLines = 1,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.maxLengthEnforcement,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.autocorrect = true,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.keyboardType,
    this.style,
    this.controller,
    this.textInputAction,
    this.strutStyle,
    this.textDirection,
    this.maxLength,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.buildCounter,
    this.expands = false,
    this.minLines,
    this.showCursor,
    this.onTap,
    this.onTapOutside,
    this.enableSuggestions = true,
    this.textAlignVertical,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrollController,
    this.scrollPhysics,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.autofillHints,
    this.obscuringCharacter = '•',
    this.mouseCursor,
    this.contextMenuBuilder,
    this.magnifierConfiguration,
    this.contentInsertionConfiguration,
    this.spellCheckConfiguration,
    this.clipBehavior = Clip.hardEdge,
    this.canRequestFocus = true,
    this.cursorErrorColor,
    this.cursorOpacityAnimates,
    this.enableIMEPersonalizedLearning = true,
    this.groupId = EditableText,
    this.onAppPrivateCommand,
    this.onTapAlwaysCalled = false,
    this.scribbleEnabled = true,
    this.stylusHandwritingEnabled = true,
    this.selectionControls,
    this.statesController,
    this.undoController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.all(defaultMargin),
      child: FormBuilderTextField(
        name: name,
        validator: validator,
        onChanged: onChanged,
        valueTransformer: valueTransformer,
        enabled: enabled,
        onSaved: onSaved,
        autovalidateMode: autovalidateMode,
        onReset: onReset,
        focusNode: focusNode,
        restorationId: restorationId,
        initialValue: initialValue,
        errorBuilder: errorBuilder,
        readOnly: readOnly,
        maxLines: maxLines,
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        scrollPadding: scrollPadding,
        enableInteractiveSelection: enableInteractiveSelection,
        maxLengthEnforcement: maxLengthEnforcement,
        textAlign: textAlign,
        autofocus: autofocus,
        autocorrect: autocorrect,
        cursorWidth: cursorWidth,
        cursorHeight: cursorHeight,
        keyboardType: keyboardType,
        style:
            style ??
            theme.textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
        controller: controller,
        textInputAction: textInputAction,
        strutStyle: strutStyle,
        textDirection: textDirection,
        maxLength: maxLength,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        inputFormatters: inputFormatters,
        cursorRadius: cursorRadius ?? const Radius.circular(2.0),
        cursorColor: cursorColor ?? theme.colorScheme.primary,
        keyboardAppearance: keyboardAppearance,
        buildCounter: buildCounter,
        expands: expands,
        minLines: minLines,
        showCursor: showCursor,
        onTap: onTap,
        onTapOutside: onTapOutside,
        enableSuggestions: enableSuggestions,
        textAlignVertical: textAlignVertical,
        dragStartBehavior: dragStartBehavior,
        scrollController: scrollController,
        scrollPhysics: scrollPhysics,
        selectionWidthStyle: selectionWidthStyle,
        smartDashesType: smartDashesType,
        smartQuotesType: smartQuotesType,
        selectionHeightStyle: selectionHeightStyle,
        autofillHints: autofillHints,
        obscuringCharacter: obscuringCharacter,
        mouseCursor: mouseCursor,
        contextMenuBuilder: contextMenuBuilder,
        magnifierConfiguration: magnifierConfiguration,
        contentInsertionConfiguration: contentInsertionConfiguration,
        spellCheckConfiguration: spellCheckConfiguration,
        clipBehavior: clipBehavior,
        cursorErrorColor: cursorErrorColor,
        cursorOpacityAnimates: cursorOpacityAnimates,
        enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
        groupId: groupId,
        onAppPrivateCommand: onAppPrivateCommand,
        onTapAlwaysCalled: onTapAlwaysCalled,
        stylusHandwritingEnabled: stylusHandwritingEnabled,
        selectionControls: selectionControls,
        statesController: statesController,
        undoController: undoController,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[500] : Colors.grey[600],
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[700],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  size: 22,
                )
              : null,
          suffixIcon: suffixIcon != null
              ? IconButton(
                  icon: Icon(
                    suffixIcon,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    size: 22,
                  ),
                  onPressed: onSuffixIconTap,
                )
              : null,
          filled: true,
          fillColor: isDark
              ? Colors.grey[850]?.withValues(alpha: 0.5)
              : Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          errorStyle: TextStyle(
            color: theme.colorScheme.error,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
