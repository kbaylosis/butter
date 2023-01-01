import 'package:conduit/conduit.dart';

abstract class RouterManager<T extends ManagedObject> {
  RouterManager(this.routeName);

  final String routeName;
  static String get route => '';

  Future<void> init(ManagedContext? context);

  void build({
    required AuthServer authServer,
    required ManagedContext context,
    required String prefix,
    required Router router,
  });
}
