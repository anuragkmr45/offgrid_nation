// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:offgrid_nation_app/core/constants/theme_constants.dart';

// class SearchButton extends StatelessWidget {
//   const SearchButton({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Platform.isIOS
//         ? CupertinoButton(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           color: AppColors.primary,
//           borderRadius: BorderRadius.circular(8),
//           onPressed: () {},
//           child: _buttonContent(CupertinoIcons.search),
//         )
//         : ElevatedButton(
//           onPressed: () {},
//           style: _buttonStyle(),
//           child: _buttonContent(Icons.search),
//         );
//   }

//   Widget _buttonContent(IconData icon) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: Colors.white),
//         const SizedBox(width: 6),
//         const Text(
//           'Search',
//           style: TextStyle(color: Colors.white, fontSize: 13),
//         ),
//       ],
//     );
//   }

//   ButtonStyle _buttonStyle() {
//     return ElevatedButton.styleFrom(
//       backgroundColor: AppColors.primary,
//       foregroundColor: Colors.white,
//       elevation: 0,
//       side: BorderSide(color: AppColors.background),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';

class SearchButton extends StatefulWidget {
  const SearchButton({super.key});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isSearching ? 220 : 100,
      curve: Curves.easeInOut,
      child: _isSearching ? _buildSearchBar() : _buildSearchButton(),
    );
  }

  Widget _buildSearchButton() {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Platform.isIOS ? CupertinoIcons.search : Icons.search,
          size: 16,
          color: Colors.white,
        ),
        const SizedBox(width: 6),
        const Text(
          'Search',
          style: TextStyle(color: Colors.white, fontSize: 13),
        ),
      ],
    );

    return Platform.isIOS
        ? CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          onPressed: () => setState(() => _isSearching = true),
          child: content,
        )
        : ElevatedButton(
          onPressed: () => setState(() => _isSearching = true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            side: BorderSide(color: AppColors.background),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: content,
        );
  }

  Widget _buildSearchBar() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        CustomSearchBar(
          controller: _controller,
          hintText: 'Search items...',
          onChanged: (value) {
            // Optional: Debounce search logic here
          },
          onSubmitted: (value) {
            // Optional: Trigger search API or Bloc event
          },
        ),
        IconButton(
          icon: Icon(
            Platform.isIOS ? CupertinoIcons.clear_circled : Icons.close,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () {
            _controller.clear();
            setState(() => _isSearching = false);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
