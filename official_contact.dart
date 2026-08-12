class OfficialContact {
  final String id;
  final String name;
  final String designation;
  final String department;
  final String phone;
  final String email;
  final String officeAddress;
  final String verifiedSourceUrl;

  OfficialContact({
    required this.id,
    required this.name,
    required this.designation,
    required this.department,
    required this.phone,
    required this.email,
    required this.officeAddress,
    required this.verifiedSourceUrl,
  });

  factory OfficialContact.fromJson(Map<String, dynamic> json) {
    return OfficialContact(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
      department: json['department'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      officeAddress: json['office_address'] ?? '',
      verifiedSourceUrl: json['verified_source_url'] ?? 'https://jhalawar.rajasthan.gov.in',
    );
  }
}
