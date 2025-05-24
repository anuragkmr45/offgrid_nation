import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/state/marketplace_state.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/product_card.dart';

class ProductCardGrid extends StatelessWidget {
  const ProductCardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceBloc, MarketplaceState>(
      builder: (context, state) {
        if (state is MarketplaceLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MarketplaceError || state is MarketplaceFailure) {
          return const SliverFillRemaining(child: Center(child: SizedBox()));
        }

        if (state is ProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No products found nearby.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];
                return ProductCard(
                  image:
                      product.images.isNotEmpty
                          ? product.images[0]
                          : 'lib/assets/images/logo_black.png',
                  title: product.title.isNotEmpty ? product.title : 'No Title',
                  price: product.price.isNotEmpty ? product.price : 'No Price',
                  onTap:
                      () => Navigator.pushNamed(
                        context,
                        '/product-details',
                        arguments: product.id,
                      ),
                );
              }, childCount: products.length),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox());
      },
    );
  }
}
