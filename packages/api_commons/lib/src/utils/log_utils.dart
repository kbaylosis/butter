import 'package:conduit_core/conduit_core.dart';

String toSeverity(Level level) {
  if (level.name == Level.FINEST.name ||
      level.name == Level.FINER.name ||
      level.name == Level.FINE.name) {
    return 'DEBUG';
  } else if (level.name == Level.CONFIG.name) {
    return 'NOTICE';
  } else if (level.name == Level.INFO.name) {
    return 'INFO';
  } else if (level.name == Level.WARNING.name) {
    return 'WARNING';
  } else if (level.name == Level.SEVERE.name) {
    return 'ERROR';
  } else if (level.name == Level.SHOUT.name) {
    return 'CRITICAL';
  }

  return 'DEFAULT';
}

Level toLevel(String? value) {
  switch (value) {
    case 'FINE':
      return Level.FINE;
    case 'FINER':
      return Level.FINER;
    case 'FINEST':
      return Level.FINEST;
    case 'INFO':
      return Level.INFO;
    case 'SEVERE':
      return Level.SEVERE;
    case 'SHOUT':
      return Level.SHOUT;
    case 'WARNING':
      return Level.WARNING;
    case 'OFF':
    default:
      return Level.OFF;
  }
}
