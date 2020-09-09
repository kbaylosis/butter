import 'package:async_redux/async_redux.dart';
import 'package:butter/src/app_state.dart';

abstract class AppPersistor extends Persistor<AppState> {
  final String file;

  LocalPersist _persist;

  AppPersistor(this.file);

  LocalPersist get persist {
    if (_persist == null) {
      _persist = LocalPersist(this.file);
    }

    return _persist;
  }
}
