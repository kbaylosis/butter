import 'package:submodules/modules/function_a/function_a.dart';
import 'package:submodules/modules/function_b/function_b.dart';
import 'package:submodules/modules/newsfeed/newsfeed.dart';

class SubModules {
  // This is where you define module routes. This mechanism allows you to have
  // nested modules (a module within a module within a module, etc).
  //
  // It is highly encouraged to reflect nesting of modules on the path. So supposing
  // you have a path like... /home/functionA/functionB. This should mean that
  // functionB is embedded within functionA that is embedded in home.
  //
  static final routes = {
    '/home/newsfeed': NewsFeed(),
    '/home/functionA': FunctionA(),
    '/home/functionB': FunctionB(),
  };
}
