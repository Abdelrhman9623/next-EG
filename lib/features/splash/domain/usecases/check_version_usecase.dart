import '../repositories/splash_repository.dart';

/// Use case for checking and sending app version to server
class CheckVersionUseCase {
  final SplashRepository repository;

  CheckVersionUseCase(this.repository);

  /// Execute version check
  Future<void> call() async {
    // Get app version
    final versionInfo = await repository.getAppVersion();

    // Send to server
    await repository.checkVersion(versionInfo);
  }
}
