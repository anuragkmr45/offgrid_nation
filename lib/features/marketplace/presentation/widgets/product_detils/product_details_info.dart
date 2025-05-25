// import 'package:flutter/material.dart';
// import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_details_entity.dart';
// import 'package:offgrid_nation_app/core/utils/location_utils.dart';

// class ProductDetailsInfo extends StatefulWidget {
//   final ProductDetailsEntity product;

//   const ProductDetailsInfo({super.key, required this.product});

//   @override
//   State<ProductDetailsInfo> createState() => _ProductDetailsInfoState();
// }

// class _ProductDetailsInfoState extends State<ProductDetailsInfo> {
//   String? readableLocation;

//   @override
//   void initState() {
//     super.initState();
//     _resolveLocation();
//   }

//   Future<void> _resolveLocation() async {
//     final coordinates = widget.product.location.coordinates;
//     if (coordinates.length == 2) {
//       final lng = coordinates[0];
//       final lat = coordinates[1];
//       final location = await LocationUtils.getReadableLocation(lat, lng);
//       if (mounted) {
//         setState(() => readableLocation = location);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final product = widget.product;
//     final TextStyle labelStyle = TextStyle(
//       fontWeight: FontWeight.w600,
//       color: Colors.grey.shade700,
//     );

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           product.title,
//           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           product.price,
//           style: const TextStyle(fontSize: 20, color: Colors.green),
//         ),
//         const SizedBox(height: 16),
//         Text("Condition:", style: labelStyle),
//         Text(product.condition),
//         const SizedBox(height: 12),
//         Text("Description:", style: labelStyle),
//         Text(product.description),
//         const SizedBox(height: 12),
//         Text("Category:", style: labelStyle),
//         Text(product.category.title),
//         const SizedBox(height: 12),
//         Text("Posted by:", style: labelStyle),
//         Text(product.owner.username),
//         const SizedBox(height: 12),
//         Text("Views:", style: labelStyle),
//         Text(product.clickCount.toString()),
//         const SizedBox(height: 12),
//         Text("Location:", style: labelStyle),
//         readableLocation != null
//             ? Text(readableLocation!)
//             : const Text("Resolving location..."),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_details_entity.dart';
import 'package:offgrid_nation_app/core/utils/location_utils.dart';

class ProductDetailsInfo extends StatefulWidget {
  final ProductDetailsEntity product;

  const ProductDetailsInfo({super.key, required this.product});

  @override
  State<ProductDetailsInfo> createState() => _ProductDetailsInfoState();
}

class _ProductDetailsInfoState extends State<ProductDetailsInfo> {
  String? _readableLocation;
  bool _loadingLocation = true;

  @override
  void initState() {
    super.initState();
    _fetchReadableLocation();
  }

  Future<void> _fetchReadableLocation() async {
    final coords = widget.product.location.coordinates;
    if (coords.length == 2) {
      final result = await LocationUtils.getReadableLocation(coords[1], coords[0]);
      setState(() {
        _readableLocation = result ?? "Location not found";
        _loadingLocation = false;
      });
    } else {
      setState(() {
        _readableLocation = "Location unavailable";
        _loadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.grey.shade700,
    );
    final product = widget.product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          product.price,
          style: const TextStyle(fontSize: 20, color: Colors.green),
        ),
        const SizedBox(height: 16),
        Text("Condition:", style: labelStyle),
        Text(product.condition),
        const SizedBox(height: 12),
        Text("Description:", style: labelStyle),
        Text(product.description),
        const SizedBox(height: 12),
        Text("Category:", style: labelStyle),
        Text(product.category.title),
        const SizedBox(height: 12),
        Text("Posted by:", style: labelStyle),
        Text(product.owner.username),
        const SizedBox(height: 12),
        Text("Views:", style: labelStyle),
        Text(product.clickCount.toString()),
        const SizedBox(height: 12),
        Text("Location:", style: labelStyle),
        _loadingLocation
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
              )
            : Text(_readableLocation ?? "N/A"),
      ],
    );
  }
}