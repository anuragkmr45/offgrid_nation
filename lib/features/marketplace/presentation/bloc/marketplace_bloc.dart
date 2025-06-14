import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/delete_product_usecase.dart';
// import 'package:offgrid_nation_app/features/marketplace/domain/usecases/add_rating_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/get_categories_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/get_product_details_usecase.dart';
// import 'package:offgrid_nation_app/features/marketplace/domain/usecases/get_ratings_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/list_products_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/my_product_list_usercase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/add_product_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/search_products_usecase.dart';
import './event/marketplace_event.dart';
import './state/marketplace_state.dart';

class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  final AddProductUseCase addProductUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final ListProductsUseCase listProductsUseCase;
  // final AddRatingUseCase addRatingUseCase;
  // final GetRatingsUseCase getRatingsUseCase;
  final MyProductListUseCase myProductListUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  List<ProductEntity> _cachedFeed = [];

  MarketplaceBloc({
    required this.addProductUseCase,
    required this.getCategoriesUseCase,
    required this.getProductDetailsUseCase,
    required this.listProductsUseCase,
    required this.myProductListUseCase,
    required this.deleteProductUseCase,
    required this.searchProductsUseCase,
    // required this.addRatingUseCase,
    // required this.getRatingsUseCase,
  }) : super(MarketplaceInitial()) {
    on<AddProductRequested>(_onAddProductRequested);
    on<FetchCategoriesRequested>(_onFetchCategoriesRequested);
    on<FetchProductDetailsRequested>(_onFetchProductDetailsRequested);
    on<FetchProductsRequested>(_onFetchProductsRequested);
    on<FetchMyProductsRequested>(_onFetchMyProductsRequested);
    on<DeleteProductRequested>(_onDeleteProductRequested);
    on<SearchProductsRequested>(_onSearchProductsRequested);
    // on<FetchMyProductsRequested>(_onAddRatingRequested);
    // on<FetchMyProductsRequested>(_onFetchRatingsRequested);
  }
  Future<void> _onAddProductRequested(
    AddProductRequested event,
    Emitter<MarketplaceState> emit,
  ) async {
    emit(MarketplaceLoading());
    try {
      final product = await addProductUseCase(
        pictures: event.pictures,
        title: event.title,
        price: event.price,
        condition: event.condition,
        description: event.description,
        category: event.category,
        lat: event.lat,
        lng: event.lng,
      );
      emit(AddProductSuccess(product));
    } catch (e, st) {
      print('❌ Product parsing failed. Bypassing and navigating anyway...');
      print(e);
      print(st);

      // 🔁 Bypass logic: Navigate anyway with dummy product
      emit(
        AddProductSuccess(
          ProductEntity(
            id: '',
            ownerId: '',
            images: [],
            title: 'Unknown',
            price: '0',
            condition: 'Unknown',
            description: 'Unknown',
            category: '',
            latitude: 0.0,
            longitude: 0.0,
            ratings: {},
            clicks: 0,
            createdAt: DateTime.now(),
          ),
        ),
      );
    }
  }

  Future<void> _onFetchProductDetailsRequested(
    FetchProductDetailsRequested event,
    Emitter<MarketplaceState> emit,
  ) async {
    emit(MarketplaceLoading());
    try {
      final product = await getProductDetailsUseCase(event.productId);
      emit(ProductDetailsLoaded(product));
    } catch (e) {
      emit(MarketplaceFailure(e.toString()));
    }
  }

  Future<void> _onFetchProductsRequested(
    FetchProductsRequested event,
    Emitter<MarketplaceState> emit,
  ) async {
    emit(MarketplaceLoading());
    try {
      final result = await listProductsUseCase(
        latitude: event.latitude,
        longitude: event.longitude,
        limit: event.limit,
        cursor: event.cursor,
        sortBy: event.sortBy,
        categoryId: event.categoryId,
      );

      _cachedFeed = result;

      emit(
        ProductsLoaded(
          products: result,
          nextCursor: result.isNotEmpty ? result.last.id : null,
        ),
      );
    } catch (e) {
      emit(MarketplaceFailure(e.toString()));
    }
  }

  Future<void> _onFetchMyProductsRequested(
    FetchMyProductsRequested event,
    Emitter<MarketplaceState> emit,
  ) async {
    emit(MarketplaceLoading());
    try {
      final result = await myProductListUseCase(event.filter);
      emit(MyProductsLoaded(myProducts: result));
    } catch (e) {
      emit(MarketplaceFailure(e.toString()));
    }
  }

  Future<void> _onFetchCategoriesRequested(
    FetchCategoriesRequested event,
    Emitter<MarketplaceState> emit,
  ) async {
    // emit(MarketplaceLoading());
    try {
      final categories = await getCategoriesUseCase();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(MarketplaceFailure(e.toString()));
    }
  }

  Future<void> _onDeleteProductRequested(
    DeleteProductRequested event,
    Emitter<MarketplaceState> emit,
  ) async {
    emit(MarketplaceLoading());
    try {
      await deleteProductUseCase(event.productId);
      emit(MarketplaceLoaded(products: [])); // or refetch
    } catch (e) {
      emit(MarketplaceFailure(e.toString()));
    }
  }

  Future<void> _onSearchProductsRequested(
    SearchProductsRequested event,
    Emitter<MarketplaceState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(ProductsLoaded(products: _cachedFeed));
      return;
    }

    emit(MarketplaceLoading());

    try {
      final results = await searchProductsUseCase(
        query: query,
        category: event.category,
        sort: event.sort,
        lat: event.lat,
        lng: event.lng,
        page: event.page,
        limit: event.limit,
      );

      emit(SearchProductsLoaded(results: results));
    } catch (e) {
      emit(MarketplaceFailure('Search products failed: ${e.toString()}'));
    }
  }
}
