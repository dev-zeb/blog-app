import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blogs/data/models/blog_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);

  Future<String> uploadImage({
    required File image,
    required String blogId,
  });

  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final insertedBlog =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromJson(insertedBlog.first);
    } on PostgrestException catch (err, stk) {
      debugPrint("PostgrestException\nError: ${err.message}\nStack: $stk");
      throw ServerException(err.message);
    } catch (err, stk) {
      debugPrint("ServerException\nError: ${err.toString()}\nStack: $stk");
      throw ServerException(err.toString());
    }
  }

  @override
  Future<String> uploadImage({
    required File image,
    required String blogId,
  }) async {
    try {
      final uploadedImagePath = 'blog-image/blog-id/$blogId';
      await supabaseClient.storage.from('blog_images').upload(
            uploadedImagePath,
            image,
          );

      final imageUrl = supabaseClient.storage
          .from('blog_images')
          .getPublicUrl(uploadedImagePath);
      return imageUrl;
    } on StorageException catch (err, stk) {
      debugPrint("StorageException\nError: ${err.message}\nStack: $stk");
      throw ServerException(err.message);
    } catch (err, stk) {
      debugPrint("ServerException\nError: ${err.toString()}\nStack: $stk");
      throw ServerException(err.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs =
          await supabaseClient.from('blogs').select('*, profiles (name)');
      final List<BlogModel> blogModels = [];
      for (var i = 0; i < blogs.length; i++) {
        final blog = blogs[i];

        blogModels.add(
          BlogModel.fromJson(blog).copyWith(
            posterName: blog['profiles']['name'],
          ),
        );
      }
      return blogModels;
    } on PostgrestException catch (err, stk) {
      debugPrint("PostgrestException\nError: ${err.message}\nStack: $stk");
      throw ServerException(err.message);
    } catch (err, stk) {
      debugPrint("ServerException\nError: ${err.toString()}\nStack: $stk");
      throw ServerException(err.toString());
    }
  }
}
