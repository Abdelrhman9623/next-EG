# API Client & Interceptor

This directory contains the network layer setup using Dio for HTTP requests.

## Components

### ApiClient
Configured Dio instance with base URL, timeouts, and interceptors.

### ApiInterceptor
Handles:
- **Authentication**: Automatically adds Bearer token to requests
- **Error Handling**: Converts DioException to custom ApiError
- **Logging**: Logs requests, responses, and errors
- **Headers**: Adds common headers (Content-Type, Accept)

### ApiError
Custom error classes for different API error scenarios:
- `NetworkError` - No internet connection
- `ServerError` - 5xx status codes
- `ClientError` - 4xx status codes
- `UnauthorizedError` - 401
- `ForbiddenError` - 403
- `NotFoundError` - 404
- `TimeoutError` - Request timeout
- `UnknownError` - Unknown errors

## Usage

### 1. Initialize ApiClient

```dart
// In your dependency injection or app initialization
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  getToken: () {
    // Get token from secure storage, state management, etc.
    return 'your-auth-token';
  },
  connectTimeout: const Duration(seconds: 30),
  receiveTimeout: const Duration(seconds: 30),
);
```

### 2. Use in Data Sources

```dart
// features/user/data/datasources/user_remote_datasource.dart
import 'package:next_app/core/network/api_client.dart';
import 'package:next_app/core/error/api_error.dart';
import 'package:dio/dio.dart';

class UserRemoteDataSource {
  final ApiClient apiClient;

  UserRemoteDataSource({required this.apiClient});

  Future<Map<String, dynamic>> getUser(int id) async {
    try {
      final response = await apiClient.get('/users/$id');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      // Error is already formatted by interceptor
      final apiError = e.error as ApiError;
      throw apiError;
    }
  }

  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post(
        '/users',
        data: userData,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final apiError = e.error as ApiError;
      throw apiError;
    }
  }
}
```

### 3. Update Token Dynamically

```dart
// If token changes (e.g., after login)
apiClient.updateTokenGetter(() => newToken);
```

### 4. Handle Errors in Cubit

```dart
// In your feature cubit
Future<void> loadUser(int id) async {
  await executeWithLoading(
    action: () => repository.getUser(id),
    onLoading: () => emit(state.copyWith(isLoading: true)),
    onSuccess: (user) {
      emit(state.copyWith(user: user, isLoading: false));
    },
    onError: (message, error) {
      String errorMsg = message;
      
      if (error is ApiError) {
        switch (error.runtimeType) {
          case UnauthorizedError:
            // Handle logout or redirect to login
            errorMsg = 'Please login again';
            break;
          case NetworkError:
            errorMsg = 'No internet connection';
            break;
          case TimeoutError:
            errorMsg = 'Request timeout. Please try again.';
            break;
        }
      }
      
      emit(state.copyWith(
        isLoading: false,
        errorMessage: errorMsg,
      ));
    },
  );
}
```

## Customization

### Add More Interceptors

```dart
// Add logging interceptor (if using pretty_dio_logger)
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

apiClient.dio.interceptors.add(
  PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
  ),
);
```

### Custom Headers

Modify `ApiInterceptor.onRequest` to add custom headers per request or globally.

### Retry Logic

Add retry interceptor for failed requests:

```dart
import 'package:dio/retry.dart';

apiClient.dio.interceptors.add(
  RetryInterceptor(
    dio: apiClient.dio,
    options: const RetryOptions(
      retries: 3,
      retryInterval: Duration(seconds: 2),
    ),
  ),
);
```

