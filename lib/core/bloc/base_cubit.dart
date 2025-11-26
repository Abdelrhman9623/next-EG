import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_state.dart';

/// Base cubit class that all feature cubits should extend
/// Provides common functionality for state management
///
/// Note: Feature cubits should define their own state classes that extend BaseState
/// and include LoadingState, SuccessState, or ErrorState as needed
abstract class BaseCubit<T extends BaseState> extends Cubit<T> {
  BaseCubit(super.initialState);

  /// Helper method to handle async operations with loading/error states
  ///
  /// Example usage in a feature cubit:
  /// ```dart
  /// Future<void> loadData() async {
  ///   await executeWithLoading(
  ///     action: () => repository.getData(),
  ///     onLoading: () => emit(state.copyWith(isLoading: true)),
  ///     onSuccess: (data) {
  ///       emit(state.copyWith(data: data, isLoading: false));
  ///     },
  ///     onError: (message, error) {
  ///       emit(state.copyWith(isLoading: false, errorMessage: message));
  ///     },
  ///   );
  /// }
  /// ```
  Future<void> executeWithLoading<D>({
    required Future<D> Function() action,
    void Function()? onLoading,
    required void Function(D data) onSuccess,
    void Function(String message, Object? error)? onError,
    String? errorMessage,
  }) async {
    try {
      // Emit loading state
      if (onLoading != null) {
        onLoading();
      }

      final result = await action();
      onSuccess(result);
    } catch (e) {
      // Emit error state
      final message = errorMessage ?? 'An error occurred. Please try again.';
      if (onError != null) {
        onError(message, e);
      }
    }
  }

  /// Check if current state is loading
  bool get isLoading => state is LoadingState;

  /// Check if current state is success
  bool get isSuccess => state is SuccessState;

  /// Check if current state is error
  bool get isError => state is ErrorState;

  /// Get error message if state is error
  String? get errorMessage {
    if (state is ErrorState) {
      return (state as ErrorState).message;
    }
    return null;
  }

  /// Get data if state is success
  D? getData<D>() {
    if (state is SuccessState<D>) {
      return (state as SuccessState<D>).data;
    }
    return null;
  }
}
