import 'package:next_app/core/bloc/base_state.dart';

/// Splash screen state
class SplashState extends BaseState {
  final bool isLoading;
  final bool isVersionChecked;
  final String? errorMessage;

  const SplashState({
    this.isLoading = false,
    this.isVersionChecked = false,
    this.errorMessage,
  });

  SplashState copyWith({
    bool? isLoading,
    bool? isVersionChecked,
    String? errorMessage,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      isVersionChecked: isVersionChecked ?? this.isVersionChecked,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isVersionChecked, errorMessage];
}
