import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sentio/widgets/custom_text_field.dart';
import 'package:sentio/widgets/password_strength_indicator.dart';
import 'package:sentio/utilties/utilities.dart';

class AuthFormField extends StatelessWidget {
  final AuthFormFieldType fieldType;
  final bool obscureText;
  final VoidCallback? onSuffixIconTap;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmitted;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const AuthFormField({
    super.key,
    required this.fieldType,
    this.obscureText = false,
    this.onSuffixIconTap,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomFormTextField(
          name: fieldType.fieldName,
          labelText: fieldType.label,
          hintText: fieldType.hint,
          prefixIcon: fieldType.icon,
          suffixIcon: _getSuffixIcon(),
          onSuffixIconTap: onSuffixIconTap,
          obscureText: obscureText,
          textInputAction: textInputAction ?? TextInputAction.next,
          keyboardType: _getKeyboardType(),
          validator: validator ?? _getValidator(context),
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
        if (fieldType == AuthFormFieldType.password) ...[
          const SizedBox(height: 8),
          Builder(
            builder: (context) {
              final formState = FormBuilder.of(context);
              final password = formState?.value['password'] ?? '';
              return PasswordStrengthIndicator(password: password);
            },
          ),
        ],
      ],
    );
  }

  IconData? _getSuffixIcon() {
    if (fieldType == AuthFormFieldType.password ||
        fieldType == AuthFormFieldType.confirmPassword) {
      return obscureText
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined;
    }
    return null;
  }

  TextInputType? _getKeyboardType() {
    switch (fieldType) {
      case AuthFormFieldType.email:
        return TextInputType.emailAddress;
      case AuthFormFieldType.name:
        return TextInputType.name;
      default:
        return TextInputType.text;
    }
  }

  FormFieldValidator<String>? _getValidator(BuildContext context) {
    switch (fieldType) {
      case AuthFormFieldType.name:
        return ValidationHelpers.composeNameValidator();
      case AuthFormFieldType.email:
        return ValidationHelpers.composeEmailValidator();
      case AuthFormFieldType.password:
        return ValidationHelpers.composePasswordValidator();
      case AuthFormFieldType.confirmPassword:
        return ValidationHelpers.composeConfirmPasswordValidator(
          _getPasswordValue(context),
        );
    }
  }

  String _getPasswordValue(BuildContext context) {
    final formState = FormBuilder.of(context);
    return formState?.value['password'] ?? '';
  }
}

// Enum for different auth form field types
enum AuthFormFieldType {
  name('name', 'Full Name', 'Enter your full name', Icons.person),
  email('email', 'Email', 'Enter your email address', Icons.email_outlined),
  password('password', 'Password', 'Enter your password', Icons.lock_outline),
  confirmPassword(
    'confirmPassword',
    'Confirm Password',
    'Re-enter your password',
    Icons.lock_outline,
  );

  final String fieldName;
  final String label;
  final String hint;
  final IconData icon;

  const AuthFormFieldType(this.fieldName, this.label, this.hint, this.icon);
}
