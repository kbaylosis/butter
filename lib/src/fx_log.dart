import 'butter.dart';

/// Provides shorthand logging capability inside the butter library
///
/// This class is not exposed outside of the library
class FxLog {
  /// A shorthand for the verbose logging
  static void v(String message) => Butter.v({
        'm': message,
        'fx': true,
      });

  /// A shorthand for the debug logging
  static void d(String message) => Butter.d({
        'm': message,
        'fx': true,
      });

  /// A shorthand for the info logging
  static void i(String message) => Butter.i({
        'm': message,
        'fx': true,
      });

  /// A shorthand for the warnign logging
  static void w(String message) => Butter.w({
        'm': message,
        'fx': true,
      });

  /// A shorthand for the error logging
  static void e(String message) => Butter.e({
        'm': message,
        'fx': true,
      });

  /// A shorthand for the fatal logging
  static void f(String message) => Butter.f({
        'm': message,
        'fx': true,
      });
}
