import 'package:flutter/widgets.dart';

import 'base_page_view.dart';

abstract class BaseStatelessPageView extends StatelessWidget implements BasePageView {
  @override
  getElement(String key) {
    return null;
  }
}