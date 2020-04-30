import 'package:flutter/widgets.dart';

import 'base_page_specs.dart';
import 'base_page_view.dart';

/// An implementation of the [BasePageView] using a [StatelessWidget]
/// 
/// Use this for lightweight pages not needing special handling of page cycles
abstract class BaseStatelessPageView extends StatelessWidget
    implements BasePageView {

  /// The page specs of type [BasePageSpecs]
  @override
  BasePageSpecs get specs => null;
}
