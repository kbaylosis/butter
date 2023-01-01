import 'package:conduit/conduit.dart';

abstract class Service {
  Future<void> init(ManagedContext? context);

  void run();
}
