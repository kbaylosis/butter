import 'package:flutter/material.dart';

import '../../../utils/asset_path.dart';
import '../../highlight_text.dart';
import '../base_page.dart';

class ContainedPageDecor extends PageDecorator {
  final String logoPath;
  final EdgeInsets outerPadding;
  final bool showHeader;
  final String title;
  final String? footer;

  ContainedPageDecor({
    required this.logoPath,
    this.outerPadding = const EdgeInsets.all(20),
    this.showHeader = false,
    required this.title,
    this.footer,
  });

  @override
  Widget? build(BuildContext context, {Widget? child}) => Container(
        padding: outerPadding,
        child: Column(
          children: [
            _Header(logoPath: logoPath, title: title),
            Expanded(child: child!),
            _Footer(text: footer),
          ],
        ),
      );
}

class _Header extends StatelessWidget {
  final String logoPath;
  final String title;

  const _Header({
    required this.logoPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Row(
          children: [
            Image.asset(assetPath(logoPath), height: 50),
            const SizedBox(width: 10),
            HighlightText(title,
                style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      );
}

class _Footer extends StatelessWidget {
  final String? text;

  const _Footer({
    this.text,
  });

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 30),
        child: HighlightText(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 10),
          textAlign: TextAlign.center,
        ),
      );
}
