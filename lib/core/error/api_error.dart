import 'package:equatable/equatable.dart';

/// Base class for API errors
abstract class ApiError extends Equatable {
  final String message;
  final int? statusCode;

  const ApiError({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Network error - no internet connection
class NetworkError extends ApiError {
  const NetworkError({super.message = 'No internet connection'});

  @override
  List<Object?> get props => [message];
}

/// Server error - 5xx status codes
class ServerError extends ApiError {
  const ServerError({required super.message, super.statusCode});
}

/// Client error - 4xx status codes
class ClientError extends ApiError {
  const ClientError({required super.message, super.statusCode});
}

/// Unauthorized error - 401
class UnauthorizedError extends ApiError {
  const UnauthorizedError({
    super.message = 'Unauthorized. Please login again.',
    super.statusCode = 401,
  });
}

/// Forbidden error - 403
class ForbiddenError extends ApiError {
  const ForbiddenError({
    super.message = 'Access forbidden',
    super.statusCode = 403,
  });
}

/// Not found error - 404
class NotFoundError extends ApiError {
  const NotFoundError({
    super.message = 'Resource not found',
    super.statusCode = 404,
  });
}

/// Timeout error
class TimeoutError extends ApiError {
  const TimeoutError({super.message = 'Request timeout. Please try again.'});
}

/// Unknown error
class UnknownError extends ApiError {
  const UnknownError({super.message = 'An unknown error occurred'});
}
