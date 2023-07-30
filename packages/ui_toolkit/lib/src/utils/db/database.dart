export 'package:moor/moor.dart';
export '' if (dart.library.html) 'package:moor/moor_web.dart';
export 'database_table.dart';
export 'mobile_database.dart' if (dart.library.html) 'browser_database.dart';
