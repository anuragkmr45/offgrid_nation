import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';
// import 'package:offgrid_nation_app/features/marketplace/domain/usecases/add_rating_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/get_categories_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/get_product_details_usecase.dart';
// import 'package:offgrid_nation_app/features/marketplace/domain/usecases/get_ratings_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/list_products_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/my_product_list_usercase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/add_product_usecase.dart';
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

  MarketplaceBloc({
    required this.addProductUseCase,
    required this.getCategoriesUseCase,
    required this.getProductDetailsUseCase,
    required this.listProductsUseCase,
    required this.myProductListUseCase,
    // required this.addRatingUseCase,
    // required this.getRatingsUseCase,
  }) : super(MarketplaceInitial()) {
    on<AddProductRequested>(_onAddProductRequested);
    on<FetchCategoriesRequested>(_onFetchCategoriesRequested);
    on<FetchProductDetailsRequested>(_onFetchProductDetailsRequested);
    on<FetchProductsRequested>(_onFetchProductsRequested);
    on<FetchMyProductsRequested>(_onFetchMyProductsRequested);
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
    } catch (e) {
      emit(MarketplaceFailure(e.toString()));
    }
  }

  Future<void> _onFetchProductDetailsRequested(
    FetchProductDetailsRequested event,
    Emitter<MarketplaceState> emit,
  ) async {
    emit(MarketplaceLoading());
    try {
      final product = await getProductDetailsUseCase(event.productId);
      emit(ProductDetailsLoaded(product as ProductEntity));
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
    emit(MarketplaceLoading());
    try {
      final categories = await getCategoriesUseCase();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(MarketplaceFailure(e.toString()));
    }
  }

  // Future<void> _onAddRatingRequested(
  //   AddRatingRequested event,
  //   Emitter<MarketplaceState> emit,
  // ) async {
  //   emit(MarketplaceLoading());
  //   try {
  //     final response = await addRatingUseCase(
  //       productId: event.productId,
  //       star: event.star,
  //     );
  //     emit(RatingsLoaded(response));
  //   } catch (e) {
  //     emit(MarketplaceFailure(e.toString()));
  //   }
  // }

  // Future<void> _onFetchRatingsRequested(
  //   FetchRatingsRequested event,
  //   Emitter<MarketplaceState> emit,
  // ) async {
  //   emit(MarketplaceLoading());
  //   try {
  //     final response = await getRatingsUseCase(event.productId);
  //     emit(RatingsLoaded(response));
  //   } catch (e) {
  //     emit(MarketplaceFailure(e.toString()));
  //   }
  // }
}
