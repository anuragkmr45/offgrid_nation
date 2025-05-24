// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class ProductDetailsScreen extends StatelessWidget {
//   const ProductDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Platform.isIOS
//         ? const _ListingDetailsCupertino()
//         : const _ListingDetailsMaterial();
//   }
// }

// // -------------------- iOS Layout --------------------

// class _ListingDetailsCupertino extends StatelessWidget {
//   const _ListingDetailsCupertino();

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: const CupertinoNavigationBar(
//         middle: Text('Listing details'),
//         trailing: Text(
//           'Publish',
//           style: TextStyle(color: CupertinoColors.activeBlue),
//         ),
//         leading: Icon(CupertinoIcons.back),
//       ),
//       child: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: _FormContent(isIOS: true),
//         ),
//       ),
//     );
//   }
// }

// // -------------------- Android Layout --------------------

// class _ListingDetailsMaterial extends StatelessWidget {
//   const _ListingDetailsMaterial();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Listing details'),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: const Text('Publish', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: _FormContent(isIOS: false),
//         ),
//       ),
//     );
//   }
// }

// // -------------------- Shared Form Content --------------------

// class _FormContent extends StatelessWidget {
//   final bool isIOS;
//   const _FormContent({required this.isIOS});

//   Widget _buildTextField(String placeholder, {int maxLines = 1}) {
//     return isIOS
//         ? CupertinoTextField(
//           placeholder: placeholder,
//           maxLines: maxLines,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           decoration: BoxDecoration(
//             color: CupertinoColors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: CupertinoColors.systemGrey4),
//           ),
//         )
//         : TextField(
//           maxLines: maxLines,
//           decoration: InputDecoration(
//             hintText: placeholder,
//             filled: true,
//             fillColor: Colors.white,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 12,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: const BorderSide(color: Colors.grey),
//             ),
//           ),
//         );
//   }

//   Widget _buildConditionChips() {
//     final conditions = ['New', 'Used–Like New', 'Used–Good', 'Others'];
//     return Wrap(
//       spacing: 8,
//       runSpacing: 8,
//       children:
//           conditions
//               .map(
//                 (label) => ChoiceChip(
//                   label: Text(label),
//                   selected: false,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               )
//               .toList(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Photos
//         Row(
//           children: [
//             const Icon(Icons.camera_alt_outlined, size: 28),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const [
//                 Text(
//                   'Add photos',
//                   style: TextStyle(fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(height: 2),
//                 Text(
//                   'Photos: 0/10',
//                   style: TextStyle(fontSize: 12, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),

//         // Title
//         _buildTextField('Enter Title'),
//         const SizedBox(height: 16),

//         // Price
//         _buildTextField('Price'),
//         const SizedBox(height: 20),

//         // Condition
//         const Text('Condition', style: TextStyle(fontWeight: FontWeight.w500)),
//         const SizedBox(height: 10),
//         _buildConditionChips(),
//         const SizedBox(height: 20),

//         // Description
//         _buildTextField('Description.....', maxLines: 5),
//         const SizedBox(height: 16),

//         // Location
//         _buildTextField('Location'),
//         const SizedBox(height: 30),

//         // Publish button
//         SizedBox(
//           width: double.infinity,
//           child:
//               isIOS
//                   ? CupertinoButton.filled(
//                     child: const Text('Publish'),
//                     onPressed: () {},
//                   )
//                   : ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Publish',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                     onPressed: () {},
//                   ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_details_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/state/marketplace_state.dart';
import 'package:offgrid_nation_app/injection_container.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final MarketplaceBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MarketplaceBloc(
      listProductsUseCase: sl(),
      addProductUseCase: sl(),
      getCategoriesUseCase: sl(),
      getProductDetailsUseCase: sl(),
      myProductListUseCase: sl(),
    );
    _bloc.add(FetchProductDetailsRequested(widget.productId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text("Product Details")),
        body: BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, state) {
            if (state is MarketplaceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MarketplaceFailure || state is MarketplaceError) {
              return const Center(
                child: Text("Failed to load product details."),
              );
            }

            if (state is ProductDetailsLoaded) {
              final ProductDetailsEntity product =
                  state.product as ProductDetailsEntity;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.images.isNotEmpty)
                      Image.network(product.images[0], width: double.infinity),
                    const SizedBox(height: 12),
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(product.price, style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("Condition: ${product.condition}"),
                    const SizedBox(height: 8),
                    Text("Description: ${product.description}"),
                    const SizedBox(height: 8),
                    Text("Category: ${product.category.title}"),
                    const SizedBox(height: 8),
                    Text("Posted by: ${product.owner.username}"),
                    const SizedBox(height: 8),
                    Text("Views: ${product.clickCount}"),
                    const SizedBox(height: 12),
                    Text(
                      "Location: (${product.location.coordinates.join(", ")})",
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
