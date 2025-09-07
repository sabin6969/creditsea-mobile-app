class AppException implements Exception {
  final String message;
  AppException({required this.message}) : super();
}

/// to be thrown for status code 400 from the server
class BadRequestException extends AppException {
  BadRequestException({String? message})
    : super(message: message ?? "Bad Request Exception");
}

/// to be thrown for status code 500 from the server
class InternalServerException extends AppException {
  InternalServerException({String? message})
    : super(message: message ?? "Internal Server Error");
}

/// to be thrown for status code 401 from the server
class UnauthorizedException extends AppException {
  UnauthorizedException({String? message})
    : super(message: message ?? "Unauthorized Request");
}

// to be thrown for status code 403 from the server
class ForbiddenException extends AppException {
  ForbiddenException({String? message})
    : super(message: message ?? "Forbidden Exception");
}

// to be thrown when server request timeout is reached
class TimeoutException extends AppException {
  TimeoutException({String? message})
    : super(message: message ?? "Server Request Timeout");
}

/// to be thrown for status code 404 from the server
class ResourceNotFoundException extends AppException {
  ResourceNotFoundException({String? message})
    : super(message: message ?? "Requested resource doesnot exists in server");
}

/// to be thrown for status code 404 from the server
class ResourceConflictException extends AppException {
  ResourceConflictException({String? message})
    : super(message: message ?? "Resource already exists");
}

/// Exception thrown when a user manually interrupts an ongoing process.
///
/// For example, when the user initiates a "Continue with Google" flow
/// but then presses the back button before completion.
class UserInterruptionException extends AppException {
  UserInterruptionException({String? message})
    : super(message: message ?? "Process interrupted by the user");
}

class NoInternetException extends AppException {
  NoInternetException({String? message})
    : super(
        message: "No internet connection.Please check your Wifi, Mobile Data",
      );
}
