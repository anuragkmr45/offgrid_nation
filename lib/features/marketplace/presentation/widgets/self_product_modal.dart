// lib/features/marketplace/presentation/widgets/self_product_modal.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/my_product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/state/marketplace_state.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';

class SelfProductModal extends StatefulWidget {
  const SelfProductModal({super.key});

  @override
  State<SelfProductModal> createState() => _SelfProductModalState();
}

class _SelfProductModalState extends State<SelfProductModal> {
  @override
  void initState() {
    super.initState();
    context.read<MarketplaceBloc>().add(
          const FetchMyProductsRequested(
            filter: MyProductFilter(limit: 100),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, controller) {
        return BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, state) {
            if (state is MarketplaceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MyProductsLoaded) {
              final products = state.myProducts;

              if (products.isEmpty) {
                return const Center(child: Text("No products listed."));
              }

              return ListView.builder(
                controller: controller,
                itemCount: products.length,
                itemBuilder: (_, i) => _ProductItem(product: products[i]),
              );
            }

            return const Center(child: Text("Something went wrong."));
          },
        );
      },
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductEntity product;

  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(product.images.first),
        radius: 24,
      ),
      title: Text(product.title),
      subtitle: Text(product.price),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, '/product-details', arguments: product.id);
      },
    );
  }
}
