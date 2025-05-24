import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const CustomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // EDITED: Use Theme.of(context).platform for consistent platform detection.
    return Theme.of(context).platform == TargetPlatform.iOS
        ? _buildCupertinoTabs(context)
        : _buildMaterialTabs(context);
  }

  // iOS style using CupertinoSegmentedControl.
  Widget _buildCupertinoTabs(BuildContext context) {
    return Container(
      color: const Color(0xFF0A84FF),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CupertinoSegmentedControl<int>(
        selectedColor: Colors.white,
        unselectedColor: const Color(0xFF0A84FF),
        borderColor: Colors.white,
        pressedColor: Colors.white54,
        groupValue: currentIndex,
        onValueChanged: onTabSelected,
        children: {
          0: _buildSegment('Accounts', isSelected: currentIndex == 0),
          1: _buildSegment('Topics', isSelected: currentIndex == 1),
        },
      ),
    );
  }

  // Helper method for creating a segment widget.
  Widget _buildSegment(String label, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF0A84FF) : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Android style: custom Material tab bar.
  Widget _buildMaterialTabs(BuildContext context) {
    return Container(
      color: const Color(0xFF0A84FF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMaterialTabItem(label: 'Accounts', index: 0),
          _buildMaterialTabItem(label: 'Topics', index: 1),
        ],
      ),
    );
  }

  // Creates an individual tab item for Android.
  Widget _buildMaterialTabItem({required String label, required int index}) {
    final bool isSelected = index == currentIndex;
    return InkWell(
      onTap: () => onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          border:
              isSelected
                  ? const Border(
                    bottom: BorderSide(color: Colors.white, width: 2),
                  )
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
