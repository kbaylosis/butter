import 'package:butter/butter.dart';

import '../modules/home/home.dart';
import '../modules/init/init.dart';
import '../utils/transitions/fade_page_transition.dart';

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
