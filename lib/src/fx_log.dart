import 'butter.dart';

class FxLog {
  static void v(String message) => Butter.v({
        'm': message,
        'fx': true,
      });

  static void d(String message) => Butter.d({
        'm': message,
        'fx': true,
      });

  static void i(String message) => Butter.i({
        'm': message,
        'fx': true,
      });

  static void w(String message) => Butter.w({
        'm': message,
        'fx': true,
      });

  static void e(String message) => Butter.e({
        'm': message,
        'fx': true,
      });

  static void f(String message) => Butter.f({
        'm': message,
        'fx': true,
      });
}
