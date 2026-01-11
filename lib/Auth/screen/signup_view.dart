import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:sentio/widgets/primary_cta.dart';
import 'package:sentio/widgets/auth_form_field.dart';
import 'package:sentio/widgets/auth_link.dart';
import 'package:sentio/widgets/divider_with_text.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/utilties/utilities.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Future<void> _handleSignup() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate signup process
        await Future.delayed(const Duration(seconds: 2));

        // Get form values
        final formData = _formKey.currentState?.value;
        final email = formData?['email'] as String?;
        final name = formData?['name'] as String?;

        // TODO: Implement actual signup logic here
        // ignore: avoid_print
        print('Signup attempt with email: $email, name: $name');

        if (mounted) {
          // Navigate to login page after successful signup
          context.go(LOGIN);

          // Show success message
          UIHelpers.showSuccessSnackBar(
            context,
            'Account created successfully! Please sign in.',
          );
        }
      } catch (error) {
        if (mounted) {
          UIHelpers.showErrorSnackBar(
            context,
            'Signup failed: ${error.toString()}',
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
                              Icon(
                                Icons.app_registration,
                                size: 64,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                CREATE_ACCOUNT,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Create your account to get started',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),

                              // Name field
                              AuthFormField(
                                fieldType: AuthFormFieldType.name,
                                onChanged: (value) {
                                  // Trigger validation on change
                                  _formKey.currentState?.fields['name']
                                      ?.validate();
                                },
                              ),
                              const SizedBox(height: 16),

                              // Email field
                              AuthFormField(
                                fieldType: AuthFormFieldType.email,
                                onChanged: (value) {
                                  // Trigger validation on change
                                  _formKey.currentState?.fields['email']
                                      ?.validate();
                                },
                              ),
                              const SizedBox(height: 16),

                              // Password field
                              AuthFormField(
                                fieldType: AuthFormFieldType.password,
                                obscureText: _obscurePassword,
                                onSuffixIconTap: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              const SizedBox(height: 16),

                              // Confirm password field
                              AuthFormField(
                                fieldType: AuthFormFieldType.confirmPassword,
                                obscureText: _obscureConfirmPassword,
                                onSuffixIconTap: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                                onSubmitted: (_) => _handleSignup(),
                              ),
                              const SizedBox(height: 24),

                              // Sign up button
                              PrimaryCTAButton(
                                onPressed: _handleSignup,
                                isLoading: _isLoading,
                                child: Text(
                                  CREATE_ACCOUNT,
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

                              // Sign in link
                              AuthLink(
                                promptText: '$ALREADY_HAVE_ACCOUNT ',
                                linkText: SIGN_IN_HERE,
                                route: LOGIN,
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
