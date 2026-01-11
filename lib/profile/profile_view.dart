import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:sentio/constant.dart';
import 'package:sentio/utilties/enum.dart';
import 'package:sentio/utilties/utilities.dart';
import 'package:sentio/widgets/primary_cta.dart';
import 'package:sentio/widgets/secondary_cta.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isEditing = false;
  bool _isLoading = false;

  // Sample user data - in a real app, this would come from a user provider/service
  final Map<String, dynamic> _userData = {
    'fullName': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+1234567890',
    'bio': 'Software developer passionate about creating amazing apps.',
    'location': 'San Francisco, CA',
    'website': 'https://johndoe.com',
  };

  Future<void> _handleSaveProfile() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        // Update user data
        final formData = _formKey.currentState?.value;
        _userData.addAll(formData ?? {});

        // Show success message
        if (mounted) {
          UIHelpers.showSuccessSnackBar(context, PROFILE_UPDATED);
          setState(() {
            _isEditing = false;
          });
        }
      } catch (error) {
        if (mounted) {
          UIHelpers.showErrorSnackBar(
            context,
            '$PROFILE_UPDATE_FAILED: ${error.toString()}',
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

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _navigateToSettings() {
    context.push(PROFILE_SETTINGS_ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text(PROFILE),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
            onPressed: _toggleEditMode,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(doubleDefaultMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Header
            _buildProfileHeader(context),
            const SizedBox(height: 32),

            // Profile Information
            if (_isEditing) ...[
              _buildEditForm(context),
            ] else ...[
              _buildProfileInfo(context),
            ],

            const SizedBox(height: 32),

            // Action Buttons
            if (_isEditing) ...[
              PrimaryCTAButton(
                onPressed: _handleSaveProfile,
                isLoading: _isLoading,
                child: const Text(SAVE_CHANGES),
              ),
              const SizedBox(height: 16),
              SecondaryCTAButton(
                onPressed: _toggleEditMode,
                child: const Text(CANCEL),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          // Profile Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                child: const Icon(Icons.person, size: 60, color: Colors.grey),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Handle image change
                      ProfileUIHelpers.showImageSourceDialog(
                        context,
                        onCamera: () {
                          // Handle camera
                        },
                        onGallery: () {
                          // Handle gallery
                        },
                        onRemove: () {
                          // Handle remove
                        },
                        showRemove: true,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // User Name
          Text(
            _userData['fullName'] ?? 'User Name',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // User Email
          Text(
            _userData['email'] ?? 'user@example.com',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(BuildContext context) {
    final theme = Theme.of(context);

    return FormBuilder(
      key: _formKey,
      initialValue: _userData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name
          _buildProfileField(
            context,
            ProfileFieldType.fullName,
            validator: ValidationHelpers.composeNameValidator(),
          ),
          const SizedBox(height: 16),

          // Email (read-only)
          _buildReadOnlyField(
            context,
            ProfileFieldType.email,
            initialValue: _userData['email'],
          ),
          const SizedBox(height: 16),

          // Phone Number
          _buildProfileField(
            context,
            ProfileFieldType.phone,
            validator: ProfileValidationHelpers.composePhoneValidator(),
          ),
          const SizedBox(height: 16),

          // Bio
          _buildProfileField(
            context,
            ProfileFieldType.bio,
            maxLines: 3,
            validator: ProfileValidationHelpers.composeBioValidator(),
          ),
          const SizedBox(height: 16),

          // Location
          _buildProfileField(
            context,
            ProfileFieldType.location,
            validator: ProfileValidationHelpers.composeLocationValidator(),
          ),
          const SizedBox(height: 16),

          // Website
          _buildProfileField(
            context,
            ProfileFieldType.website,
            validator: ProfileValidationHelpers.composeWebsiteValidator(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildInfoCard(
          context,
          icon: ProfileFieldType.phone.icon,
          title: ProfileFieldType.phone.label,
          value: _userData['phone'] ?? 'Not provided',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          icon: ProfileFieldType.bio.icon,
          title: ProfileFieldType.bio.label,
          value: _userData['bio'] ?? 'No bio provided',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          icon: ProfileFieldType.location.icon,
          title: ProfileFieldType.location.label,
          value: _userData['location'] ?? 'Not provided',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          icon: ProfileFieldType.website.icon,
          title: ProfileFieldType.website.label,
          value: _userData['website'] ?? 'Not provided',
          isLink: true,
        ),
      ],
    );
  }

  Widget _buildProfileField(
    BuildContext context,
    ProfileFieldType fieldType, {
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldType.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        FormBuilderTextField(
          name: fieldType.fieldName,
          decoration: InputDecoration(
            hintText: fieldType.hint,
            prefixIcon: Icon(fieldType.icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
          ),
          validator: validator,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _buildReadOnlyField(
    BuildContext context,
    ProfileFieldType fieldType, {
    String? initialValue,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fieldType.label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: Icon(fieldType.icon, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface.withOpacity(0.5),
          ),
          style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    bool isLink = false,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: defaultElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isLink ? theme.colorScheme.primary : null,
          ),
        ),
        trailing: isLink ? const Icon(Icons.open_in_new, size: 16) : null,
        onTap: isLink ? () => _launchURL(value) : null,
      ),
    );
  }

  void _launchURL(String url) {
    // TODO: Implement URL launcher
    // For now, just show a snackbar
    UIHelpers.showSuccessSnackBar(context, 'Opening: $url');
  }
}
