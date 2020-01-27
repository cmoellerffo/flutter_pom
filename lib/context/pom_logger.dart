import 'package:logger/logger.dart';

class PomLogger {
  static final PomLogger instance = PomLogger._internal();
  factory PomLogger() => instance;

  PomLogger._internal() {
    _log = Logger();
  }

  Logger _log;
  Logger get log => _log;
}