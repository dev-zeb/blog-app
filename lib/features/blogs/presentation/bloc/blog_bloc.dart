import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blogs/domain/entities/blog.dart';
import 'package:blog_app/features/blogs/domain/use_cases/fetch_all_blogs.dart';
import 'package:blog_app/features/blogs/domain/use_cases/upload_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';

part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final FetchAllBlogs _fetchAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required FetchAllBlogs fetchAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _fetchAllBlogs = fetchAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_onBlogUpload);
    on<BlogFetchAll>(_onBlogFetchAll);
  }

  void _onBlogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final result = await _uploadBlog(
      UploadBlogParams(
        image: event.image,
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        topics: event.topics,
      ),
    );

    result.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  void _onBlogFetchAll(BlogFetchAll event, Emitter<BlogState> emit) async {
    final result = await _fetchAllBlogs(NoParams());

    result.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogFetchAllSuccess(r)),
    );
  }
}
