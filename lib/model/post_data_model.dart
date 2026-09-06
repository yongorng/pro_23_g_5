class PostDataModel {
  final int? id;
  final String title;
  final String description;
  final String? author;
  final String? createdAt;
  final String? status;
  final String? imageUrl;

  PostDataModel({
    this.id,
    required this.title,
    required this.description,
    this.author,
    this.createdAt,
    this.status,
    this.imageUrl,
  });

  factory PostDataModel.fromJson(Map<String, dynamic> json) {
    return PostDataModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      author: json['author'],
      createdAt: json['createdAt'],
      status: json['status'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'createdAt': createdAt,
      'status': status,
      'imageUrl': imageUrl,
    };
  }
}