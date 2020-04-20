import 'package:async_redux/async_redux.dart';
import 'package:flutter/widgets.dart';

import 'app_state.dart';
import 'base_page_state.dart';

class BasePageConnector<_PageState, _PageView> extends StoreConnector<AppState, _PageState> {

  BasePageConnector({
    @required BasePageState state,
    @required Widget Function(_PageState) getPage,
  }) : super(
    model: state,
    builder: (BuildContext context, _PageState vm) => getPage(vm),
  );
}