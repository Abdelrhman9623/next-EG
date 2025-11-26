import 'package:dio/dio.dart';
import 'api_interceptor.dart';
import 'token_refresh_interceptor.dart';
import 'token_storage.dart';

/// API Client - Configured Dio instance for making HTTP requests
class ApiClient {
  late final Dio _dio;
  final String baseUrl;
  final ApiInterceptor _interceptor;
  TokenRefreshInterceptor? _tokenRefreshInterceptor;

  ApiClient({
    required this.baseUrl,
    String? Function()? getToken,
    TokenStorage? tokenStorage,
    Future<Map<String, String>> Function(String refreshToken)?
    refreshTokenCallback,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
  }) : _interceptor = ApiInterceptor(
         getToken: getToken,
         tokenStorage: tokenStorage,
       ) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? const Duration(seconds: 30),
        receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
        sendTimeout: sendTimeout ?? const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add token refresh interceptor first (if token storage is provided)
    if (tokenStorage != null) {
      _tokenRefreshInterceptor = TokenRefreshInterceptor(
        tokenStorage: tokenStorage,
        dio: _dio,
        baseUrl: baseUrl,
        refreshTokenCallback: refreshTokenCallback,
      );
      _dio.interceptors.add(_tokenRefreshInterceptor!);
    }

    // Add main interceptor
    _dio.interceptors.add(_interceptor);
  }

  /// Get the Dio instance
  Dio get dio => _dio;

  /// Update auth token getter
  void updateTokenGetter(String? Function()? getToken) {
    _interceptor.getToken = getToken;
  }

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
