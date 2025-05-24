abstract class AppException implements Exception {
  final String? message;
  final int? code;

  const AppException([this.message, this.code]);

  @override
  String toString() => message ?? "AppException";
}
