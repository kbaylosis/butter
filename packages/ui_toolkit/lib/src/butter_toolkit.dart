import 'package:flutter/material.dart';

import 'brand_info.dart';
import 'services/translator_service.dart';

class ButterToolkit {
  factory ButterToolkit() {
    return _instance;
  }

  ButterToolkit._();

  static final ButterToolkit _instance = ButterToolkit._();
  late BrandInfo _brandInfo;
  VoidCallback? onBrandInfoChanged;
  late String _title;
  TranslatorService? _translator;

  void init({
    required BrandInfo brandInfo,
    required String title,
    TranslatorService? translator,
  }) {
    _brandInfo = brandInfo;
    _title = title;
    _translator = translator;
  }

  BrandInfo get brandInfo => _brandInfo;
  String get logoPath => _brandInfo.brandTheme.logoPath;
  String get title => _title;
  TranslatorService get translator =>
      _translator ?? _DefaultTranslatorService();
}

class _DefaultTranslatorService extends TranslatorService {
  @override
  of(BuildContext context) => null;
}
