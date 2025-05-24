import 'app_exception.dart';

class ErrorHandler {
  /// Returns a user-friendly error message based on the provided error.
  static String handle(dynamic error) {
    if (error is AppException) {
      return error.message ?? "An error occurred. Please try again.";
    }
    return "Unexpected error occurred. Please contact support.";
  }
}
