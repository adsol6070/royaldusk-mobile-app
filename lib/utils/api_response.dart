// utils/api_response.dart
import 'package:equatable/equatable.dart';

/// Generic API response wrapper that handles success/error states
class ApiResponse<T> extends Equatable {
  final bool isSuccess;
  final T? data;
  final String? message;
  final String? errorCode;
  final int? statusCode;
  final Map<String, dynamic>? meta;

  const ApiResponse._({
    required this.isSuccess,
    this.data,
    this.message,
    this.errorCode,
    this.statusCode,
    this.meta,
  });

  /// Creates a successful response
  factory ApiResponse.success({
    T? data,
    String? message,
    int? statusCode,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse._(
      isSuccess: true,
      data: data,
      message: message,
      statusCode: statusCode,
      meta: meta,
    );
  }

  /// Creates an error response
  factory ApiResponse.error({
    String? message,
    String? errorCode,
    int? statusCode,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse._(
      isSuccess: false,
      message: message,
      errorCode: errorCode,
      statusCode: statusCode,
      meta: meta,
    );
  }

  /// Creates a response from HTTP response
  factory ApiResponse.fromHttpResponse({
    required bool isSuccess,
    required int statusCode,
    T? data,
    String? message,
    String? errorCode,
    Map<String, dynamic>? meta,
  }) {
    return ApiResponse._(
      isSuccess: isSuccess,
      data: data,
      message: message,
      errorCode: errorCode,
      statusCode: statusCode,
      meta: meta,
    );
  }

  /// Checks if response is successful
  bool get isError => !isSuccess;

  /// Gets data or throws exception if error
  T get dataOrThrow {
    if (isSuccess && data != null) {
      return data!;
    }
    throw ApiException(
      message: message ?? 'Unknown error occurred',
      errorCode: errorCode,
      statusCode: statusCode,
    );
  }

  /// Maps the data to another type
  ApiResponse<U> map<U>(U Function(T data) mapper) {
    if (isSuccess && data != null) {
      return ApiResponse.success(
        data: mapper(data!),
        message: message,
        statusCode: statusCode,
        meta: meta,
      );
    }
    return ApiResponse.error(
      message: message,
      errorCode: errorCode,
      statusCode: statusCode,
      meta: meta,
    );
  }

  /// Folds the response into a single value
  U fold<U>(
    U Function(T data) onSuccess,
    U Function(String? message, String? errorCode, int? statusCode) onError,
  ) {
    if (isSuccess && data != null) {
      return onSuccess(data!);
    }
    return onError(message, errorCode, statusCode);
  }

  @override
  List<Object?> get props => [
        isSuccess,
        data,
        message,
        errorCode,
        statusCode,
        meta,
      ];

  @override
  String toString() {
    return 'ApiResponse(isSuccess: $isSuccess, data: $data, message: $message, errorCode: $errorCode, statusCode: $statusCode)';
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final String? errorCode;
  final int? statusCode;
  final Map<String, dynamic>? meta;

  const ApiException({
    required this.message,
    this.errorCode,
    this.statusCode,
    this.meta,
  });

  @override
  String toString() {
    return 'ApiException(message: $message, errorCode: $errorCode, statusCode: $statusCode)';
  }
}

/// Extension methods for ApiResponse
extension ApiResponseExtensions<T> on ApiResponse<T> {
  /// Executes callback if successful
  ApiResponse<T> onSuccess(void Function(T data) callback) {
    if (isSuccess && data != null) {
      callback(data!);
    }
    return this;
  }

  /// Executes callback if error
  ApiResponse<T> onError(
      void Function(String? message, String? errorCode) callback) {
    if (isError) {
      callback(message, errorCode);
    }
    return this;
  }

  /// Returns data if successful, otherwise returns default value
  T? dataOrDefault(T defaultValue) {
    return isSuccess ? data : defaultValue;
  }

  /// Returns data if successful, otherwise returns null
  T? get dataOrNull => isSuccess ? data : null;
}
