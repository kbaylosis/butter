import 'package:flutter/material.dart';

import '../../utils/asset_path.dart';
import '../highlight_text.dart';

class Header extends StatelessWidget {
  final String logoPath;
  final String title;

  const Header({
    super.key,
    required this.logoPath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Image.asset(assetPath(logoPath), height: 50),
          const SizedBox(width: 10),
          HighlightText(title, style: Theme.of(context).textTheme.headlineSmall),
        ],
      );
}
