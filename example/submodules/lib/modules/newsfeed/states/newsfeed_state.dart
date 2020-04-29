import 'package:butter/butter.dart';

import '../models/newsfeed_model.dart';

// Make sure to specify the model on the BasePageState
class NewsFeedState extends BasePageState<NewsFeedModel> {
  NewsFeedState();

  NewsFeedModel model;

  // This constructor form is not properly enforced. Which means, if you do not
  // follow this, no errors will be produced in butter. However, this allows you to
  // properly fillup your models with valid function handlers after being read
  // from the store and before it is being fed to the page.
  NewsFeedState.build(this.model, void Function(NewsFeedModel m) f) :
    super.build(model, f);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is NewsFeedState && 
      this.runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => this.hashCode;

  @override
  NewsFeedState fromStore() => NewsFeedState.build(read<NewsFeedModel>(
    NewsFeedModel(
      
    ),
  ), (m) {
    
  });
}
