class TeamContact {
  final String id;
  final String name;
  final String role;
  final String phone;
  final String areaOfFocus;
  final String? imageUrl;

  TeamContact({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.areaOfFocus,
    this.imageUrl,
  });

  factory TeamContact.fromJson(Map<String, dynamic> json) {
    return TeamContact(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      phone: json['phone'] ?? '',
      areaOfFocus: json['area_of_focus'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}
