import 'package:butter/butter.dart';

import '../modules/todo/todo.dart';
import '../utils/transitions/scale_page_transition.dart';

class Routes extends BaseRoutes {
  Routes()
      : super(
          modules: [
            Todo(), // First defined module gets the root route ('/')
          ],
          defaultTransition: ScalePageTransition(),
        );
}
