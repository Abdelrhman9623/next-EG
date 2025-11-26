# Base Cubit & Base State

This directory contains the base classes for state management using BLoC/Cubit pattern.

## BaseState

All feature states should extend `BaseState`. It provides common state types:

- `InitialState` - Initial state when cubit is created
- `LoadingState` - When an async operation is in progress
- `SuccessState<T>` - When an operation completes successfully
- `ErrorState` - When an operation fails

## BaseCubit

All feature cubits should extend `BaseCubit<T extends BaseState>`. It provides:

- `executeWithLoading()` - Helper method for async operations
- `isLoading`, `isSuccess`, `isError` - State checkers
- `errorMessage` - Get error message from error state
- `getData<D>()` - Get data from success state

## Usage Example

### Feature State

```dart
// features/example/presentation/bloc/example_state.dart
import 'package:next_app/core/bloc/base_state.dart';

class ExampleState extends BaseState {
  final String? data;
  final bool isLoading;
  final String? errorMessage;

  const ExampleState({
    this.data,
    this.isLoading = false,
    this.errorMessage,
  });

  ExampleState copyWith({
    String? data,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExampleState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [data, isLoading, errorMessage];
}
```

### Feature Cubit

```dart
// features/example/presentation/bloc/example_cubit.dart
import 'package:next_app/core/bloc/base_cubit.dart';
import 'example_state.dart';

class ExampleCubit extends BaseCubit<ExampleState> {
  ExampleCubit() : super(const ExampleState());

  Future<void> loadData() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    
    try {
      // Your async operation here
      final data = await repository.getData();
      emit(state.copyWith(data: data, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  // Or use the helper method
  Future<void> loadDataWithHelper() async {
    await executeWithLoading<String>(
      action: () => repository.getData(),
      onSuccess: (data) {
        emit(state.copyWith(data: data));
      },
      errorMessage: 'Failed to load data',
    );
  }
}
```

