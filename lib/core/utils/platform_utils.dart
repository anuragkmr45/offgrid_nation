import 'dart:io' show Platform;

class PlatformUtils {
  static bool get isIOS => Platform.isIOS;
  static bool get isAndroid => Platform.isAndroid;
}
