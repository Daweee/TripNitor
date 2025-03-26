import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await _launchUrl(launchUri);
  }

  static Future<void> sendSMS(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
    );
    await _launchUrl(launchUri);
  }

  static Future<void> launchEmail(String email, {String subject = ''}) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: subject.isNotEmpty ? 'subject=$subject' : null,
    );
    await _launchUrl(launchUri);
  }

  static Future<void> openWebUrl(String url) async {
    final Uri launchUri = Uri.parse(url);
    await _launchUrl(launchUri);
  }

  static Future<void> _launchUrl(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
