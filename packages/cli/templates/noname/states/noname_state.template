import 'package:butter/butter.dart';

import '../models/{{ noname }}_model.dart';

class {{ Noname }}State extends BasePageState<{{ Noname }}Model> {
  {{ Noname }}State();

  {{ Noname }}Model model;

  // This constructor form is not properly enforced. Which means, if you do not
  // follow this, no errors will be produced in butter. However, this allows you to
  // properly fillup your models with valid function handlers after being read
  // from the store and before it is being fed to the page.
  {{ Noname }}State.build(this.model, void Function({{ Noname }}Model m) f) :
    super.build(model, f);

  // Make sure to properly define this function. Otherwise, your reducers 
  // will not trigger view updates... and you will end up pulling all your hair.
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
      other is {{ Noname }}State && 
      this.runtimeType == other.runtimeType;
  }

  @override
  int get hashCode => this.hashCode;

  @override
  {{ Noname }}State fromStore() => {{ Noname }}State.build(read<{{ Noname }}Model>(
    {{ Noname }}Model(
      // Initialize your models here in case it is not available in the store yet
    ),
  ), (m) {
    // Load all your model's handlers here
  });
}
