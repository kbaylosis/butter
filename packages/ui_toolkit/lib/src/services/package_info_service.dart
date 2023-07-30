import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  factory PackageInfoService() {
    return _instance;
  }

  PackageInfoService._();

  static final PackageInfoService _instance = PackageInfoService._();

  static late PackageInfo _info;
  static PackageInfo get info => _info;

  Future<void> initialize() async {
    _info = await PackageInfo.fromPlatform();
  }
}
