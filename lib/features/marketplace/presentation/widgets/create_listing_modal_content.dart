import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/state/marketplace_state.dart';

class CreateListingModalContent extends StatelessWidget {
  const CreateListingModalContent({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Create your listing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/marketplace/create-listing');
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAEAEA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 16),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Add items',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: BlocBuilder<MarketplaceBloc, MarketplaceState>(
                builder: (context, state) {
                  if (state is MarketplaceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is MyProductsLoaded) {
                    final products = state.myProducts;
                    if (products.isEmpty) {
                      return const Center(child: Text("No items listed yet."));
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: products.length,
                      itemBuilder: (_, i) {
                        final ProductEntity product = products[i];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(product.images.first),
                          ),
                          title: Text(product.title),
                          subtitle: Text(product.price),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context,
                              '/product-details',
                              arguments: product.id,
                            );
                          },
                        );
                      },
                    );
                  }

                  return const Center(child: Text("Something went wrong"));
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
