import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_details_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/state/marketplace_state.dart';
import 'package:offgrid_nation_app/core/widgets/custom_button.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/product_detils/product_details_info.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/widgets/product_detils/product_image_carousel.dart';
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
      deleteProductUseCase: sl(),
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
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomButton(
              text: "Chat with Seller",
              onPressed: () {},
              loading: false,
            ),
          ),
        ),
        body: BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, state) {
            if (state is MarketplaceLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MarketplaceFailure || state is MarketplaceError) {
              return const Center(child: Text("Failed to load product details."));
            }

            if (state is ProductDetailsLoaded) {
              final ProductDetailsEntity product = state.product;

              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImageCarousel(mediaUrls: product.images),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ProductDetailsInfo(product: product),
                    )
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
