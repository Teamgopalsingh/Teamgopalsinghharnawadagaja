class EventItem {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String description;

  EventItem({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.description,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
