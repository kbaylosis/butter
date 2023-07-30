import 'package:flutter/material.dart';

abstract class TranslatorService {
  dynamic of(BuildContext context);
  String getMessage(BuildContext context, String code) => code;
}
