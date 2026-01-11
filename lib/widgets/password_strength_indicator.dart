import 'package:flutter/material.dart';

enum PasswordStrength { weak, fair, good, strong }

class PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  final bool showText;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.showText = true,
  });

  PasswordStrength _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety checks
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    // Return strength based on score
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 3) return PasswordStrength.fair;
    if (score <= 4) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  Color _getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return Colors.red;
      case PasswordStrength.fair:
        return Colors.orange;
      case PasswordStrength.good:
        return Colors.blue;
      case PasswordStrength.strong:
        return Colors.green;
    }
  }

  String _getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  double _getStrengthProgress(PasswordStrength strength) {
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

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final strength = _calculateStrength(password);
    final color = _getStrengthColor(strength);
    final progress = _getStrengthProgress(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4,
              ),
            ),
            if (showText) ...[
              const SizedBox(width: 12),
              Text(
                _getStrengthText(strength),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        _buildRequirements(),
      ],
    );
  }

  Widget _buildRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRequirement('At least 8 characters', password.length >= 8),
        _buildRequirement(
          'Contains uppercase letter',
          RegExp(r'[A-Z]').hasMatch(password),
        ),
        _buildRequirement(
          'Contains lowercase letter',
          RegExp(r'[a-z]').hasMatch(password),
        ),
        _buildRequirement(
          'Contains number',
          RegExp(r'[0-9]').hasMatch(password),
        ),
      ],
    );
  }

  Widget _buildRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: isMet ? Colors.green : Colors.grey[600],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
