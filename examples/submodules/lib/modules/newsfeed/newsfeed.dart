import 'package:butter/butter.dart';

import 'pages/newsfeed_page.dart';
import 'states/newsfeed_state.dart';

class NewsFeed extends BaseModule {

  NewsFeed() : super(
    routeName: '/newsfeed',
    routes: {
      '/': BasePageConnector<NewsFeedState, NewsFeedPage>(
        state: NewsFeedState(),
        page: NewsFeedPage(), 
        getPage: (vm) => NewsFeedPage(model: vm.model),
      ), 
    },
  );
}
