class PostModel {
  final int? id;
  final String title;
  final String description;
  final String? author;
  final String? date;
  final String status;
  final String? imageUrl;

  const PostModel({
    this.id,
    required this.title,
    required this.description,
    this.author,
    this.date,
    this.status = 'published',
    this.imageUrl,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {

    final authorMap = map['author'] as Map<String, dynamic>?;
    final authorName = authorMap?['nickName'] ?? authorMap?['username'] ?? 'Unknown';


    final isPublished = map['published'] == true;
    final statusString = isPublished ? 'published' : 'draft';

    return PostModel(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['content'] ?? map['description'] ?? '',
      author: authorName,
      date: map['createdAt'] ?? map['updatedAt'],
      status: statusString,
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': description,
      'published': status == 'published',
      'imageUrl': imageUrl,
    };
  }

  PostModel copyWith({
    int? id,
    String? title,
    String? description,
    String? author,
    String? date,
    String? status,
    String? imageUrl,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      date: date ?? this.date,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}