import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/utils/location_utils.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/add_post_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/add_post_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/add_post_state.dart';
import 'package:offgrid_nation_app/injection_container.dart';
import '../widget/post/image_picker_handler.dart';
import '../widget/post/add_post_text.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final ImagePickerHandler _imagePicker = ImagePickerHandler();
  List<File> _selectedImages = [];
  String? _currentLocation;

  void _handlePost(String text) {
    BlocProvider.of<AddPostBloc>(context).add(
      SubmitPostEvent(
        content: text,
        location: _currentLocation,
        mediaFiles: _selectedImages,
      ),
    );
  }

  void _handleCameraTap() async {
    final photo = await _imagePicker.pickFromCamera();
    if (photo != null) {
      setState(() {
        _selectedImages.add(photo);
      });
    }
  }

  void _handleLocationTap() async {
    final granted = await LocationUtils.requestLocationPermission();

    if (!granted) {
      await LocationUtils.showLocationDeniedDialog(context);
      return;
    }

    final location = await LocationUtils.getFormattedLocation();
    if (location == null) {
      await LocationUtils.showLocationDeniedDialog(context);
    } else {
      setState(() => _currentLocation = location);
    }
  }

  Future<void> _handleGalleryAccess() async {
    final images = await _imagePicker.getRecentGalleryImages();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No images selected or permission denied'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddPostBloc>(
      create: (_) => sl<AddPostBloc>(),
      child: BlocListener<AddPostBloc, AddPostState>(
        listener: (context, state) {
          // if (state is AddPostSuccess) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('Post uploaded successfully')),
          //   );
          //   setState(() {
          //     _selectedImages.clear();
          //     _currentLocation = null;
          //   });
          // }
          if (state is AddPostSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post uploaded successfully')),
            );

            // 🧼 Clear current form
            setState(() {
              _selectedImages.clear();
              _currentLocation = null;
            });

            // ✅ Navigate to FeedScreen and refresh it
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home', // Assuming '/home' contains FeedScreen as first tab or main screen
              (route) => false,
            );

            // Dispatch feed refresh using microtask so it triggers after screen builds
            Future.microtask(() {
              GetIt.I<ContentBloc>().add(const FetchContentRequested());
            });
          } else if (state is AddPostFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to post: ${state.error}')),
            );
          }
        },
        child:
            Platform.isIOS ? _buildCupertino(context) : _buildMaterial(context),
      ),
    );
  }

  Widget _buildMaterial(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ SCROLLABLE FIX
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PostTextBar(
                  onPost: _handlePost,
                  onCameraTap: _handleCameraTap,
                  onLocationTap: _handleLocationTap,
                  mediaFiles: _selectedImages,
                  location: _currentLocation,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: _handleGalleryAccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Get Gallery Images',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (_selectedImages.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    height: 340,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: PageView.builder(
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _selectedImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(
                                      () => _selectedImages.removeAt(index),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.black54,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCupertino(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.primary,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PostTextBar(
                onPost: _handlePost,
                onCameraTap: _handleCameraTap,
                onLocationTap: _handleLocationTap,
                mediaFiles: _selectedImages,
                location: _currentLocation,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: _handleGalleryAccess,
                child: const Text('Get Gallery Images'),
              ),
            ),
            const SizedBox(height: 8),
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 340,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PageView.builder(
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _selectedImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: GestureDetector(
                              onTap: () {
                                _confirmDelete(index);
                                // setState(() => _selectedImages.removeAt(index));
                              },
                              child: const CircleAvatar(
                                radius: 16,
                                backgroundColor: CupertinoColors.systemGrey,
                                child: Icon(
                                  CupertinoIcons.clear,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int index) async {
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
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(false),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: const Text('Remove'),
                        onPressed: () => Navigator.of(context).pop(true),
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
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          'Remove',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
            );

    if (confirm == true) {
      setState(() => _selectedImages.removeAt(index));
    }
  }
}
