class NewsItem {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String date;
  final String? imageUrl;
  final String category;

  NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.date,
    this.imageUrl,
    required this.category,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      date: json['date'] ?? '',
      imageUrl: json['image_url'],
      category: json['category'] ?? 'सामान्य',
    );
  }
}
