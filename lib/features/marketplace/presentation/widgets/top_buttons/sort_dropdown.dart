import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/core/utils/location_utils.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/enums/product_sort_option.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';

class SortDropdown extends StatelessWidget {
  const SortDropdown({super.key});

  void _handleSortSelection(
    BuildContext context,
    ProductSortOption option,
  ) async {
    final loc = await LocationUtils.getFormattedLocation();
    if (loc == null) return;

    final parts = loc.split(',');
    final lat = double.tryParse(parts[0]);
    final lng = double.tryParse(parts[1]);

    if (lat == null || lng == null) return;

    context.read<MarketplaceBloc>().add(
      FetchProductsRequested(
        latitude: lat,
        longitude: lng,
        sortBy: option.apiValue,
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: AppColors.background,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              ...ProductSortOption.values.map((option) {
                return ListTile(
                  title: Text(
                    option.label,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _handleSortSelection(context, option);
                  },
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showSortBottomSheet(context), // 🔁 Replaced logic only
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.background,
        elevation: 0,
        side: BorderSide(color: AppColors.background),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text("Sort By", style: TextStyle(fontSize: 13, color: Colors.white)),
        ],
      ),
    );
  }
}
