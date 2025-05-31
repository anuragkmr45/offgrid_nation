import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/utils/debouncer.dart';
import 'package:offgrid_nation_app/core/widgets/custom_search_bar.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';
import 'package:offgrid_nation_app/core/utils/location_utils.dart';

class SearchButton extends StatefulWidget {
  const SearchButton({super.key});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton>
    with SingleTickerProviderStateMixin {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  Future<void> _triggerSearch(String query) async {
    if (query.trim().isEmpty) return;
    final loc = await LocationUtils.getFormattedLocation();
    if (loc != null) {
      final parts = loc.split(',');
      final lat = double.tryParse(parts[0]);
      final lng = double.tryParse(parts[1]);
      if (lat != null && lng != null) {
        context.read<MarketplaceBloc>().add(
          SearchProductsRequested(
            query: query.trim(),
            lat: lat,
            lng: lng,
          ),
        );
      }
    }
  }

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
            _debouncer.run(() => _triggerSearch(value));
          },
          onSubmitted: (value) => _triggerSearch(value),
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
