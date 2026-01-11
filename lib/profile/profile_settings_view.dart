import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/utilties/enum.dart';
import 'package:sentio/utilties/utilities.dart';
import 'package:sentio/widgets/secondary_cta.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'English';

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Chinese',
    'Japanese',
  ];

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final language = _languages[index];
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual logout
              context.go(LOGIN);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount() {
    ProfileUIHelpers.showDeleteAccountDialog(
      context,
      onConfirm: () {
        // TODO: Implement actual account deletion
        context.go(LOGIN);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text(PROFILE_SETTINGS),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(doubleDefaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Settings Categories
            ...ProfileSettingsCategory.values.map((category) {
              return _buildSettingsCategory(context, category);
            }).toList(),

            const SizedBox(height: 32),

            // Danger Zone
            _buildDangerZone(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCategory(
    BuildContext context,
    ProfileSettingsCategory category,
  ) {
    final theme = Theme.of(context);

    return Card(
      elevation: defaultElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      margin: const EdgeInsets.only(bottom: doubleDefaultMargin),
      child: InkWell(
        onTap: () => _handleCategoryTap(context, category),
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(doubleDefaultMargin),
          child: Row(
            children: [
              Icon(category.icon, color: theme.colorScheme.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCategoryTap(
    BuildContext context,
    ProfileSettingsCategory category,
  ) {
    switch (category) {
      case ProfileSettingsCategory.personal:
        context.push(EDIT_PROFILE_ROUTE);
        break;
      case ProfileSettingsCategory.preferences:
        _showPreferencesDialog(context);
        break;
      case ProfileSettingsCategory.notifications:
        _showNotificationsDialog(context);
        break;
      case ProfileSettingsCategory.privacy:
        _showPrivacyDialog(context);
        break;
      case ProfileSettingsCategory.theme:
        _showThemeDialog(context);
        break;
      case ProfileSettingsCategory.language:
        _showLanguageDialog();
        break;
      case ProfileSettingsCategory.account:
        _showAccountDialog(context);
        break;
    }
  }

  void _showPreferencesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preferences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Enable Analytics'),
              subtitle: const Text('Help us improve the app'),
              value: true,
              onChanged: (value) {
                // TODO: Implement analytics preference
              },
            ),
            SwitchListTile(
              title: const Text('Auto-save'),
              subtitle: const Text('Save changes automatically'),
              value: true,
              onChanged: (value) {
                // TODO: Implement auto-save preference
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive push notifications'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Receive email updates'),
              value: true,
              onChanged: (value) {
                // TODO: Implement email notifications
              },
            ),
            SwitchListTile(
              title: const Text('SMS Notifications'),
              subtitle: const Text('Receive SMS updates'),
              value: false,
              onChanged: (value) {
                // TODO: Implement SMS notifications
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Profile Visibility'),
              subtitle: const Text('Make profile public'),
              value: true,
              onChanged: (value) {
                // TODO: Implement profile visibility
              },
            ),
            SwitchListTile(
              title: const Text('Activity Status'),
              subtitle: const Text("Show when you're online"),
              value: true,
              onChanged: (value) {
                // TODO: Implement activity status
              },
            ),
            SwitchListTile(
              title: const Text('Data Sharing'),
              subtitle: const Text('Share data with third parties'),
              value: false,
              onChanged: (value) {
                // TODO: Implement data sharing
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<bool>(
              title: const Text('Light Theme'),
              value: false,
              groupValue: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<bool>(
              title: const Text('Dark Theme'),
              value: true,
              groupValue: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<bool?>(
              title: const Text('System Default'),
              value: null,
              groupValue: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = false;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Activity History'),
              subtitle: const Text('View your activity log'),
              onTap: () {
                // TODO: Implement activity history
              },
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text('Active Devices'),
              subtitle: const Text('Manage connected devices'),
              onTap: () {
                // TODO: Implement device management
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Two-Factor Authentication'),
              subtitle: const Text('Enable 2FA for extra security'),
              trailing: Switch(
                value: _biometricEnabled,
                onChanged: (value) {
                  setState(() {
                    _biometricEnabled = value;
                  });
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Danger Zone',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: defaultElevation,
          color: Colors.red.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            side: BorderSide(color: Colors.red.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Sign out of your account'),
                onTap: _handleLogout,
              ),
              const Divider(height: 1, color: Colors.red),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Permanently delete your account'),
                onTap: _handleDeleteAccount,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
