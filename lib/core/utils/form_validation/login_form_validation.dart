class LoginFormValidation {
  /// Validates the username/phone/email field.
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your username, phone, or email';
    }
    // You can add additional regex validation if needed.
    return null;
  }

  /// Validates the password field.
  /// Password must be at least 6 characters and include at least:
  /// - one uppercase letter,
  /// - one lowercase letter,
  /// - one special character.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
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
}
