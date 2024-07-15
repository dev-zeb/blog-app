import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blogs/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blogs/data/models/blog_model.dart';
import 'package:blog_app/features/blogs/domain/entities/blog.dart';
import 'package:blog_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final ConnectionChecker connectionChecker;

  BlogRepositoryImpl(this.blogRemoteDataSource, this.connectionChecker);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection.'));
      }
      final blogId = const Uuid().v1();

      final uploadedImageUrl = await blogRemoteDataSource.uploadImage(
        image: image,
        blogId: blogId,
      );

      BlogModel blogModel = BlogModel(
        id: blogId,
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: uploadedImageUrl,
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        // TODO: Show blogs from the local storage
        return left(Failure('No internet connection.'));
      }
      final blogs = await blogRemoteDataSource.getAllBlogs();

      return right(blogs);
    } on ServerException catch(e) {
      return left(Failure(e.message));
    }
  }
}
