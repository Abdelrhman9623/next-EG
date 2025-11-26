import '../entities/version_info.dart';

/// Repository interface for splash feature
abstract class SplashRepository {
  /// Get app version information
  Future<VersionInfo> getAppVersion();

  /// Check and send app version to server
  Future<void> checkVersion(VersionInfo versionInfo);
}
