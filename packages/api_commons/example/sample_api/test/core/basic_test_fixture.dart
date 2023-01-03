import 'basic_test_harness.dart';

abstract class BasicTestFixture<T extends BasicTestHarness> {
  BasicTestFixture(this.routeName);

  final String routeName;
  void perform(T harness);
}
