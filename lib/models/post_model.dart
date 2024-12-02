class PostModel {
  final int id;
  final String title;
  final String body;
  bool isRead;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      isRead: json['isRead'] ?? false, // Default to false if 'isRead' is null
    );
  }
}
