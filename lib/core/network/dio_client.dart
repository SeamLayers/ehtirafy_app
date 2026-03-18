import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

@lazySingleton
class DioClient {
  final Dio _dio;
  final Map<String, _CacheEntry> _getCache = {};
  static const Duration _defaultGetCacheDuration = Duration(seconds: 30);
  static const Duration _homeCacheDuration = Duration(minutes: 5);
  static const Duration _freelancerListCacheDuration = Duration(minutes: 2);
  static const Duration _detailsCacheDuration = Duration(seconds: 10);

  static final List<_EndpointTtlRule> _endpointTtlRules = [
    _EndpointTtlRule(
      matcher: RegExp(r'/(categories|app/statistics)(/|$)', caseSensitive: false),
      ttl: _homeCacheDuration,
    ),
    _EndpointTtlRule(
      matcher: RegExp(r'/front/(our-works|advertisements)(/|$)', caseSensitive: false),
      ttl: _freelancerListCacheDuration,
    ),
    _EndpointTtlRule(
      matcher: RegExp(r'/(contract-detail|contract|orders?)(/|$)', caseSensitive: false),
      ttl: _detailsCacheDuration,
    ),
  ];

  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Language': Platform.localeName.split('_')[0],
          },
        ),
      ) {
    // Add auth interceptor to include Bearer token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('cached_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Ensure Accept-Language is set correctly from device locale
          options.headers['Accept-Language'] = Platform.localeName.split(
            '_',
          )[0];
          handler.next(options);
        },
        onResponse: (response, handler) {
          // Check for message in success response
          final data = response.data;
          if (data is Map<String, dynamic>) {
            // Handle "message" field
            if (data['message'] != null) {
              _showToast(data['message'].toString());
            }
            // Handle "data" -> "message" nested (sometimes backends do this)
            // But user example shows "message" at root.
          }
          handler.next(response);
        },
        onError: (e, handler) {
          // Check for message in error response
          final response = e.response;
          if (response != null && response.data is Map<String, dynamic>) {
            final data = response.data;
            if (data['message'] != null) {
              _showToast(data['message'].toString());
            }
          }
          handler.next(e);
        },
      ),
    );
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final extra = options?.extra ?? const <String, dynamic>{};
      final disableCache = extra['disableCache'] == true;
      final shouldBypassChatCache = _isChatOrMessageEndpoint(path);
      final cacheDuration = _resolveCacheDuration(
        path,
        queryParameters,
        options,
      );
      final shouldUseCache =
          !disableCache && !shouldBypassChatCache && cacheDuration > Duration.zero;

      final token = (await SharedPreferences.getInstance()).getString(
        'cached_token',
      );
      final cacheKey = _buildCacheKey(path, queryParameters, token);

      if (shouldUseCache) {
        final cached = _getCache[cacheKey];
        if (cached != null && !cached.isExpired) {
          return Response(
            requestOptions: RequestOptions(path: path, queryParameters: queryParameters),
            data: cached.data,
            headers: cached.headers,
            statusCode: cached.statusCode,
            statusMessage: 'OK (cached)',
          );
        }
      }

      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      if (shouldUseCache &&
          response.statusCode != null &&
          response.statusCode! < 400) {
        _getCache[cacheKey] = _CacheEntry(
          data: response.data,
          headers: response.headers,
          statusCode: response.statusCode ?? 200,
          expiresAt: DateTime.now().add(cacheDuration),
        );
      }

      return response;
    } catch (e) {
      rethrow;
    }
  }

  Duration _resolveCacheDuration(
    String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
  ) {
    if (_isChatOrMessageEndpoint(path)) {
      return Duration.zero;
    }

    final extra = options?.extra;
    final ttlFromExtra =
        extra?['cache_ttl'] ?? extra?['cacheDuration'] ?? extra?['ttl'];
    if (ttlFromExtra is Duration) {
      return ttlFromExtra;
    }

    for (final rule in _endpointTtlRules) {
      if (rule.matcher.hasMatch(path)) {
        if (rule.ttl == _freelancerListCacheDuration &&
            !_isFreelancerListEndpoint(path)) {
          continue;
        }

        if (rule.ttl == _detailsCacheDuration &&
            !_isSpecificOrderOrContract(path, queryParameters)) {
          continue;
        }
        return rule.ttl;
      }
    }

    if (_isSpecificContractsRelativeRequest(path, queryParameters)) {
      return _detailsCacheDuration;
    }

    return _defaultGetCacheDuration;
  }

  bool _isSpecificOrderOrContract(
    String path,
    Map<String, dynamic>? queryParameters,
  ) {
    final hasIdInQuery = queryParameters != null &&
        queryParameters.containsKey('id') &&
        '${queryParameters['id']}'.isNotEmpty;
    final hasNumericIdInPath = RegExp(r'/\d+(/|$)').hasMatch(path);
    final hasStringIdInPath = RegExp(
      r'/[a-zA-Z0-9_-]{6,}(/|$)',
    ).hasMatch(path);

    return hasIdInQuery ||
        hasNumericIdInPath ||
        hasStringIdInPath ||
        path.contains('contract-detail');
  }

  bool _isSpecificContractsRelativeRequest(
    String path,
    Map<String, dynamic>? queryParameters,
  ) {
    if (!path.toLowerCase().contains('contracts-relative')) {
      return false;
    }

    return queryParameters != null &&
        queryParameters.containsKey('id') &&
        '${queryParameters['id']}'.isNotEmpty;
  }

  bool _isFreelancerListEndpoint(String path) {
    final normalizedPath = path.toLowerCase();

    final isPortfolioList = normalizedPath.endsWith('/front/our-works');
    final isAdvertisementsList =
        normalizedPath.endsWith('/front/advertisements');

    return isPortfolioList || isAdvertisementsList;
  }

  bool _isChatOrMessageEndpoint(String path) {
    final lowerPath = path.toLowerCase();
    return lowerPath.contains('chat') ||
        lowerPath.contains('message') ||
        lowerPath.contains('messages') ||
        lowerPath.contains('conversation') ||
        lowerPath.contains('conversations');
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      _invalidateGetCache();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      _invalidateGetCache();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      _invalidateGetCache();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  String _buildCacheKey(
    String path,
    Map<String, dynamic>? queryParameters,
    String? token,
  ) {
    final normalizedQuery = _normalizeForCache(queryParameters ?? {});
    return '$path|$token|${jsonEncode(normalizedQuery)}';
  }

  dynamic _normalizeForCache(dynamic value) {
    if (value is Map) {
      final sorted = SplayTreeMap<String, dynamic>();
      value.forEach((key, dynamic mapValue) {
        sorted[key.toString()] = _normalizeForCache(mapValue);
      });
      return sorted;
    }

    if (value is List) {
      return value.map(_normalizeForCache).toList();
    }

    return value;
  }

  void _invalidateGetCache() {
    _getCache.clear();
  }
}

class _CacheEntry {
  final dynamic data;
  final Headers headers;
  final int statusCode;
  final DateTime expiresAt;

  const _CacheEntry({
    required this.data,
    required this.headers,
    required this.statusCode,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class _EndpointTtlRule {
  final RegExp matcher;
  final Duration ttl;

  const _EndpointTtlRule({required this.matcher, required this.ttl});
}
