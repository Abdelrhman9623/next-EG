import '../../domain/entities/version_info.dart';

/// Version info model - extends entity with JSON serialization
class VersionInfoModel extends VersionInfo {
  const VersionInfoModel({
    required super.version,
    required super.buildNumber,
    required super.packageName,
    required super.appName,
  });

  /// Create from JSON
  factory VersionInfoModel.fromJson(Map<String, dynamic> json) {
    return VersionInfoModel(
      version: json['version'] as String,
      buildNumber: json['build_number'] as String,
      packageName: json['package_name'] as String,
      appName: json['app_name'] as String,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'build_number': buildNumber,
      'package_name': packageName,
      'app_name': appName,
    };
  }

  /// Create from PackageInfo
  factory VersionInfoModel.fromPackageInfo({
    required String version,
    required String buildNumber,
    required String packageName,
    required String appName,
  }) {
    return VersionInfoModel(
      version: version,
      buildNumber: buildNumber,
      packageName: packageName,
      appName: appName,
    );
  }
}
