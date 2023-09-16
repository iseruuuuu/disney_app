import 'package:logger/logger.dart';

class Log {
  Log._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      printTime: true,
    ),
  );

  static void e(dynamic message) {
    _logger.e(message);
  }
}
