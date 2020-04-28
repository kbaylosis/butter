import 'package:butter/butter.dart';

class NewsFeedModel extends BaseUIModel<NewsFeedModel> {

  NewsFeedModel();

  @override
  String get $key => '/newsfeed';

  @override
  NewsFeedModel clone() => NewsFeedModel();
}
