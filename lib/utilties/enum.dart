import 'package:flutter/material.dart';
import 'package:sentio/constant.dart';

// Navigation Destinations Enum
enum AppNavigationDestination {
  library(Icons.library_books, NAV_LIBRARY),
  assets(Icons.factory, NAV_ASSETS),
  profile(Icons.person_2, NAV_PROFILE),
  indexFile(Icons.upload_file_rounded, NAV_INDEX_FILE),
  settings(Icons.settings, NAV_SETTINGS);

  final IconData icon;
  final String label;

  const AppNavigationDestination(this.icon, this.label);
}

// App Routes Enum
enum AppRoute {
  splash(SPLASH, 'Splash'),
  home(HOME, 'Home'),
  login(LOGIN, 'Login'),
  signup(SIGNUP, 'Sign Up'),
  dashboard(DASHBOARD, 'Dashboard');

  final String path;
  final String name;

  const AppRoute(this.path, this.name);
}

// Authentication Form Fields Enum
enum AuthFormField {
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

  const AuthFormField(this.fieldName, this.label, this.hint, this.icon);
}

// Password Strength Enum
enum PasswordStrength {
  weak('Weak', Colors.red),
  fair('Fair', Colors.orange),
  good('Good', Colors.yellow),
  strong('Strong', Colors.green);

  final String label;
  final Color color;

  const PasswordStrength(this.label, this.color);
}

// Form Validation Types Enum
enum ValidationType { required, email, minLength, passwordMatch, name }

// Button Types Enum
enum ButtonType { primary, secondary, text }

// Screen Sizes Enum for Responsive Design
enum ScreenSize {
  small(0, 600),
  medium(601, 1200),
  large(1201, double.infinity);

  final double minWidth;
  final double maxWidth;

  const ScreenSize(this.minWidth, this.maxWidth);

  static ScreenSize fromWidth(double width) {
    if (width <= 600) return ScreenSize.small;
    if (width <= 1200) return ScreenSize.medium;
    return ScreenSize.large;
  }
}

// Profile field types
enum ProfileFieldType {
  fullName('fullName', 'Full Name', 'Enter your full name', Icons.person),
  email(
    'email',
    'Email Address',
    'Enter your email address',
    Icons.email_outlined,
  ),
  phone('phone', 'Phone Number', 'Enter your phone number', Icons.phone),
  bio('bio', 'Bio', 'Tell us about yourself', Icons.info_outline),
  location('location', 'Location', 'Enter your location', Icons.location_on),
  website('website', 'Website', 'Enter your website URL', Icons.link);

  final String fieldName;
  final String label;
  final String hint;
  final IconData icon;

  const ProfileFieldType(this.fieldName, this.label, this.hint, this.icon);
}

// Profile settings categories
enum ProfileSettingsCategory {
  personal(
    'Personal Information',
    Icons.person,
    'Update your personal details',
  ),
  preferences('Preferences', Icons.settings, 'Customize your app experience'),
  notifications(
    'Notifications',
    Icons.notifications,
    'Manage notification settings',
  ),
  privacy(
    'Privacy & Security',
    Icons.security,
    'Control your privacy settings',
  ),
  theme('Theme & Display', Icons.palette, 'Customize appearance'),
  language('Language', Icons.language, 'Change app language'),
  account('Account', Icons.account_circle, 'Manage your account');

  final String title;
  final IconData icon;
  final String description;

  const ProfileSettingsCategory(this.title, this.icon, this.description);
}

// Profile image source options
enum ProfileImageSource {
  camera('Camera', Icons.camera_alt),
  gallery('Gallery', Icons.photo_library),
  remove('Remove Photo', Icons.delete);

  final String label;
  final IconData icon;

  const ProfileImageSource(this.label, this.icon);
}

// Indexer field types and status
enum IndexerStatus {
  idle('Ready to index', Icons.pause),
  indexing('Indexing in progress...', Icons.sync),
  completed('Indexing completed', Icons.check_circle),
  failed('Indexing failed', Icons.error),
  stopped('Indexing stopped', Icons.stop);

  final String label;
  final IconData icon;

  const IndexerStatus(this.label, this.icon);
}

enum IndexerFileType {
  dwg('AutoCAD DWG', Icons.drafts, '.dwg'),
  pdf('PDF Document', Icons.picture_as_pdf, '.pdf'),
  rvt('Revit Model', Icons.architecture, '.rvt'),
  skp('SketchUp Model', Icons.view_in_ar, '.skp'),
  all('All Files', Icons.folder_open, '*');

  final String label;
  final IconData icon;
  final String extension;

  const IndexerFileType(this.label, this.icon, this.extension);
}
