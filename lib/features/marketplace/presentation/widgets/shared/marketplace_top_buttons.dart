// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
// import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';
// import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
// import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/state/marketplace_state.dart';
// import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/category_selection_modal.dart';

// class MarketplaceTopButtons extends StatelessWidget {
//   const MarketplaceTopButtons({super.key});

//   // @override
//   // Widget build(BuildContext context) {
//   //   return Center(
//   //     child: Wrap(
//   //       spacing: 6,
//   //       runSpacing: 6,
//   //       alignment: WrapAlignment.center,
//   //       children: [
//   //         _buildSearchButton(context),
//   //         _buildSellButton(context),
//   //         _buildDropdown(context, 'Sort By'),
//   //         _buildCategoryButton(context),
//   //       ],
//   //     ),
//   //   );
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             _buildSearchButton(context),
//             const SizedBox(width: 8),
//             _buildSellButton(context),
//             const SizedBox(width: 8),
//             _buildDropdown(context, 'Sort By'),
//             const SizedBox(width: 8),
//             _buildCategoryButton(context),
//           ],
//         ),
//       ),
//     );
//   }

//   void showLoadingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );
//   }

//   Widget _buildCategoryButton(BuildContext context) {
//     return BlocListener<MarketplaceBloc, MarketplaceState>(
//       listener: (context, state) {
//         if (state is CategoriesLoaded) {
//           Navigator.pop(context); // close loading dialog

//           // Wait for one frame before opening modal
//           Future.microtask(() {
//             showModalBottomSheet(
//               context: context,
//               isScrollControlled: true,
//               backgroundColor: Colors.transparent,
//               builder:
//                   (_) => CategorySelectionModal(categories: state.categories),
//             );
//           });
//         } else if (state is MarketplaceFailure) {
//           Navigator.pop(context); // close loading
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text("Failed to load categories")));
//         }
//       },
//       child: ElevatedButton.icon(
//         onPressed: () {
//           context.read<MarketplaceBloc>().add(const FetchCategoriesRequested());
//           showLoadingDialog(context);
//         },
//         icon: Icon(
//           Platform.isIOS ? CupertinoIcons.list_bullet : Icons.view_list,
//           size: 16,
//           color: AppColors.background,
//         ),
//         label: Text(
//           'Category',
//           style: TextStyle(
//             fontSize: 13,
//             color: AppColors.background,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: AppColors.background,
//           elevation: 0,
//           side: BorderSide(color: AppColors.background),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchButton(BuildContext context) {
//     return _buildButton(
//       context,
//       icon: Platform.isIOS ? CupertinoIcons.search : Icons.search,
//       label: 'Search',
//       onPressed: () {},
//     );
//   }

//   Widget _buildSellButton(BuildContext context) {
//     return _buildButton(
//       context,
//       icon: Platform.isIOS ? CupertinoIcons.tag : Icons.sell,
//       label: 'Sell',
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           backgroundColor: Colors.white,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//           ),
//           builder:
//               (_) => SizedBox(
//                 height: 180,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
//                       child: Text(
//                         'Create your listing',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pop(context); // close modal
//                         Navigator.pushNamed(
//                           context,
//                           '/marketplace/create-listing',
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 8,
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: const BoxDecoration(
//                                 color: Color(0xFFEAEAEA),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(Icons.add, size: 16),
//                             ),
//                             const SizedBox(width: 12),
//                             const Text(
//                               'Add items',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//         );
//       },
//     );
//   }

//   Widget _buildDropdown(BuildContext context, String label) {
//     if (Platform.isIOS) {
//       return ElevatedButton(
//         onPressed: () {
//           showCupertinoModalPopup(
//             context: context,
//             builder:
//                 (_) => CupertinoActionSheet(
//                   title: Text(label),
//                   actions: [
//                     CupertinoActionSheetAction(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Option 1'),
//                     ),
//                     CupertinoActionSheetAction(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Option 2'),
//                     ),
//                   ],
//                   cancelButton: CupertinoActionSheetAction(
//                     isDefaultAction: true,
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text('Cancel'),
//                   ),
//                 ),
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: AppColors.background, // For iconTheme & label
//           elevation: 0,
//           side: BorderSide(color: AppColors.background),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               CupertinoIcons.chevron_down,
//               size: 14,
//               color: AppColors.background,
//             ),
//             const SizedBox(width: 4),
//             Text(
//               'Sort By',
//               style: TextStyle(fontSize: 13, color: AppColors.background),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return PopupMenuButton<String>(
//         onSelected: (value) {
//           // Handle selection
//         },
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         color: AppColors.background,
//         itemBuilder:
//             (context) => const [
//               PopupMenuItem(value: 'Option 1', child: Text('Option 1')),
//               PopupMenuItem(value: 'Option 2', child: Text('Option 2')),
//             ],
//         child: ElevatedButton(
//           onPressed: null,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             foregroundColor: AppColors.background,
//             elevation: 0,
//             side: BorderSide(color: AppColors.background),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(
//                 Icons.arrow_drop_down,
//                 size: 16,
//                 color: AppColors.background,
//               ),
//               const SizedBox(width: 4),
//               Text(
//                 'Sort By',
//                 style: TextStyle(fontSize: 13, color: AppColors.background),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }

//   Widget _buildButton(
//     BuildContext context, {
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     final content = Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 16, color: Colors.white),
//         const SizedBox(width: 6),
//         Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
//       ],
//     );

//     return Platform.isIOS
//         ? CupertinoButton(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           color: AppColors.primary,
//           borderRadius: BorderRadius.circular(8),
//           onPressed: onPressed,
//           child: content,
//         )
//         : ElevatedButton(
//           onPressed: onPressed,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             foregroundColor: Colors.white,
//             elevation: 0,
//             side: BorderSide(color: AppColors.background), // ✅ Border
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: content,
//         );
//   }
// }
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
