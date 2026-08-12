import 'dart:math';

class ReferenceGenerator {
  /// Generates a reference number formatted as `TGS-2026-XXXXXX`
  /// Includes a disclaimer that this is an internal Team GopalSingh tracking reference,
  /// not a Rajasthan Government official grievance ID.
  static String generateComplaintReference() {
    final year = DateTime.now().year;
    final randomDigits = Random().nextInt(899999) + 100000;
    return 'TGS-$year-$randomDigits';
  }

  static const String disclaimer = 
      'यह संदर्भ संख्या (TGS Ref ID) केवल टीम गोपालसिंह के आंतरिक ट्रैकिंग के लिए है। '
      'सरकारी आधिकारिक कार्रवाई के लिए राजस्थान संपर्क पोर्टल (181) की टोकन संख्या प्राप्त करें।';
}
