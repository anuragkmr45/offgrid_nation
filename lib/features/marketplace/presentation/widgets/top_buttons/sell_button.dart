import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/my_product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/create_listing_modal_content.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/self_product_modal.dart';
import 'package:offgrid_nation_app/injection_container.dart';

class SellButton extends StatelessWidget {
  const SellButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
          onPressed: () => _showModal(context),
          child: _buttonContent(CupertinoIcons.tag),
        )
        : ElevatedButton(
          onPressed: () => _showModal(context),
          style: _buttonStyle(),
          child: _buttonContent(Icons.sell),
        );
  }

  Widget _buttonContent(IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 6),
        const Text('Sell', style: TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }

  // void _showModal(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder:
  //         (_) => SizedBox(
  //           height: 180,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Padding(
  //                 padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
  //                 child: Text(
  //                   'Create your listing',
  //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //               InkWell(
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   Navigator.pushNamed(context, '/marketplace/create-listing');
  //                 },
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 16,
  //                     vertical: 8,
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.all(6),
  //                         decoration: const BoxDecoration(
  //                           color: Color(0xFFEAEAEA),
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(Icons.add, size: 16),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       const Text(
  //                         'Add items',
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //   );
  // }

void _showModal(BuildContext context) {
  showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ),
  builder: (_) => BlocProvider.value(
    value: sl<MarketplaceBloc>()..add(const FetchMyProductsRequested(filter: MyProductFilter())),
    child: const CreateListingModalContent(),
  ),
);

}

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      side: BorderSide(color: AppColors.background),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
