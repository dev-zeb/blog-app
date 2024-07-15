import 'dart:io';

import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/custom_loader.dart';
import 'package:blog_app/core/common/widgets/custom_text_field.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blogs/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blogs/presentation/widgets/dotted_border_image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddBlogPage(),
      );

  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final blogTitleController = TextEditingController();
  final blogContentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final List<String> selectedTopics = [];
  File? selectedImage;

  selectImage() async {
    File? pickedImage = await pickImage(ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    blogTitleController.dispose();
    blogContentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate() &&
                  selectedTopics.isNotEmpty &&
                  selectedImage != null) {
                final posterId =
                    (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        .user
                        .id;
                context.read<BlogBloc>().add(
                      BlogUpload(
                        image: selectedImage!,
                        posterId: posterId,
                        title: blogTitleController.text.trim(),
                        content: blogContentController.text.trim(),
                        topics: selectedTopics,
                      ),
                    );
              }
            },
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    selectedImage != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Image.file(
                                  selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : DottedBorderImageUploaderWidget(
                            onPressed: selectImage,
                          ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: Constants.topics.map((topic) {
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: GestureDetector(
                              onTap: () {
                                if (selectedTopics.contains(topic)) {
                                  selectedTopics.remove(topic);
                                } else {
                                  selectedTopics.add(topic);
                                }
                                setState(() {});
                              },
                              child: Chip(
                                color: selectedTopics.contains(topic)
                                    ? const MaterialStatePropertyAll(
                                        AppPallete.gradient1)
                                    : null,
                                label: Text(topic),
                                side: BorderSide(
                                  color: selectedTopics.contains(topic)
                                      ? AppPallete.transparentColor
                                      : AppPallete.borderColor,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: blogTitleController,
                      hintText: 'Blog Title',
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: blogContentController,
                      hintText: 'Blog Content',
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
