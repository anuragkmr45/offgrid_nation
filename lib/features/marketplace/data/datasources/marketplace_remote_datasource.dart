import 'dart:io';
import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:http/http.dart' as http;
import 'package:offgrid_nation_app/features/marketplace/domain/entities/category_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/my_product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';

abstract class MarketplaceRemoteDataSource {
  Future<Map<String, dynamic>> addProduct({
    required String title,
    required String price,
    required String condition,
    required String description,
    required String category,
    required String lat,
    required String lng,
    List<File>? pictures,
  });
  Future<Map<String, dynamic>> getProductDetails(String productId);
  Future<List<dynamic>> listProducts({
    required double latitude,
    required double longitude,
    int limit,
    String? cursor,
    String? sortBy,
    String? category,
  });
  Future<Map<String, dynamic>> addRating({
    required String productId,
    required int star,
  });
  Future<Map<String, dynamic>> getRatings(String productId);
  Future<List<CategoryEntity>> getCategories();
  Future<List<dynamic>> listMyProducts(MyProductFilter filter);
  Future<void> deleteProduct(String productId);
  Future<List<ProductEntity>> searchProducts({
    required String query,
    String? category,
    String? sort,
    double? lat,
    double? lng,
    int page,
    int limit,
  });
}

class MarketplaceRemoteDataSourceImpl implements MarketplaceRemoteDataSource {
  final ApiClient apiClient;
  final AuthSession authSession;

  MarketplaceRemoteDataSourceImpl({
    required this.apiClient,
    required this.authSession,
  });

  @override
  Future<Map<String, dynamic>> addProduct({
    required String title,
    required String price,
    required String condition,
    required String description,
    required String category,
    required String lat,
    required String lng,
    List<File>? pictures,
  }) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Unauthorized');
      
      if (title.length > 200) {
        throw const NetworkException('Title must be 200 characters or fewer.');
      }
      if (description.length > 2000) {
        throw const NetworkException(
          'Description must be 2000 characters or fewer.',
        );
      }

      final uri = Uri.parse(
        ApiConstants.baseUrl,
      ).resolve(ApiConstants.addProductEndpoint);

      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token';

      // Required form fields
      request.fields['title'] = title;
      request.fields['price'] = price;
      request.fields['condition'] = condition;
      request.fields['description'] = description;
      request.fields['category'] = category;
      request.fields['lat'] = lat;
      request.fields['lng'] = lng;

      // Optional pictures: enforce max 10 files and 10 MB size limit each
      if (pictures != null && pictures.isNotEmpty) {
        if (pictures.length > 10) {
          throw const NetworkException(
            'You can upload a maximum of 10 pictures.',
          );
        }

        for (final file in pictures) {
          final length = await file.length();
          if (length > 10 * 1024 * 1024) {
            throw const NetworkException('Each picture must be 10MB or less.');
          }

          final stream = http.ByteStream(file.openRead());
          final multipartFile = http.MultipartFile(
            'pictures',
            stream,
            length,
            filename: file.path.split('/').last,
          );
          request.files.add(multipartFile);
        }
      }

      final streamedResponse = await request.send();
      // // Print form fields
      // print('Form Fields:');
      // request.fields.forEach((key, value) {
      //   print('$key: $value');
      // });

      // // Print file info
      // if (request.files.isNotEmpty) {
      //   print('Attached Pictures:');
      //   for (var file in request.files) {
      //     print('Filename: ${file.filename}, Length: ${file.length}');
      //   }
      // }

      final response = await http.Response.fromStream(streamedResponse);

        return apiClient.processResponse(response);
    } catch (e) {
      throw NetworkException('Add product failed: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getProductDetails(String productId) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Unauthorized');

      final endpoint = ApiConstants.getProductDetailsEndpoint.replaceAll(
        ":productId",
        productId,
      );

      final response = await apiClient.get(
        endpoint,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response == null || response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid product details response');
      }
      return response;
    } catch (e) {
      throw NetworkException('Get product details failed: ${e.toString()}');
    }
  }

  @override
  Future<List<dynamic>> listProducts({
    required double latitude,
    required double longitude,
    int limit = 20,
    String? cursor,
    String? sortBy,
    String? category,
  }) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Unauthorized');
      
      final queryParams = {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'limit': limit.toString(),
        if (cursor != null) 'cursor': cursor,
        if (sortBy != null) 'sortBy': sortBy,
        if (category != null) 'category': category,
      };

      final response = await apiClient.get(
        ApiConstants.listProductsEndpoint,
        headers: {'Authorization': 'Bearer $token'},
        queryParams: queryParams,
      );
      
      if (response == null || response is! List) {
        throw const NetworkException('Invalid list products response');
      }
      return response;
    } catch (e) {
      throw NetworkException('List products failed: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> addRating({
    required String productId,
    required int star,
  }) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Unauthorized');

      final response = await apiClient.post(
        '/ratings/$productId',
        headers: {'Authorization': 'Bearer $token'},
        body: {'star': star},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid add rating response');
      }
      return response;
    } catch (e) {
      throw NetworkException('Add rating failed: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>> getRatings(String productId) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Unauthorized');

      final response = await apiClient.get(
        '/ratings/$productId',
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid ratings response');
      }
      return response;
    } catch (e) {
      throw NetworkException('Get ratings failed: ${e.toString()}');
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await apiClient.get(ApiConstants.listCategoriesEndpoint);

      if (response is! List) {
        throw const NetworkException('Invalid categories response');
      }
      return response.map((e) => CategoryEntity.fromJson(e)).toList();
    } catch (e) {
      throw NetworkException('Get categories failed: ${e.toString()}');
    }
  }

  @override
  Future<List<dynamic>> listMyProducts(MyProductFilter filter) async {
    final token = await authSession.getSessionToken();
    try {
      if (token == null) throw const NetworkException('Unauthorized');
      final response = await apiClient.get(
        ApiConstants.listMyProductsEndpoint,
        headers: {'Authorization': 'Bearer $token'},
        queryParams: filter.toQueryParams(),
      );

      if (response == null || response is! List) {
        throw const NetworkException('Invalid list my products response');
      }

      return response;
    } catch (e) {
      throw NetworkException('Fail to fetch own products: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Unauthorized');

      final endpoint = ApiConstants.deleteProductEndpoint.replaceAll(
        ":productId",
        productId,
      );

      await apiClient.delete(
        endpoint,
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      throw NetworkException('Delete product failed: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts({
    required String query,
    String? category,
    String? sort,
    double? lat,
    double? lng,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (query.trim().isEmpty) {
        throw const NetworkException('Search query is required.');
      }
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Unauthorized');
      
      final queryParams = {
        'q': Uri.encodeComponent(query),
        'page': page.toString(),
        'limit': limit.toString(),
        if (category != null) 'category': category,
        if (sort != null) 'sort': sort,
        if (lat != null) 'lat': lat.toString(),
        if (lng != null) 'lng': lng.toString(),
      };

      final response = await apiClient.get(
        ApiConstants.searchProductsEndpoint,
        headers: {'Authorization': 'Bearer $token'},
        queryParams: queryParams,
      );
      if (response is! List) {
        throw const NetworkException('Invalid search products response');
      }
      return response.map((e) => ProductEntity.fromJson(e)).toList();
    } catch (e) {
      throw NetworkException('Search products failed: ${e.toString()}');
    }
  }
}
