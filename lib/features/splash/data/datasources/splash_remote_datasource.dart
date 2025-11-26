import 'package:dio/dio.dart';
import 'package:next_app/core/error/api_error.dart';
import 'package:next_app/core/network/api_client.dart';
import '../models/version_info_model.dart';

/// Remote data source for splash feature
abstract class SplashRemoteDataSource {
  /// Send app version to server
  Future<void> checkVersion(VersionInfoModel versionInfo);
}

class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  final ApiClient apiClient;

  SplashRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> checkVersion(VersionInfoModel versionInfo) async {
    try {
      await apiClient.post('/app/version/check', data: versionInfo.toJson());
    } on DioException catch (e) {
      final apiError = e.error as ApiError;
      throw apiError;
    }
  }
}
