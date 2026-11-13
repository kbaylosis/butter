import 'package:flutter/material.dart';

import '../butter_toolkit.dart';
import '../utils/launcher.dart';
import 'highlight_text.dart';

class FooterWidget extends StatelessWidget {
  final String privacy;
  final String projName;
  final String projVersion;
  final String toc;
  final bool versionOnly;

  const FooterWidget({
    super.key,
    required this.privacy,
    required this.projName,
    required this.projVersion,
    required this.toc,
    this.versionOnly = false,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          versionOnly
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => launchURL(toc),
                      child: HighlightText(
                        'Terms and Conditions',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: ButterToolkit().brandInfo.dark,
                              fontSize: 10,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 8),
                    HighlightText(
                      '•',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: ButterToolkit().brandInfo.dark,
                            fontSize: 10,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => launchURL(privacy),
                      child: HighlightText(
                        'Privacy Policy',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: ButterToolkit().brandInfo.dark,
                              fontSize: 10,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
          HighlightText(
            '${projName.toUpperCase()} v$projVersion',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ButterToolkit().brandInfo.dark,
                  fontSize: 10,
                ),
          ),
        ],
      );
}
