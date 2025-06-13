import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/core/utils/location_utils.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/state/marketplace_state.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/event/marketplace_event.dart';
import 'package:offgrid_nation_app/injection_container.dart';
import '../widgets/wrapper/marketplace_wrapper.dart';
import '../widgets/shared/marketplace_header.dart';
import '../widgets/shared/marketplace_top_buttons.dart';
import '../widgets/shared/product_card_grid.dart';
import '../widgets/shared/marketplace_snackbar.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => MarketplaceScreenState();
}

class MarketplaceScreenState extends State<MarketplaceScreen> {
  bool _isInitializing = true;
  String? _errorText;
  String? _userLocation;
  String? _selectedCategoryId;
  // bool _isSearchActive = false;
  late final MarketplaceBloc _bloc;
  bool _isFetching = false;

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
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _fetchProductsWithLocation(isInitial: true),
    );
  }

  Future<void> _fetchProductsWithLocation({bool isInitial = false}) async {
    if (isInitial) {
      setState(() {
        _isInitializing = true;
      });
    } else {
      setState(() {
        _isFetching = true;
      });
    }

    final granted = await LocationUtils.requestLocationPermission();
    if (!granted) {
      setState(() {
        _isInitializing = false;
        _isFetching = false;
        _errorText =
            'Location permission denied. Please enable location to view nearby products.';
      });
      return;
    }

    final loc = await LocationUtils.getFormattedLocation();
    if (loc != null) {
      final parts = loc.split(',');
      final lat = double.tryParse(parts[0]);
      final lng = double.tryParse(parts[1]);
      if (lat != null && lng != null) {
        final locationName = await LocationUtils.getReadableLocation(lat, lng);
        setState(() => _userLocation = locationName ?? "Unknown Location");

        _bloc.add(
          FetchProductsRequested(
            latitude: lat,
            longitude: lng,
            categoryId: _selectedCategoryId,
          ),
        );

        setState(() {
          _isInitializing = false;
          _isFetching = false;
        });
        return;
      }
    }

    setState(() {
      _isInitializing = false;
      _isFetching = false;
      _errorText =
          'Unable to determine your location. Please check location settings and try again.';
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> setCategoryAndFetch(String? categoryId) async {
    print(
      "++++++++++++++++++++++++++++categoryId+++++++++++++++++++++$categoryId",
    );
    if (categoryId == null || categoryId.isEmpty) return;

    _selectedCategoryId = categoryId;
    await _fetchProductsWithLocation(isInitial: false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child:
          _isInitializing
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : _errorText != null
              ? MarketplaceWrapper(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      _errorText!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              )
              : BlocListener<MarketplaceBloc, MarketplaceState>(
                listener: (context, state) {
                  if (state is MarketplaceError) {
                    MarketplaceSnackbar.show(context, state.message);
                  } else if (state is MarketplaceFailure) {
                    MarketplaceSnackbar.show(context, state.error);
                  } else if (state is ProductsLoaded &&
                      state.products.isEmpty) {
                    MarketplaceSnackbar.show(
                      context,
                      'No products found in your area.',
                    );
                  }
                },
                child: Stack(
                  children: [
                    MarketplaceWrapper(child: _buildScrollView(context)),
                    if (_isFetching)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }

  Widget _buildScrollView(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: MarketplaceTopBarDelegate(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                MarketplaceHeader(locationName: _userLocation),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        const ProductCardGrid(),
      ],
    );
  }
}

class MarketplaceTopBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 70;

  @override
  double get maxExtent => 70;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double t = (shrinkOffset / maxExtent).clamp(0.0, 1.0);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedSlide(
        offset: Offset(0, t * -0.1),
        duration: const Duration(milliseconds: 200),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: 1.0 - t * 0.1,
          child: const Center(child: MarketplaceTopButtons()),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
