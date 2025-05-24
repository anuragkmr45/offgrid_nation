import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

class SortDropdown extends StatelessWidget {
  const SortDropdown({super.key});

  void _showCupertinoSortSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (_) => CupertinoActionSheet(
            title: const Text('Sort By'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Handle sort
                },
                child: const Text('Newest First'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Handle sort
                },
                child: const Text('Price: Low to High'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Handle sort
                },
                child: const Text('Price: High to Low'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          onPressed: () => _showCupertinoSortSheet(context),
          child: _buildContent(CupertinoIcons.chevron_down),
        )
        : PopupMenuButton<String>(
          onSelected: (value) {
            // TODO: Handle selected sort option
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: AppColors.background,
          itemBuilder:
              (_) => const [
                PopupMenuItem(value: 'newest', child: Text('Newest First')),
                PopupMenuItem(
                  value: 'lowToHigh',
                  child: Text('Price: Low to High'),
                ),
                PopupMenuItem(
                  value: 'highToLow',
                  child: Text('Price: High to Low'),
                ),
              ],
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              elevation: 0,
              side: BorderSide(color: AppColors.background),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: _buildContent(Icons.arrow_drop_down),
          ),
        );
  }

  Widget _buildContent(IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.background),
        const SizedBox(width: 4),
        Text(
          'Sort By',
          style: TextStyle(fontSize: 13, color: AppColors.background),
        ),
      ],
    );
  }
}
