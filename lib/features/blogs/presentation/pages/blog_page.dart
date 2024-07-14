import 'package:blog_app/features/blogs/presentation/pages/add_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const BlogPage());

  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
      ),
      body: const Center(
        child: Text("List of Blogs"),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).push(
            AddBlogPage.route(),
          );
        },
        child: const Icon(CupertinoIcons.add_circled),
      ),
    );
  }
}
