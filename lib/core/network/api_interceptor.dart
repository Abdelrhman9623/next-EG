import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:next_app/core/error/api_error.dart';
import 'token_storage.dart';

/// Interceptor for handling API requests and responses
/// Handles authentication, logging, and error formatting
class ApiInterceptor extends Interceptor {
  /// Token getter - override this to provide auth token
  /// Example: Get it from secure storage or state management
  String? Function()? getToken;

  /// Token storage - alternative way to get token
  TokenStorage? tokenStorage;

  ApiInterceptor({this.getToken, this.tokenStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token if available
    String? token;

    // Try to get token from storage first
    if (tokenStorage != null) {
      token = await tokenStorage!.getAccessToken();
    }

    // Fallback to getToken callback
    if ((token == null || token.isEmpty) && getToken != null) {
      token = getToken!();
    }

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Add common headers
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept'] = 'application/json';

    // Log request (you can use logger package here)
    _logRequest(options);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log response
    _logResponse(response);

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Format error to custom ApiError
    final apiError = _handleError(err);

    // Log error
    _logError(err, apiError);

    // Create new error response with formatted error
    final errorResponse = Response(
      requestOptions: err.requestOptions,
      statusCode: err.response?.statusCode,
      statusMessage: apiError.message,
      data: err.response?.data,
    );

    super.onError(
      DioException(
        requestOptions: err.requestOptions,
        response: errorResponse,
        type: err.type,
        error: apiError,
      ),
      handler,
    );
  }

  /// Handle DioException and convert to ApiError
  ApiError _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutError();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _extractErrorMessage(error.response?.data);

        switch (statusCode) {
          case 401:
            return const UnauthorizedError();
          case 403:
            return const ForbiddenError();
          case 404:
            return const NotFoundError();
          case 500:
          case 502:
          case 503:
            return ServerError(
              message: message ?? 'Server error',
              statusCode: statusCode,
            );
          default:
            return ClientError(
              message: message ?? 'Client error',
              statusCode: statusCode,
            );
        }

      case DioExceptionType.connectionError:
        return const NetworkError();

      case DioExceptionType.cancel:
        return const UnknownError(message: 'Request cancelled');

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return UnknownError(
          message: error.message ?? 'An unknown error occurred',
        );
    }
  }

  /// Extract error message from response data
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      // Common error message fields
      return data['message'] as String? ??
          data['error'] as String? ??
          data['errors']?.toString();
    }

    if (data is String) {
      return data;
    }

    return data.toString();
  }

  /// Log request details
  void _logRequest(RequestOptions options) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────────────');
      debugPrint('│ REQUEST: ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Data: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────────────────────────');
    }
  }

  /// Log response details
  void _logResponse(Response response) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────────────');
      debugPrint(
        '│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
      );
      debugPrint('│ Data: ${response.data}');
      debugPrint('└─────────────────────────────────────────────────────────');
    }
  }

  /// Log error details
  void _logError(DioException error, ApiError apiError) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────────────────');
      debugPrint('│ ERROR: ${error.type}');
      debugPrint('│ ${apiError.message}');
      debugPrint('│ Status: ${error.response?.statusCode}');
      if (error.response?.data != null) {
        debugPrint('│ Data: ${error.response?.data}');
      }
      debugPrint('└─────────────────────────────────────────────────────────');
    }
  }
}
