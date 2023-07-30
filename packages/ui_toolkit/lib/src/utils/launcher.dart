import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  await canLaunchUrl(uri)
      ? await launchUrl(uri)
      : throw 'Could not launch $url';
}
