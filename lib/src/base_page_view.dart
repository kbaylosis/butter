import 'package:flutter/widgets.dart';

import 'base_page_specs.dart';

/// The base class for butter pages
abstract class BasePageView extends Widget {
  /// Retrieves the page specs of the current page
  ///
  /// This is useful for passing information from child to mother pages.
  BasePageSpecs? get specs;
}
