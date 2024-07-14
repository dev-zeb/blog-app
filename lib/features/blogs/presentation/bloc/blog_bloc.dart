import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blogs/domain/use_cases/upload_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';

part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;

  BlogBloc(this.uploadBlog) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUpload>(_blogUpload);
  }

  void _blogUpload(BlogUpload event, Emitter<BlogState> emit) async {
    final result = await uploadBlog(
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
      (r) => emit(BlogSuccess()),
    );
  }
}
