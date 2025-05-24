import 'dart:io';
// import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';

class ImageResizer {
  static const int targetWidth = 1080;
  static const int targetHeight = 1350;

  static Future<File> resizeAndPadImage({
    required File imageFile,
    required Color backgroundColor,
  }) async {
    // Read the image from the file
    final bytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) {
      throw Exception('Unable to decode image.');
    }

    // Calculate the scale to fit the image within the target dimensions
    final scale = [
      targetWidth / originalImage.width,
      targetHeight / originalImage.height,
    ].reduce((a, b) => a < b ? a : b);

    final newWidth = (originalImage.width * scale).round();
    final newHeight = (originalImage.height * scale).round();

    // Resize the image
    final resizedImage = img.copyResize(
      originalImage,
      width: newWidth,
      height: newHeight,
    );

    // Create a new image with the target dimensions and fill with background color
    final background = img.Image(width: targetWidth, height: targetHeight);
    final bgColor = img.ColorRgb8(
      backgroundColor.red,
      backgroundColor.green,
      backgroundColor.blue,
    );
    img.fill(background, color: bgColor);

    // Calculate the position to center the resized image
    final xOffset = ((targetWidth - newWidth) / 2).round();
    final yOffset = ((targetHeight - newHeight) / 2).round();

    // Composite the resized image onto the background
    img.compositeImage(background, resizedImage, dstX: xOffset, dstY: yOffset);

    // Encode the final image to PNG
    final pngBytes = img.encodePng(background);

    // Save the new image to a temporary file
    final tempDir = Directory.systemTemp;
    final outputFile = File('${tempDir.path}/processed_image.png');
    await outputFile.writeAsBytes(pngBytes);

    return outputFile;
  }
}
