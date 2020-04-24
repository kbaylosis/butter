import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';

import 'app_state.dart';
import 'base_page_state.dart';
import 'base_page_view.dart';

class BasePageConnector<PageState extends BasePageState, PageView extends BasePageView> extends StoreConnector<AppState, PageState> {

  BasePageConnector({
    @required BasePageState state,
    @required PageView Function(PageState) getPage,
  }) : super(
    model: state,
    builder: (BuildContext context, PageState vm) => getPage(vm),
  );
}