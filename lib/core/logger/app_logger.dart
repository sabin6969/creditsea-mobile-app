import 'package:logger/logger.dart';
import 'package:mobileapp/core/constants/log_level.dart';

class AppLogger {
  static final Logger _logger = Logger();
  static void logMessage(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stack,
  }) {
    switch (level) {
      case LogLevel.debug:
        _logger.d(message, time: DateTime.now());
        break;
      case LogLevel.info:
        _logger.i(message, time: DateTime.now());
        break;
      case LogLevel.error:
        _logger.e(
          message,
          time: DateTime.now(),
          error: error,
          stackTrace: stack,
        );
        break;
      case LogLevel.fatal:
        _logger.f(message, error: error, stackTrace: stack);
        break;
    }
  }
}
