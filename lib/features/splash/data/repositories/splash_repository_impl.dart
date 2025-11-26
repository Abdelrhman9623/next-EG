import 'package:package_info_plus/package_info_plus.dart';
import '../../domain/entities/version_info.dart';
import '../../domain/repositories/splash_repository.dart';
import '../datasources/splash_remote_datasource.dart';
import '../models/version_info_model.dart';

/// Repository implementation for splash feature
class SplashRepositoryImpl implements SplashRepository {
  final SplashRemoteDataSource remoteDataSource;

  SplashRepositoryImpl({required this.remoteDataSource});

  @override
  Future<VersionInfo> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    return VersionInfoModel.fromPackageInfo(
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      packageName: packageInfo.packageName,
      appName: packageInfo.appName,
    );
  }

  @override
  Future<void> checkVersion(VersionInfo versionInfo) async {
    final versionInfoModel = VersionInfoModel(
      version: versionInfo.version,
      buildNumber: versionInfo.buildNumber,
      packageName: versionInfo.packageName,
      appName: versionInfo.appName,
    );

    await remoteDataSource.checkVersion(versionInfoModel);
  }
}
