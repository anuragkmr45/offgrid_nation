import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageUtils {
  /// Compresses the image to JPEG format with reduced quality (default 70%)
  static Future<File> compressImage(
    File originalFile, {
    int quality = 70,
  }) async {
    try {
      final bytes = await originalFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception('Failed to decode image.');

      final compressedBytes = img.encodeJpg(image, quality: quality);
      final tempDir = await getTemporaryDirectory();
      final compressedFilePath = path.join(
        tempDir.path,
        'compressed_${path.basename(originalFile.path)}',
      );
      final compressedFile = await File(
        compressedFilePath,
      ).writeAsBytes(Uint8List.fromList(compressedBytes));
      return compressedFile;
    } catch (e) {
      throw Exception('Image compression failed: $e');
    }
  }
}
