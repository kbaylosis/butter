import 'package:async_redux/async_redux.dart';
import 'package:async_redux/local_persist.dart';
import 'app_state.dart';

abstract class AppPersistor extends Persistor<AppState> {
  final String file;

  LocalPersist? _persist;

  AppPersistor(this.file);

  LocalPersist? get persist {
    if (_persist == null) {
      _persist = LocalPersist(this.file);
    }

    return _persist;
  }
}
