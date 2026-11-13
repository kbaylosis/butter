import 'package:flutter/material.dart';

import '../../butter_toolkit.dart';
import '../highlight_text.dart';

class Footer extends StatelessWidget {
  final String text;

  const Footer({super.key, this.text = 'Powered by Zoog '});

  @override
  Widget build(BuildContext context) => HighlightText(text,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: ButterToolkit().brandInfo.grayLight,
              fontSize: 10,
            ),
        textAlign: TextAlign.center,
      );
}
