# Token Refresh Implementation

This document explains how token refresh works in the app.

## Overview

The token refresh mechanism automatically handles expired access tokens by:
1. Detecting 401 Unauthorized errors
2. Attempting to refresh the token using the refresh token
3. Retrying the original request with the new token
4. Clearing tokens and handling errors if refresh fails

## Components

### TokenStorage
Secure storage service for managing access and refresh tokens.

```dart
final tokenStorage = TokenStorage();

// Save tokens after login
await tokenStorage.saveTokens(
  accessToken: 'access_token_here',
  refreshToken: 'refresh_token_here',
);

// Get tokens
final accessToken = await tokenStorage.getAccessToken();
final refreshToken = await tokenStorage.getRefreshToken();

// Clear tokens on logout
await tokenStorage.clearTokens();
```

### TokenRefreshInterceptor
Interceptor that automatically handles token refresh on 401 errors.

**Features:**
- Prevents multiple simultaneous refresh attempts (locking mechanism)
- Queues pending requests while refresh is in progress
- Skips refresh for auth endpoints to avoid infinite loops
- Clears tokens on refresh failure

### ApiClient Integration

```dart
// Initialize with token storage
final tokenStorage = TokenStorage();
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  tokenStorage: tokenStorage, // Enable token refresh
  refreshTokenCallback: (refreshToken) async {
    // Custom refresh logic (optional)
    // Default: POST /auth/refresh with refresh_token
    final response = await customRefreshCall(refreshToken);
    return {
      'access_token': response.accessToken,
      'refresh_token': response.refreshToken,
    };
  },
);
```

## How It Works

### 1. Normal Request Flow
```
Request → ApiInterceptor (adds token) → Server → Response
```

### 2. Expired Token Flow
```
Request → ApiInterceptor (adds expired token) → Server → 401 Error
  ↓
TokenRefreshInterceptor detects 401
  ↓
Check if refresh in progress → Wait if yes
  ↓
Call refresh endpoint → Get new tokens → Save tokens
  ↓
Retry original request with new token → Success
```

### 3. Refresh Failure Flow
```
Request → 401 Error → TokenRefreshInterceptor
  ↓
Refresh attempt → Fails
  ↓
Clear tokens → Return error to caller
  ↓
App should handle logout/redirect to login
```

## API Endpoint

### Default Refresh Endpoint
```
POST /auth/refresh
Body: {
  "refresh_token": "refresh_token_value"
}

Response: {
  "access_token": "new_access_token",
  "refresh_token": "new_refresh_token" // Optional
}
```

### Custom Refresh Callback

If your API has a different refresh endpoint or format:

```dart
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  tokenStorage: tokenStorage,
  refreshTokenCallback: (refreshToken) async {
    // Your custom refresh logic
    final response = await dio.post(
      '/custom/refresh/endpoint',
      data: {'token': refreshToken},
    );
    
    return {
      'access_token': response.data['accessToken'],
      'refresh_token': response.data['refreshToken'] ?? refreshToken,
    };
  },
);
```

## Usage in Features

### Login Feature
```dart
// After successful login
final loginResponse = await authRepository.login(email, password);

// Save tokens
await tokenStorage.saveTokens(
  accessToken: loginResponse.accessToken,
  refreshToken: loginResponse.refreshToken,
);

// Update API client token getter (if not using tokenStorage)
apiClient.updateTokenGetter(() => loginResponse.accessToken);
```

### Making Authenticated Requests
```dart
// Token is automatically added by interceptor
final response = await apiClient.get('/users/profile');
// If token expires, it's automatically refreshed and request is retried
```

### Handling Logout
```dart
// Clear tokens
await tokenStorage.clearTokens();

// Or update token getter to return null
apiClient.updateTokenGetter(() => null);
```

## Error Handling

When token refresh fails, the interceptor:
1. Clears all stored tokens
2. Returns the original 401 error
3. Your app should handle this by:
   - Redirecting to login screen
   - Showing error message
   - Clearing user session

```dart
try {
  final response = await apiClient.get('/protected-endpoint');
} on DioException catch (e) {
  if (e.error is UnauthorizedError) {
    // Token refresh failed or no refresh token
    // Handle logout
    await tokenStorage.clearTokens();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
```

## Best Practices

1. **Always use TokenStorage** for token management instead of manual storage
2. **Handle refresh failures** by redirecting to login
3. **Don't retry refresh endpoint** - it's automatically skipped
4. **Test token expiration** scenarios during development
5. **Monitor refresh attempts** in production for security

## Security Considerations

- Refresh tokens are stored securely using `flutter_secure_storage`
- Tokens are cleared on refresh failure
- Multiple refresh attempts are prevented (locking)
- Auth endpoints are excluded from refresh to prevent loops

