import 'package:butter/butter.dart';

import 'pages/{{ noname }}_page.dart';
import 'states/{{ noname }}_state.dart';

class {{ Noname }} extends BaseModule {

  {{ Noname }}() : super(
    routeName: '/{{ noname }}',
    routes: {
      // This is the root route of the module ('/').
      '/': BasePageConnector<{{ Noname }}State, {{ Noname }}Page>(
        state: {{ Noname }}State(),
        page: {{ Noname }}Page(), 
        getPage: (vm) => {{ Noname }}Page(model: vm.model),
      ), 
    },
  );
}
