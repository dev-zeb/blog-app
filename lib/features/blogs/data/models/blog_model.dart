import 'package:blog_app/features/blogs/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      posterId: json['poster_id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
      topics: List<String>.from(json['topics'] ?? []),
      updatedAt: json['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(json['updated_at']),
    );
  }
}
