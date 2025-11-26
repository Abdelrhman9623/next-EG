# Splash Feature

Splash screen feature that checks and sends app version to the server.

## Architecture

Following Clean Architecture with three layers:

### Domain Layer
- **Entity**: `VersionInfo` - Version information entity
- **Repository Interface**: `SplashRepository` - Defines repository contract
- **Use Case**: `CheckVersionUseCase` - Business logic for version check

### Data Layer
- **Model**: `VersionInfoModel` - Extends entity with JSON serialization
- **Remote Data Source**: `SplashRemoteDataSource` - API calls
- **Repository Implementation**: `SplashRepositoryImpl` - Implements repository interface

### Presentation Layer
- **State**: `SplashState` - UI state management
- **Cubit**: `SplashCubit` - State management logic
- **Page**: `SplashPage` - UI screen

## Setup

### 1. Initialize Dependencies

```dart
// In your dependency injection setup or main.dart
import 'package:next_app/core/network/api_client.dart';
import 'package:next_app/features/splash/splash.dart';

// Initialize API client
final apiClient = ApiClient(
  baseUrl: 'https://api.example.com', // Your API base URL
  getToken: () {
    // Get token from storage or state management
    return null; // Or return token if available
  },
);

// Initialize data source
final splashRemoteDataSource = SplashRemoteDataSourceImpl(
  apiClient: apiClient,
);

// Initialize repository
final splashRepository = SplashRepositoryImpl(
  remoteDataSource: splashRemoteDataSource,
);

// Initialize use case
final checkVersionUseCase = CheckVersionUseCase(
  splashRepository,
);

// Initialize cubit
final splashCubit = SplashCubit(
  checkVersionUseCase: checkVersionUseCase,
);
```

### 2. Use in Main App

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_app/features/splash/splash.dart';
import 'package:next_app/core/network/api_client.dart';

void main() {
  // Initialize API client
  final apiClient = ApiClient(
    baseUrl: 'https://api.example.com',
  );

  // Initialize splash dependencies
  final splashRemoteDataSource = SplashRemoteDataSourceImpl(
    apiClient: apiClient,
  );
  final splashRepository = SplashRepositoryImpl(
    remoteDataSource: splashRemoteDataSource,
  );
  final checkVersionUseCase = CheckVersionUseCase(splashRepository);
  final splashCubit = SplashCubit(
    checkVersionUseCase: checkVersionUseCase,
  );

  runApp(
    MaterialApp(
      home: BlocProvider<SplashCubit>.value(
        value: splashCubit,
        child: const SplashPage(),
      ),
    ),
  );
}
```

## API Endpoint

The feature sends a POST request to `/app/version/check` with the following payload:

```json
{
  "version": "1.0.0",
  "build_number": "1",
  "package_name": "com.example.app",
  "app_name": "Next App"
}
```

## Behavior

1. **On Load**: Automatically checks version when splash page loads
2. **Success**: Shows check icon and navigates to next screen
3. **Network Error**: Continues anyway (app can work offline)
4. **Other Errors**: Shows error message but continues

## Customization

### Change API Endpoint

Modify `SplashRemoteDataSourceImpl.checkVersion()`:

```dart
await apiClient.post(
  '/your/custom/endpoint', // Change this
  data: versionInfo.toJson(),
);
```

### Change Navigation

Modify `SplashPage` listener:

```dart
listener: (context, state) {
  if (state.isVersionChecked) {
    Navigator.of(context).pushReplacementNamed('/home');
    // Or
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(builder: (_) => HomePage()),
    // );
  }
},
```

### Handle Errors Differently

Modify `SplashCubit.checkVersion()` error handling based on your business logic.

