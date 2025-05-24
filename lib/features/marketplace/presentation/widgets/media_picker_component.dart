import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import './media_picker_modal.dart';

class MediaPickerComponent extends StatefulWidget {
  final Function(List<File>) onMediaChanged;

  const MediaPickerComponent({super.key, required this.onMediaChanged});

  @override
  State<MediaPickerComponent> createState() => _MediaPickerComponentState();
}

class _MediaPickerComponentState extends State<MediaPickerComponent> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];

  Future<void> _pickFromCamera() async {
    if (_selectedImages.length >= 10) return;

    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImages.add(File(photo.path));
        widget.onMediaChanged(_selectedImages);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    if (_selectedImages.length >= 10) return;

    final permission = Platform.isIOS ? Permission.photos : Permission.photos;
    final status = await permission.request();
    if (!status.isGranted) return;

    final List<XFile>? files = await _picker.pickMultiImage();
    if (files != null && files.isNotEmpty) {
      final availableSlots = 10 - _selectedImages.length;
      final toAdd = files.take(availableSlots).map((f) => File(f.path));
      setState(() {
        _selectedImages.addAll(toAdd);
        widget.onMediaChanged(_selectedImages);
      });
    }
  }

  void _showPickerModal() {
    if (_selectedImages.length >= 10) return;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _openCarousel(int startIndex) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Image Viewer",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder:
          (_, __, ___) => MediaPickerModal(
            images: _selectedImages,
            initialIndex: startIndex,
          ),
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  void _removeImage(int index) async {
    final confirm =
        Platform.isIOS
            ? await showCupertinoDialog<bool>(
              context: context,
              builder:
                  (_) => CupertinoAlertDialog(
                    title: const Text('Remove Image'),
                    content: const Text('Do you want to remove this image?'),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Remove'),
                      ),
                    ],
                  ),
            )
            : await showDialog<bool>(
              context: context,
              builder:
                  (_) => AlertDialog(
                    title: const Text('Remove Image'),
                    content: const Text('Do you want to remove this image?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
            );

    if (confirm == true) {
      setState(() {
        _selectedImages.removeAt(index);
        widget.onMediaChanged(_selectedImages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: _showPickerModal,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEAEAEA),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ..._selectedImages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final image = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => _openCarousel(index),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  image,
                                  width: 54,
                                  height: 54,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Photos : ${_selectedImages.length}/10',
          style: const TextStyle(fontSize: 13),
        ),
      ],
    );
  }
}
