// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:offgrid_nation_app/core/constants/theme_constants.dart';
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

//   Widget _buildCategoryButton(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           isScrollControlled: true,
//           backgroundColor: Colors.transparent,
//           builder:
//               (_) => const CategorySelectionModal(categories: state.categories),
//         );
//       },
//       icon: Icon(
//         Platform.isIOS ? CupertinoIcons.list_bullet : Icons.view_list,
//         size: 16,
//         color: AppColors.background, // white icon
//       ),
//       label: Text(
//         'Category',
//         style: TextStyle(
//           fontSize: 13,
//           color: AppColors.background, // white text
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: AppColors.primary,
//         foregroundColor: AppColors.background,
//         elevation: 0,
//         side: BorderSide(color: AppColors.background),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
//           isScrollControlled: true,
//           backgroundColor: Colors.transparent,
//           builder:
//               (_) => BlocBuilder<MarketplaceBloc, MarketplaceState>(
//                 builder: (context, state) {
//                   if (state is MarketplaceLoading) {
//                     return const Center(
//                       child: Padding(
//                         padding: EdgeInsets.all(32.0),
//                         child: CircularProgressIndicator(),
//                       ),
//                     );
//                   } else if (state is CategoriesLoaded) {
//                     return CategorySelectionModal(categories: state.categories);
//                   } else if (state is MarketplaceFailure) {
//                     return Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(32.0),
//                         child: Text(
//                           'Failed to load categories.\n${state.error}',
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     );
//                   } else {
//                     return const SizedBox.shrink();
//                   }
//                 },
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
