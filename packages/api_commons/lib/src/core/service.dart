import 'package:conduit_core/conduit_core.dart';

abstract class Service {
  Future<void> init(ManagedContext? context);

  void run();
}
