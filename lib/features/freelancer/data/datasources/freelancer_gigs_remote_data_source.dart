import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/features/freelancer/data/models/gig_model.dart';
import 'package:ehtirafy_app/features/freelancer/domain/entities/gig_entity.dart';
import 'package:ehtirafy_app/core/network/base_response.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:ehtirafy_app/features/client/home/data/models/category_model.dart';

abstract class FreelancerGigsRemoteDataSource {
  /// Get gigs with user_type parameter
  /// - user_type=freelancer → Freelancer (photographer) sees their own gigs
  /// - user_type=customer → Customer (client) sees all available ads
  Future<List<GigModel>> getGigs({String userType = 'freelancer'});

  /// Get advertisement/gig details by ID
  Future<GigModel> getGigById(String id);

  /// Get categories from API
  Future<List<CategoryModel>> getCategories();

  Future<GigModel> addGig(Map<String, dynamic> data);
  Future<GigModel> updateGig(String id, Map<String, dynamic> data);
  Future<void> deleteGig(String id);
}

class FreelancerGigsRemoteDataSourceImpl
    implements FreelancerGigsRemoteDataSource {
  final DioClient _dioClient;

  FreelancerGigsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<GigModel>> getGigs({String userType = 'freelancer'}) async {
    final response = await _dioClient.get(
      ApiConstants.advertisements,
      queryParameters: {'user_type': userType},
    );
    final raw = response.data;
    if (raw is! Map<String, dynamic>) {
      throw const ServerException('Invalid server response');
    }
    final baseResponse = BaseResponse<List<dynamic>>.fromJson(
      raw,
      (data) => data is List ? data : <dynamic>[],
    );
    if (baseResponse.status == 200) {
      return (baseResponse.data ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(GigModel.fromJson)
          .toList();
    } else {
      throw ServerException(baseResponse.message);
    }
  }

  @override
  Future<GigModel> getGigById(String id) async {
    final response = await _dioClient.get(
      ApiConstants.advertisementDetails(id),
    );
    final raw = response.data;
    if (raw is! Map<String, dynamic>) {
      throw const ServerException('Invalid server response');
    }
    final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
      raw,
      (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
    );
    if (baseResponse.status == 200) {
      final d = baseResponse.data;
      if (d == null) {
        throw ServerException(baseResponse.message);
      }
      return GigModel.fromJson(d);
    } else {
      throw ServerException(baseResponse.message);
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dioClient.get(ApiConstants.categories);
      debugPrint('Categories API Response: ${response.statusCode}');
      debugPrint('Categories API Data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['data'] is List) {
          final list = data['data'] as List;
          debugPrint('Categories count from API: ${list.length}');
          final categories = list
              .whereType<Map<String, dynamic>>()
              .map(CategoryModel.fromJson)
              .toList();
          debugPrint(
            'Parsed categories: ${categories.map((c) => c.nameAr).join(", ")}',
          );
          return categories;
        }
      }
      debugPrint('Categories API: No data or status not 200');
      return [];
    } catch (e) {
      debugPrint('Categories API Error: $e');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<GigModel> addGig(Map<String, dynamic> data) async {
    final Map<String, dynamic> formDataMap = {
      'ar_title': data['ar_title'] ?? '',
      'en_title': data['en_title'] ?? '',
      'ar_description': data['ar_description'] ?? '',
      'en_description': data['en_description'] ?? '',
      'category_id': data['category_id'] ?? '',
      'price': data['price'] ?? 0,
    };

    // Handle images - API expects indexed format: images[0], images[1], etc.
    if (data.containsKey('images') && data['images'] is List) {
      final List<String> imagePaths = List<String>.from(data['images']);
      for (int i = 0; i < imagePaths.length; i++) {
        formDataMap['images[$i]'] = await MultipartFile.fromFile(imagePaths[i]);
      }
    }

    // Handle days_availability - API expects indexed format: days_availability[0], days_availability[1], etc.
    if (data.containsKey('days_availability') &&
        data['days_availability'] is List) {
      final List<String> availability = List<String>.from(
        data['days_availability'],
      );
      for (int i = 0; i < availability.length; i++) {
        formDataMap['days_availability[$i]'] = availability[i];
      }
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await _dioClient.post(
      ApiConstants.advertisements,
      data: formData,
    );

    // API returns the created advertisement object in 'data' field
    // Example: { "status": 200, "message": "...", "data": { "id": 8, "title": {...}, ... } }

    final body = response.data;
    // Accept all the success shapes this backend uses: HTTP 200/201 plus either
    // a numeric status field (200/201) OR success: true (most write endpoints
    // return {"success": true, ...} with no "status" field).
    final bool created =
        (response.statusCode == 200 || response.statusCode == 201) &&
        body is Map &&
        (body['status'] == 200 ||
            body['status'] == 201 ||
            body['success'] == true);
    if (created) {
      final responseData = body['data'];
      if (responseData is Map<String, dynamic>) {
        // Parse the created gig from response
        return GigModel(
          id: responseData['id']?.toString() ?? 'temp',
          title: _extractLocalizedText(responseData['title']),
          description: _extractLocalizedText(responseData['description']),
          price: double.tryParse(responseData['price']?.toString() ?? '0') ?? 0,
          category: responseData['category_id']?.toString() ?? '',
          status: GigStatus.pending,
          coverImage: '',
          createdAt: responseData['created_at'] != null
              ? DateTime.tryParse(responseData['created_at'].toString())
              : null,
        );
      }
      // Created successfully but the response body has no/unexpected data —
      // return a minimal pending gig so the success flow (message + navigation
      // to home) still proceeds instead of being treated as a failure.
      return const GigModel(
        id: 'temp',
        title: '',
        description: '',
        price: 0,
        category: '',
        status: GigStatus.pending,
        coverImage: '',
        createdAt: null,
      );
    }

    final msg = body is Map ? body['message']?.toString() : null;
    throw ServerException(msg ?? 'فشل في إضافة الخدمة');
  }

  /// Helper to extract Arabic text from localized object
  String _extractLocalizedText(dynamic value) {
    if (value is Map) {
      return value['ar']?.toString() ?? value['en']?.toString() ?? '';
    }
    return value?.toString() ?? '';
  }

  @override
  Future<GigModel> updateGig(String id, Map<String, dynamic> data) async {
    final Map<String, dynamic> formDataMap = {
      '_method': 'put',
      'ar_title': data['ar_title'] ?? '',
      'en_title': data['en_title'] ?? '',
      'ar_description': data['ar_description'] ?? '',
      'en_description': data['en_description'] ?? '',
      'category_id': data['category_id'] ?? '',
      'price': data['price'] ?? 0,
    };

    // Handle images - API expects indexed format: images[0], images[1], etc.
    if (data.containsKey('images') && data['images'] is List) {
      final List<String> imagePaths = List<String>.from(data['images']);
      for (int i = 0; i < imagePaths.length; i++) {
        formDataMap['images[$i]'] = await MultipartFile.fromFile(imagePaths[i]);
      }
    }

    // Handle days_availability - API expects indexed format
    if (data.containsKey('days_availability') &&
        data['days_availability'] is List) {
      final List<String> availability = List<String>.from(
        data['days_availability'],
      );
      for (int i = 0; i < availability.length; i++) {
        formDataMap['days_availability[$i]'] = availability[i];
      }
    }

    final formData = FormData.fromMap(formDataMap);

    final response = await _dioClient.post(
      '${ApiConstants.advertisements}/$id',
      data: formData,
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const ServerException('Invalid server response');
    }
    final baseResponse = BaseResponse<Map<String, dynamic>>.fromJson(
      body,
      (data) => data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    if (baseResponse.status == 200 || body['success'] == true) {
      // Return a dummy model or parse the actual data if available
      // The log shows data contains the updated object
      final data = baseResponse.data;
      if (data != null) {
        return GigModel.fromJson(data);
      }

      return const GigModel(
        id: 'temp',
        title: '',
        description: '',
        price: 0,
        category: '',
        status: GigStatus.pending,
        coverImage: '',
        createdAt: null,
      );
    } else {
      throw ServerException(baseResponse.message);
    }
  }

  @override
  Future<void> deleteGig(String id) async {
    await _dioClient.delete('${ApiConstants.advertisements}/$id');
    // Assuming delete also returns standard structure
    // If 200 OK
  }
}
