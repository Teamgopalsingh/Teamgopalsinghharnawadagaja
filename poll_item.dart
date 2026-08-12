class PollItem {
  final String id;
  final String question;
  final List<String> options;
  final Map<String, int> votes;

  PollItem({
    required this.id,
    required this.question,
    required this.options,
    required this.votes,
  });

  factory PollItem.fromJson(Map<String, dynamic> json) {
    return PollItem(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      votes: Map<String, int>.from(json['votes'] ?? {}),
    );
  }
}
