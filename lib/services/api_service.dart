import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/models/response_vm_model.dart';

class ApiService {
  final Dio _dio;
  final Dio _refreshDio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _accessToken;
  String? _refreshToken;

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  ApiService({
    String baseUrl = 'https://store-system-api-u5w5.onrender.com/api/',
    Map<String, String>? headers,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           headers: headers,
           connectTimeout: const Duration(seconds: 20),
           receiveTimeout: const Duration(seconds: 20),
         ),
       ),
       _refreshDio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: const Duration(seconds: 20),
           receiveTimeout: const Duration(seconds: 20),
         ),
       ) {
    /// ================= LOG INTERCEPTOR =================
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    /// ================= AUTH INTERCEPTOR =================
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
  }

  // ================= REQUEST =================

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _accessToken ??= await _storage.read(key: 'accessToken');
    _refreshToken ??= await _storage.read(key: 'refreshToken');

    // لا نضيف التوكن لطلب refresh
    if (_accessToken != null &&
        options.path != '/refresh-token' &&
        _accessToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $_accessToken';
    }

    handler.next(options);
  }

  // ================= ERROR =================

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401 &&
        _refreshToken != null &&
        error.requestOptions.path != '/refresh-token') {
      try {
        await _handleTokenRefresh();

        final retryResponse = await _retryRequest(error.requestOptions);
        return handler.resolve(retryResponse);
      } catch (_) {
        await clearTokens();
      }
    }

    handler.next(error);
  }

  // ================= REFRESH HANDLING =================

  Future<void> _handleTokenRefresh() async {
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final response = await _refreshDio.post(
        '/refresh-token',
        data: {'refreshToken': _refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        if (newAccessToken == null || newRefreshToken == null) {
          throw Exception('Invalid refresh response');
        }

        await saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
      } else {
        throw Exception('Refresh token failed');
      }

      _refreshCompleter?.complete();
    } catch (e) {
      _refreshCompleter?.completeError(e);
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      validateStatus: (status) => status != null && status < 500,
    );

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // ================= TOKEN CONTROL =================

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;

    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;

    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

  // ================= HTTP METHODS =================

  Future<ResponseVM> get({
    required String endpoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final res = await _dio.get(endpoint, queryParameters: queryParams);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ResponseVM(
          isSuccess: true,
          data: res.data,
          message: res.statusMessage,
        );
      } else {
        return ResponseVM(
          isSuccess: false,
          data: res.data,
          message: res.statusMessage,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ResponseVM> post({required String endpoint, dynamic data}) async {
    try {
      final res = await _dio.post(endpoint, data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ResponseVM(
          isSuccess: true,
          data: res.data,
          message: res.statusMessage,
        );
      } else {
        return ResponseVM(
          isSuccess: false,
          data: res.data,
          message: res.statusMessage,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ResponseVM> put({required String endpoint, dynamic data}) async {
    try {
      final res = await _dio.put(endpoint, data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ResponseVM(
          isSuccess: true,
          data: res.data,
          message: res.statusMessage,
        );
      } else {
        return ResponseVM(
          isSuccess: false,
          data: res.data,
          message: res.statusMessage,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<ResponseVM> delete({required String endpoint, dynamic data}) async {
    try {
      final res = await _dio.delete(endpoint, data: data);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return ResponseVM(
          isSuccess: true,
          data: res.data,
          message: res.statusMessage,
        );
      } else {
        return ResponseVM(
          isSuccess: false,
          data: res.data,
          message: res.statusMessage,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ================= ERROR HANDLER =================

  ApiException _handleDioError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;

      String message = "حدث خطأ غير متوقع";

      if (data is Map<String, dynamic>) {
        // لو عندك message مباشرة
        if (data.containsKey('message')) {
          message = data['message']?.toString() ?? message;
        }
        // لو validation errors من .NET
        else if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is Map) {
            message = errors.values.expand((e) => e).join('\n');
          }
        }
        // fallback
        else if (data.containsKey('title')) {
          message = data['title']?.toString() ?? message;
        }
      } else if (data is String) {
        message = data;
      }

      return ApiException(
        statusCode: e.response?.statusCode ?? 0,
        message: message,
      );
    }

    return ApiException(statusCode: 0, message: e.message ?? "Network Error");
  }
}

// ================= EXCEPTION =================

class ApiException implements Exception {
  final int statusCode;
  final String? message;

  ApiException({required this.statusCode, this.message});

  @override
  String toString() {
    return 'حدث خطأ : $message';
  }
}
