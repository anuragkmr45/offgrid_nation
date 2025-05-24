// 📁 lib/features/root/presentation/widget/post/add_post_text.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/add_post_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/events/add_post_event.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/states/add_post_state.dart';

class PostTextBar extends StatefulWidget {
  final ValueChanged<String> onPost;
  final VoidCallback onCameraTap;
  final VoidCallback onLocationTap;
  final List<File> mediaFiles;
  final String? location;

  const PostTextBar({
    super.key,
    required this.onPost,
    required this.onCameraTap,
    required this.onLocationTap,
    required this.mediaFiles,
    required this.location,
  });

  @override
  State<PostTextBar> createState() => _PostTextBarState();
}

class _PostTextBarState extends State<PostTextBar> {
  final TextEditingController _textController = TextEditingController();
  int _charCount = 0;

  void _handlePost() {
    final text = _textController.text.trim();
    if (text.isEmpty || text.length > 400) return;
    BlocProvider.of<AddPostBloc>(context).add(
      SubmitPostEvent(
        content: text,
        location: widget.location,
        mediaFiles: widget.mediaFiles,
      ),
    );
    FocusScope.of(context).unfocus(); // hide keyboard
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() => _charCount = _textController.text.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPostBloc, AddPostState>(
      listener: (context, state) {
        if (state is AddPostSuccess) {
          _textController.clear();
          setState(() => _charCount = 0);
        }
      },
      builder: (context, state) {
        final bool isPosting = state is AddPostLoading;
        final String text = _textController.text;
        final bool isPostDisabled =
            text.trim().isEmpty || text.length > 400 || isPosting;

        final textField =
            Platform.isIOS
                ? CupertinoScrollbar(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: CupertinoTextField(
                      controller: _textController,
                      placeholder: "What do you want to tell everyone?",
                      placeholderStyle: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 30,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: null,
                      maxLength: 400,
                      enabled: !isPosting,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.textSecondary.withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                )
                : TextField(
                  controller: _textController,
                  maxLines: null,
                  maxLength: 400,
                  enabled: !isPosting,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "What do you want to tell everyone?",
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 30,
                    ),
                    fillColor: AppColors.background,
                    filled: true,
                    counterText: '',
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                );

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    boxShadow:
                        Platform.isIOS
                            ? []
                            : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: textField,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    boxShadow:
                        Platform.isIOS
                            ? []
                            : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0, right: 4.0),
                        child: Text(
                          "$_charCount/400",
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: isPosting ? null : widget.onCameraTap,
                            icon: Icon(
                              Platform.isIOS
                                  ? CupertinoIcons.photo_camera
                                  : Icons.camera_alt_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          IconButton(
                            onPressed: isPosting ? null : widget.onLocationTap,
                            icon: Icon(
                              Platform.isIOS
                                  ? CupertinoIcons.location
                                  : Icons.location_on_outlined,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          CustomButton(
                            onPressed: isPostDisabled ? () {} : _handlePost,
                            text: 'Post',
                            height: 40,
                            width: 80,
                            backgroundColor:
                                isPostDisabled
                                    ? AppColors.textSecondary
                                    : AppColors.primary,
                            textColor: Colors.white,
                            borderRadius: 8,
                            loading: false,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isPosting)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Center(
                    child:
                        Platform.isIOS
                            ? const CupertinoActivityIndicator(radius: 16)
                            : const CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
