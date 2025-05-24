class SignupFormValidation {
  /// Validate username is not empty.
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  /// Validate phone number.
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    // Example: Check if phone is exactly 10 digits.
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  /// Validate email.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password.
  /// Password must be at least 6 characters and include:
  /// one uppercase, one lowercase, and one special character.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    final upperCaseRegExp = RegExp(r'[A-Z]');
    final lowerCaseRegExp = RegExp(r'[a-z]');
    final specialCharRegExp = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!upperCaseRegExp.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!lowerCaseRegExp.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!specialCharRegExp.hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  /// Validate confirm password.
  static String? validateConfirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != original) {
      return 'Passwords do not match';
    }
    return null;
  }
}
