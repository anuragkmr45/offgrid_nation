import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaPickerModal extends StatefulWidget {
  final List<File> images;
  final int initialIndex;

  const MediaPickerModal({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<MediaPickerModal> createState() => _MediaPickerModalState();
}

class _MediaPickerModalState extends State<MediaPickerModal>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _closeModal() {
    _animationController.reverse().then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.9),
      body: GestureDetector(
        onTap: _closeModal,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  onPageChanged:
                      (index) => setState(() => _currentIndex = index),
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          widget.images[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: _closeModal,
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.images.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              index == _currentIndex
                                  ? Colors.white
                                  : Colors.white24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
