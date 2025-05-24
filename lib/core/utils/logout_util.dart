import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LogoutUtil {
  static Future<void> logoutUser(BuildContext context) async {
    try {
      const FlutterSecureStorage secureStorage = FlutterSecureStorage();

      // Clear secure session
      await secureStorage.deleteAll();

      // Wait for the storage operation to complete fully
      await Future.delayed(const Duration(milliseconds: 300));

      // Navigate to login screen and remove all previous routes
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil('/auth/login', (Route<dynamic> route) => false);
    } catch (e) {
      debugPrint('[LogoutUtil] Logout failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout failed. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
