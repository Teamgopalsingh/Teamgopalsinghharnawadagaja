class DevelopmentProject {
  final String id;
  final String title;
  final String wardName;
  final String status; // प्रस्तावित, स्वीकृत, निर्माणाधीन, पूर्ण
  final double progressPercent;
  final String estimatedBudget;
  final String? beforeImageUrl;
  final String? afterImageUrl;
  final String description;
  final String locationDetails;

  DevelopmentProject({
    required this.id,
    required this.title,
    required this.wardName,
    required this.status,
    required this.progressPercent,
    required this.estimatedBudget,
    this.beforeImageUrl,
    this.afterImageUrl,
    required this.description,
    required this.locationDetails,
  });

  factory DevelopmentProject.fromJson(Map<String, dynamic> json) {
    return DevelopmentProject(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      wardName: json['ward_name'] ?? 'वार्ड - हरनावदा गजा',
      status: json['status'] ?? 'प्रस्तावित',
      progressPercent: json['progress_percent'] != null ? (json['progress_percent'] as num).toDouble() : 0.0,
      estimatedBudget: json['estimated_budget'] ?? 'रु. 0',
      beforeImageUrl: json['before_image_url'],
      afterImageUrl: json['after_image_url'],
      description: json['description'] ?? '',
      locationDetails: json['location_details'] ?? '',
    );
  }
}
