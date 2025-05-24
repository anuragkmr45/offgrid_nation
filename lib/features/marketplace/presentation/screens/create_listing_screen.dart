import 'dart:io';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/create_listing/create_listing_body.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/create_listing/create_listing_appbar.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  List<File> _selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CreateListingAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: CreateListingBody(
          selectedImages: _selectedImages,
          onMediaChanged: (files) {
            setState(() => _selectedImages = files);
          },
        ),
      ),
    );
  }
}
