import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:offgrid_nation_app/core/widgets/custom_modal.dart';

class MediaUtils {
  static final ImagePicker _picker = ImagePicker();

  /// ✅ Pick image from camera or gallery with permission check
  static Future<File?> pickImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    final hasPermission = await _checkAndRequestPermission(context, source);
    if (!hasPermission) return null;

    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 100,
    );

    return pickedFile != null ? File(pickedFile.path) : null;
  }

  /// ✅ Show image source picker modal
  static Future<File?> showPickerModal(BuildContext context) async {
    File? selectedFile;

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext modalContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(modalContext);
                  final image = await pickImage(
                    context: context,
                    source: ImageSource.camera,
                  );
                  selectedFile = image;
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(modalContext);
                  final image = await pickImage(
                    context: context,
                    source: ImageSource.gallery,
                  );
                  selectedFile = image;
                },
              ),
            ],
          ),
        );
      },
    );

    // Wait a bit to ensure modal is popped before returning
    await Future.delayed(const Duration(milliseconds: 100));
    return selectedFile;
  }

  // static Future<File?> showPickerModal(BuildContext context) async {
  //   File? selectedFile;

  //   await CustomModal.show(
  //     context: context,
  //     title: 'Add Profile Photo',
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         const SizedBox(height: 12),
  //         ListTile(
  //           leading: const Icon(Icons.camera_alt),
  //           title: const Text('Take Photo'),
  //           onTap: () async {
  //             Navigator.pop(context);
  //             final image = await pickImage(
  //               context: context,
  //               source: ImageSource.camera,
  //             );
  //             selectedFile = image;
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.photo_library),
  //           title: const Text('Choose from Gallery'),
  //           onTap: () async {
  //             Navigator.pop(context);
  //             final image = await pickImage(
  //               context: context,
  //               source: ImageSource.gallery,
  //             );
  //             selectedFile = image;
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   return selectedFile;
  // }

  /// ✅ Cross-platform permission check with Android version handling
  static Future<bool> _checkAndRequestPermission(
    BuildContext context,
    ImageSource source,
  ) async {
    Permission permission;

    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      if (Platform.isAndroid) {
        if (Platform.version.contains('13') ||
            Platform.version.contains('14')) {
          permission = Permission.photos; // or READ_MEDIA_IMAGES
        } else {
          permission = Permission.storage;
        }
      } else {
        permission = Permission.photos;
      }
    }

    final status = await permission.status;

    if (status.isGranted) return true;

    final result = await permission.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      await _showPermissionDialog(context);
    }

    return false;
  }

  /// ✅ Show modal when permission permanently denied
  static Future<void> _showPermissionDialog(BuildContext context) async {
    await CustomModal.show(
      context: context,
      title: 'Permission Required',
      content: const Text(
        'Please grant media access permission from app settings to use this feature.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await openAppSettings();
          },
          child: const Text('Open Settings'),
        ),
      ],
    );
  }
}
