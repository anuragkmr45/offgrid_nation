import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/state/marketplace_state.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/screens/marketplace_screen.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/category_selection_modal.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key});

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MarketplaceBloc, MarketplaceState>(
      listener: (context, state) {
        if (state is CategoriesLoaded) {
          Navigator.pop(context); // Close loading dialog
          Future.microtask(() async {
            final selectedCategory = await showModalBottomSheet<String?>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => CategorySelectionModal(
                categories: state.categories,
              ),
            );

            // User dismissed modal without selecting
            if (selectedCategory == null) return;

            final screenState = context.findAncestorStateOfType<MarketplaceScreenState>();
            if (screenState != null) {
              // Show loading while fetching new results
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => const Center(child: CircularProgressIndicator()),
              );

              await screenState.setCategoryAndFetch(selectedCategory);

              if (context.mounted) Navigator.pop(context); // Close loading dialog
            }
          });
        } else if (state is MarketplaceFailure) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to load categories")),
          );
        }
      },
      child: Platform.isIOS
          ? CupertinoButton(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
              onPressed: () {
                context.read<MarketplaceBloc>().add(
                      const FetchCategoriesRequested(),
                    );
                _showLoadingDialog(context);
              },
              child: _buildContent(CupertinoIcons.list_bullet),
            )
          : ElevatedButton.icon(
              onPressed: () {
                context.read<MarketplaceBloc>().add(
                      const FetchCategoriesRequested(),
                    );
                _showLoadingDialog(context);
              },
              icon: Icon(
                Icons.view_list,
                size: 16,
                color: AppColors.background,
              ),
              label: _buildTextLabel(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                elevation: 0,
                side: BorderSide(color: AppColors.background),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
    );
  }

  Widget _buildContent(IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 6),
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextLabel() {
    return const Text(
      'Category',
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    );
  }
}
