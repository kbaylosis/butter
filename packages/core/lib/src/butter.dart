import 'package:logger/logger.dart';

/// Provider of first class butter library objects and settings
class Butter {
  /// If true, the framework logs will be appear on the console
  static var showFxLogs = false;

  /// If true, appends the timestamp on the logs
  static var showTimestamp = false;

  /// The logger object
  static Logger get log => Logger(
        printer: _SimpleLogPrinter(),
      );

  /// Sets the log level
  static set level(LogLevel l) => Logger.level = l.alias;

  /// Shorthand for the verbose log
  static get v => _v;

  /// Shorthand for the debug log
  static get d => _d;

  /// Shorthand for the info log
  static get i => _i;

  /// Shorthand for the warning log
  static get w => _w;

  /// Shorthand for the erro log
  static get e => _e;

  /// Shorthand for the fata log
  static get f => _wtf;

  static _v(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) =>
      log.v(message.toString(), [error, stackTrace]);

  static _d(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) =>
      log.d(message.toString(), [error, stackTrace]);

  static _i(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) =>
      log.i(message.toString(), [error, stackTrace]);

  static _w(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) =>
      log.w(message.toString(), [error, stackTrace]);

  static _e(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) =>
      log.e(message.toString(), [error, stackTrace]);

  static _wtf(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) =>
      log.wtf(message.toString(), [error, stackTrace]);
}

/// Logger printer configuration
class _SimpleLogPrinter extends LogPrinter {
  static final levelEmojis = {
    Level.verbose: '',
    Level.debug: '🐞',
    Level.info: '💡',
    Level.warning: '⚠️',
    Level.error: '⛔',
    Level.wtf: '👾',
  };

  /// Handles the print formatting of the log
  @override
  List<String> log(LogEvent event) {
    if (_extractMessage(event.message)!['fx'] && !Butter.showFxLogs) {
      return [];
    }

    return [
      '🧈: ${Butter.showTimestamp ? '${DateTime.now()}: ' : ''}${levelEmojis[event.level]} ${_extractMessage(event.message)!['m']}'
    ];
  }

  /// Formats a message object into a map
  Map? _extractMessage(var message) {
    if (message is String) {
      return {
        'fx': false,
        'm': message.toString(),
      };
    }

    return message;
  }
}

/// Butter log levels
enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  fatal,
  nothing,
}

/// An extension to LogLevel
extension _LogLevelExtension on LogLevel {
  /// Generates an alias of type Logger Level
  Level get alias {
    switch (this) {
      case LogLevel.verbose:
        return Level.verbose;
      case LogLevel.info:
        return Level.info;
      case LogLevel.warning:
        return Level.warning;
      case LogLevel.error:
        return Level.error;
      case LogLevel.fatal:
        return Level.wtf;
      case LogLevel.nothing:
        return Level.nothing;
      case LogLevel.debug:
      default:
        return Level.debug;
    }
  }
}
