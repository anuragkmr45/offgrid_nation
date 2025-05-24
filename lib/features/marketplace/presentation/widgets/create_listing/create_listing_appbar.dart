import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateListingAppBar extends StatelessWidget {
  const CreateListingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: Icon(
          Platform.isIOS ? CupertinoIcons.back : Icons.arrow_back,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Listing details',
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // optional: trigger publish action if needed
          },
          child: const Text(
            'Publish',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
