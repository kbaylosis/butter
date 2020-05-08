import 'package:logger/logger.dart';

class Butter {
  static var production = false;
  static var showFxLogs = false;
  static var showTimestamp = false;
  static Logger get log => Logger(
        printer: _SimpleLogPrinter(),
      );

  static get v => log.v;
  static get d => log.d;
  static get i => log.i;
  static get w => log.w;
  static get e => log.e;
  static get f => log.wtf;
}

class _SimpleLogPrinter extends LogPrinter {
  static final levelEmojis = {
    Level.verbose: '',
    Level.debug: '🐞',
    Level.info: '💡',
    Level.warning: '⚠️',
    Level.error: '⛔',
    Level.wtf: '👾',
  };

  @override
  List<String> log(LogEvent event) {
    if (extractMessage(event.message)['fx'] && !Butter.showFxLogs) {
      return [];
    }

    return [
      '🧈: ${Butter.showTimestamp ? '${DateTime.now()}: ' : ''}${levelEmojis[event.level]} ${extractMessage(event.message)['m']}'
    ];
  }
}

Map extractMessage(var message) {
  if (message is String) {
    return {
      'fx': false,
      'm': message.toString(),
    };
  }

  return message;
}
