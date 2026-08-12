class SocialLink {
  final String platform;
  final String url;
  final String iconName;

  SocialLink({
    required this.platform,
    required this.url,
    required this.iconName,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
      iconName: json['icon_name'] ?? 'link',
    );
  }
}
