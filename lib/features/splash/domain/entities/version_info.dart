import 'package:equatable/equatable.dart';

/// Version information entity
class VersionInfo extends Equatable {
  final String version;
  final String buildNumber;
  final String packageName;
  final String appName;

  const VersionInfo({
    required this.version,
    required this.buildNumber,
    required this.packageName,
    required this.appName,
  });

  @override
  List<Object?> get props => [version, buildNumber, packageName, appName];
}
