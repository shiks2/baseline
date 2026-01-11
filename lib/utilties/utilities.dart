import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/utilties/enum.dart';

// Validation Helper Methods
class ValidationHelpers {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // FormBuilder validators composition
  static FormFieldValidator<String> composeEmailValidator() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Email is required'),
      FormBuilderValidators.email(
        errorText: 'Please enter a valid email address',
      ),
    ]);
  }

  static FormFieldValidator<String> composePasswordValidator() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Password is required'),
      FormBuilderValidators.minLength(
        6,
        errorText: 'Password must be at least 6 characters',
      ),
    ]);
  }

  static FormFieldValidator<String> composeNameValidator() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Full name is required'),
      FormBuilderValidators.minLength(
        2,
        errorText: 'Name must be at least 2 characters',
      ),
    ]);
  }

  static FormFieldValidator<String> composeConfirmPasswordValidator(
    String password,
  ) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(errorText: 'Please confirm your password'),
      (value) {
        if (value != password) {
          return 'Passwords do not match';
        }
        return null;
      },
    ]);
  }
}

// Password Strength Calculator
class PasswordStrengthCalculator {
  static PasswordStrength calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int strength = 0;

    // Length check
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    // Return strength based on score
    if (strength <= 2) return PasswordStrength.weak;
    if (strength <= 3) return PasswordStrength.fair;
    if (strength <= 4) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  static double getStrengthPercentage(String password) {
    final strength = calculateStrength(password);
    switch (strength) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.fair:
        return 0.5;
      case PasswordStrength.good:
        return 0.75;
      case PasswordStrength.strong:
        return 1.0;
    }
  }
}

// Navigation Helper Methods
class NavigationHelpers {
  // Get navigation destination by index
  static AppNavigationDestination getDestinationByIndex(int index) {
    if (index < 0 || index >= AppNavigationDestination.values.length) {
      return AppNavigationDestination.library;
    }
    return AppNavigationDestination.values[index];
  }

  // Get route path by enum
  static String getRoutePath(AppRoute route) {
    return route.path;
  }

  // Get route name by enum
  static String getRouteName(AppRoute route) {
    return route.name;
  }

  // Get screen size from width
  static ScreenSize getScreenSize(double width) {
    return ScreenSize.fromWidth(width);
  }
}

// Profile validation helpers
class ProfileValidationHelpers {
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone number is optional
    }

    // Basic phone number validation (international format)
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String? validateWebsite(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Website is optional
    }

    // Basic URL validation
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid website URL';
    }
    return null;
  }

  static String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Bio is optional
    }

    if (value.length > 500) {
      return 'Bio must be less than 500 characters';
    }
    return null;
  }

  static String? validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Location is optional
    }

    if (value.length > 100) {
      return 'Location must be less than 100 characters';
    }
    return null;
  }

  static FormFieldValidator<String> composePhoneValidator() {
    return (value) {
      final validators = [
        () => ProfileValidationHelpers.validatePhoneNumber(value),
      ];
      for (final validator in validators) {
        final result = validator();
        if (result != null) return result;
      }
      return null;
    };
  }

  static FormFieldValidator<String> composeWebsiteValidator() {
    return (value) {
      final validators = [
        () => ProfileValidationHelpers.validateWebsite(value),
      ];
      for (final validator in validators) {
        final result = validator();
        if (result != null) return result;
      }
      return null;
    };
  }

  static FormFieldValidator<String> composeBioValidator() {
    return (value) {
      final validators = [() => ProfileValidationHelpers.validateBio(value)];
      for (final validator in validators) {
        final result = validator();
        if (result != null) return result;
      }
      return null;
    };
  }

  static FormFieldValidator<String> composeLocationValidator() {
    return (value) {
      final validators = [
        () => ProfileValidationHelpers.validateLocation(value),
      ];
      for (final validator in validators) {
        final result = validator();
        if (result != null) return result;
      }
      return null;
    };
  }
}

// Profile UI helpers
class ProfileUIHelpers {
  static void showImageSourceDialog(
    BuildContext context, {
    required VoidCallback onCamera,
    required VoidCallback onGallery,
    required VoidCallback onRemove,
    bool showRemove = false,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(defaultMargin * 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                onCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                onGallery();
              },
            ),
            if (showRemove)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onRemove();
                },
              ),
          ],
        ),
      ),
    );
  }

  static void showDeleteAccountDialog(
    BuildContext context, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action cannot be undone. All your data will be permanently deleted.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Type "DELETE" to confirm:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Confirm Delete'),
          ),
        ],
      ),
    );
  }
}

// UI Helper Methods
class UIHelpers {
  // Show loading dialog
  static void showLoadingDialog(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
    );
  }

  // Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Show success snackbar
  static void showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Show error snackbar
  static void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Get responsive padding based on screen size
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final screenSize = ScreenSize.fromWidth(width);

    switch (screenSize) {
      case ScreenSize.small:
        return const EdgeInsets.all(16.0);
      case ScreenSize.medium:
        return const EdgeInsets.all(24.0);
      case ScreenSize.large:
        return const EdgeInsets.all(32.0);
    }
  }

  // Get responsive font size
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    final width = MediaQuery.of(context).size.width;
    final screenSize = ScreenSize.fromWidth(width);

    switch (screenSize) {
      case ScreenSize.small:
        return baseSize * 0.9;
      case ScreenSize.medium:
        return baseSize;
      case ScreenSize.large:
        return baseSize * 1.1;
    }
  }
}

// Form Helper Methods
class FormHelpers {
  // Create common form field decoration
  static InputDecoration getFormFieldDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconTap,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
      ),
      errorStyle: TextStyle(
        color: theme.colorScheme.error,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // Create common card decoration
  static BoxDecoration getCardDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BoxDecoration(
      color: isDark ? Colors.grey[850] : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

// DateTime Helper Methods
class DateTimeHelpers {
  // Format date to readable string
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Format time to readable string
  static String formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Get relative time string
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
