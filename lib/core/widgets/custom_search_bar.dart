import 'dart:io' show Platform;
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted; // Callback when search is submitted.
  final String hintText;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    // Show platform-specific search bar UI.
    return Platform.isIOS
        ? _buildCupertinoSearchBar(context)
        : _buildMaterialSearchBar(context);
  }

  Widget _buildMaterialSearchBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3), // Moved the color here.
            border: Border.all(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.search,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoSearchBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.0),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.3), // Moved the color here.
            border: Border.all(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Row(
            children: [
              const Icon(CupertinoIcons.search, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: CupertinoTextField(
                  controller: controller,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  placeholder: hintText,
                  placeholderStyle: const TextStyle(color: Colors.white70),
                  style: const TextStyle(color: Colors.white),
                  textInputAction: TextInputAction.search,
                  decoration: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
