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
      myProductListUseCase: sl(), deleteProductUseCase: sl(), 
      searchProductsUseCase: sl(),
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
              final ProductDetailsEntity product = state.product;

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
