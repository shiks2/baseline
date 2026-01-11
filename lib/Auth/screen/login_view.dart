import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:sentio/widgets/custom_text_field.dart';
import 'package:sentio/widgets/primary_cta.dart';
import 'package:sentio/widgets/auth_form_field.dart';
import 'package:sentio/widgets/auth_link.dart';
import 'package:sentio/widgets/divider_with_text.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/utilties/utilities.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate login process
        await Future.delayed(const Duration(seconds: 2));

        // Get form values
        final formData = _formKey.currentState?.value;
        final email = formData?['email'] as String?;

        // TODO: Implement actual login logic here
        // ignore: avoid_print
        print('Login attempt with email: $email');

        // Navigate to dashboard on successful login
        if (mounted) {
          context.go(DASHBOARD);
        }
      } catch (error) {
        // Show error message
        if (mounted) {
          UIHelpers.showErrorSnackBar(
            context,
            'Login failed: ${error.toString()}',
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use a more flexible approach that works for both mobile and desktop
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(doubleDefaultMargin),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Card(
                      elevation: defaultElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadius,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(doubleDefaultMargin),
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header
                              Text(
                                WELCOME_BACK,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                SIGN_IN_TO_ACCOUNT,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

                              // Email Field
                              AuthFormField(
                                fieldType: AuthFormFieldType.email,
                                onChanged: (value) {
                                  // Trigger validation on change
                                  _formKey.currentState?.fields['email']
                                      ?.validate();
                                },
                              ),
                              const SizedBox(height: 16),

                              // Password Field
                              AuthFormField(
                                fieldType: AuthFormFieldType.password,
                                obscureText: _obscurePassword,
                                onSuffixIconTap: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                onSubmitted: (_) => _handleLogin(),
                              ),
                              const SizedBox(height: 8),

                              // Forgot Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // TODO: Implement forgot password
                                    UIHelpers.showSuccessSnackBar(
                                      context,
                                      'Forgot password functionality coming soon!',
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Login Button
                              PrimaryCTAButton(
                                onPressed: _handleLogin,
                                isLoading: _isLoading,
                                child: Text(
                                  SIGN_IN_BUTTON,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Divider
                              const DividerWithText(text: 'OR'),
                              const SizedBox(height: 24),

                              // Sign Up Link
                              AuthLink(
                                promptText: '$DONT_HAVE_ACCOUNT ',
                                linkText:
                                    'Sign Up', // Use exact text expected by tests
                                route: SIGNUP,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
