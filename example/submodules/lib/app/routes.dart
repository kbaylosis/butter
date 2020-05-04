import 'package:butter/butter.dart';

import 'package:submodules/modules/home/home.dart';
import 'package:submodules/modules/init/init.dart';
import 'package:submodules/utils/transitions/fade_page_transition.dart';

/// Registry of all top level modules
class Routes extends BaseRoutes {
  Routes()
      : super(
          modules: [
            Home(), // First defined module gets the root route ('/')
            Init(),
          ],
          defaultTransition: FadePageTransition(),
        );
}
