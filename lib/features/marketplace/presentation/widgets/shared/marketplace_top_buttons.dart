import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/top_buttons/category_button.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/top_buttons/search_button.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/top_buttons/sell_button.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/top_buttons/sort_dropdown.dart';

class MarketplaceTopButtons extends StatelessWidget {
  const MarketplaceTopButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SearchButton(),
            SizedBox(width: 8),
            SellButton(),
            SizedBox(width: 8),
            SortDropdown(),
            SizedBox(width: 8),
            CategoryButton(),
          ],
        ),
      ),
    );
  }
}
