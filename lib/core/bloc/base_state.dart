import 'package:equatable/equatable.dart';

/// Base state class that all feature states should extend
/// Provides common state types: initial, loading, success, and error
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

/// Initial state - when the cubit is first created
class InitialState extends BaseState {
  const InitialState();
}

/// Loading state - when an async operation is in progress
class LoadingState extends BaseState {
  const LoadingState();
}

/// Success state - when an operation completes successfully
/// T is the type of data returned
class SuccessState<T> extends BaseState {
  final T data;

  const SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

/// Error state - when an operation fails
class ErrorState extends BaseState {
  final String message;
  final Object? error;

  const ErrorState({required this.message, this.error});

  @override
  List<Object?> get props => [message, error];
}
