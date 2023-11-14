class Post {
  final int userId;
  final int id;
  final String title;
  final String description;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
  });
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': description,
    };
  }

  factory Post.fromjson(Map<String, dynamic> json) => Post(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        description: json['body'],
      );
}
