import 'package:next_app/core/bloc/base_cubit.dart';
import 'package:next_app/core/error/api_error.dart';
import '../../domain/usecases/check_version_usecase.dart';
import 'splash_state.dart';

/// Cubit for splash screen
class SplashCubit extends BaseCubit<SplashState> {
  final CheckVersionUseCase checkVersionUseCase;

  SplashCubit({required this.checkVersionUseCase}) : super(const SplashState());

  /// Check app version and send to server
  Future<void> checkVersion() async {
    await executeWithLoading(
      action: () => checkVersionUseCase(),
      onLoading: () {
        emit(state.copyWith(isLoading: true, errorMessage: null));
      },
      onSuccess: (_) {
        emit(state.copyWith(isLoading: false, isVersionChecked: true));
      },
      onError: (message, error) {
        String errorMsg = message;

        // Handle specific errors
        if (error is ApiError) {
          if (error is NetworkError) {
            // For network errors, we might want to proceed anyway
            // or show a warning
            errorMsg = 'No internet connection. Continuing...';
            emit(
              state.copyWith(
                isLoading: false,
                isVersionChecked: true, // Continue even on network error
                errorMessage: errorMsg,
              ),
            );
            return;
          } else if (error is UnauthorizedError) {
            errorMsg = 'Authentication failed';
          } else {
            errorMsg = error.message;
          }
        }

        // For other errors, we might still want to proceed
        // or handle based on business logic
        emit(
          state.copyWith(
            isLoading: false,
            isVersionChecked: true, // Continue even on error
            errorMessage: errorMsg,
          ),
        );
      },
    );
  }
}
