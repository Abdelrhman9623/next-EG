import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'token_storage.dart';

/// Interceptor for handling token refresh on 401 errors
/// Automatically refreshes token and retries the original request
class TokenRefreshInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;
  final String baseUrl;
  final Future<Map<String, String>> Function(String refreshToken)?
  refreshTokenCallback;

  // Lock to prevent multiple simultaneous refresh attempts
  bool _isRefreshing = false;
  final List<Completer<void>> _pendingRequests = [];

  TokenRefreshInterceptor({
    required this.tokenStorage,
    required this.dio,
    required this.baseUrl,
    this.refreshTokenCallback,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 Unauthorized errors
    if (err.response?.statusCode != 401) {
      return super.onError(err, handler);
    }

    // Skip refresh for refresh token endpoint to avoid infinite loop
    if (err.requestOptions.path.contains('/auth/refresh') ||
        err.requestOptions.path.contains('/auth/login')) {
      return super.onError(err, handler);
    }

    try {
      // Wait for token refresh if already in progress
      if (_isRefreshing) {
        await _waitForRefresh();
      } else {
        // Attempt to refresh token
        await _refreshToken();
      }

      // Retry the original request with new token
      final newToken = await tokenStorage.getAccessToken();
      if (newToken != null) {
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';

        // Create new request with updated token
        final response = await dio.fetch(opts);
        return handler.resolve(response);
      } else {
        // Refresh failed, clear tokens and throw error
        await tokenStorage.clearTokens();
        return super.onError(err, handler);
      }
    } catch (e) {
      // Refresh failed, clear tokens
      await tokenStorage.clearTokens();
      return super.onError(err, handler);
    }
  }

  /// Refresh the access token using refresh token
  Future<void> _refreshToken() async {
    if (_isRefreshing) return;

    _isRefreshing = true;

    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception('No refresh token available');
      }

      Map<String, String>? newTokens;

      // Use custom callback if provided, otherwise use default endpoint
      if (refreshTokenCallback != null) {
        newTokens = await refreshTokenCallback!(refreshToken);
      } else {
        // Default refresh endpoint
        final response = await dio.post(
          '$baseUrl/auth/refresh',
          data: {'refresh_token': refreshToken},
        );

        if (response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          newTokens = {
            'access_token': data['access_token'] as String? ?? '',
            'refresh_token': data['refresh_token'] as String? ?? refreshToken,
          };
        }
      }

      if (newTokens != null &&
          newTokens['access_token'] != null &&
          newTokens['access_token']!.isNotEmpty) {
        // Save new tokens
        await tokenStorage.saveTokens(
          accessToken: newTokens['access_token']!,
          refreshToken: newTokens['refresh_token'] ?? refreshToken,
        );

        if (kDebugMode) {
          debugPrint('✅ Token refreshed successfully');
        }
      } else {
        throw Exception('Invalid token response');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Token refresh failed: $e');
      }
      await tokenStorage.clearTokens();
      rethrow;
    } finally {
      _isRefreshing = false;
      // Notify all pending requests
      for (final completer in _pendingRequests) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
      _pendingRequests.clear();
    }
  }

  /// Wait for ongoing token refresh to complete
  Future<void> _waitForRefresh() async {
    final completer = Completer<void>();
    _pendingRequests.add(completer);
    return completer.future;
  }
}
