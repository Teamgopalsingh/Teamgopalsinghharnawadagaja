import 'package:url_launcher/url_launcher.dart';

class SamparkLauncher {
  static const String samparkPortalUrl = 'https://sampark.rajasthan.gov.in/';
  static const String samparkTollFree = '181';

  /// Safely launches Rajasthan Sampark web portal or toll-free dialer
  static Future<bool> launchSamparkPortal() async {
    final Uri url = Uri.parse(samparkPortalUrl);
    if (await canLaunchUrl(url)) {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      return false;
    }
  }

  static Future<bool> dialSamparkHelpline() async {
    final Uri telUri = Uri(scheme: 'tel', path: samparkTollFree);
    if (await canLaunchUrl(telUri)) {
      return await launchUrl(telUri);
    } else {
      return false;
    }
  }

  static String getGuidelines() {
    return 'राजस्थान संपर्क (181) पोर्टल मार्गदर्शिका:\n'
        '1. केवल सार्वजनिक विकास, पानी, बिजली, नाली, सड़क एवं प्रशासनिक समस्याओं की शिकायत दर्ज करें।\n'
        '2. शिकायत दर्ज करने पर आपको 181 से 10 अंकों का सरकारी टोकन नंबर प्राप्त होगा।\n'
        '3. अपनी स्थिति जांचने हेतु टोकन नंबर सुरक्षित रखें।';
  }
}
