import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerHandler {
  final ImagePicker _picker = ImagePicker();

  Future<List<File>> getRecentGalleryImages() async {
    final permission = Platform.isIOS ? Permission.photos : Permission.photos;
    final status = await permission.request();
    if (!status.isGranted) return [];

    final List<XFile>? files = await _picker.pickMultiImage();
    return files?.map((file) => File(file.path)).toList() ?? [];
  }

  Future<File?> pickFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return null;

    if (!status.isDenied) {
      await Permission.camera.request();
    } else if (!status.isPermanentlyDenied) {
      openAppSettings();
    }

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    return photo != null ? File(photo.path) : null;
  }
}
