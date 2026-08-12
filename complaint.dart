class Complaint {
  final String id;
  final String referenceId;
  final String category;
  final String description;
  final String? photoUrl;
  final String? documentUrl;
  final double? latitude;
  final double? longitude;
  final String status;
  final DateTime createdAt;
  final bool isSyncedToSampark;

  Complaint({
    required this.id,
    required this.referenceId,
    required this.category,
    required this.description,
    this.photoUrl,
    this.documentUrl,
    this.latitude,
    this.longitude,
    required this.status,
    required this.createdAt,
    this.isSyncedToSampark = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference_id': referenceId,
      'category': category,
      'description': description,
      'photo_url': photoUrl,
      'document_url': documentUrl,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'is_synced_to_sampark': isSyncedToSampark,
    };
  }

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'] ?? '',
      referenceId: json['reference_id'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      photoUrl: json['photo_url'],
      documentUrl: json['document_url'],
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      status: json['status'] ?? 'लंबित',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      isSyncedToSampark: json['is_synced_to_sampark'] ?? false,
    );
  }
}
