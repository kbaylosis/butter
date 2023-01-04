import 'package:pub_cache/pub_cache.dart';

class Config {
  static String? get version =>
      PubCache().getLatestVersion('butter_cli')?.version.toString();
}
