class GovernmentScheme {
  final String id;
  final String title;
  final String category; // किसान, महिला, युवा, वरिष्ठ नागरिक, आमजन
  final String benefits;
  final String eligibility;
  final String applicationProcess;
  final String officialPortalUrl;

  GovernmentScheme({
    required this.id,
    required this.title,
    required this.category,
    required this.benefits,
    required this.eligibility,
    required this.applicationProcess,
    required this.officialPortalUrl,
  });

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? 'आमजन',
      benefits: json['benefits'] ?? '',
      eligibility: json['eligibility'] ?? '',
      applicationProcess: json['application_process'] ?? '',
      officialPortalUrl: json['official_portal_url'] ?? 'https://rajasthan.gov.in',
    );
  }
}
