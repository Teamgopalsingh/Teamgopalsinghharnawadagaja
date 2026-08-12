class DocumentItem {
  final String id;
  final String title;
  final String fileType;
  final String fileSize;
  final String downloadUrl;

  DocumentItem({
    required this.id,
    required this.title,
    required this.fileType,
    required this.fileSize,
    required this.downloadUrl,
  });

  factory DocumentItem.fromJson(Map<String, dynamic> json) {
    return DocumentItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      fileType: json['file_type'] ?? 'PDF',
      fileSize: json['file_size'] ?? '1.2 MB',
      downloadUrl: json['download_url'] ?? '',
    );
  }
}
