import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DottedBorderImageUploaderWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const DottedBorderImageUploaderWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: DottedBorder(
        borderType: BorderType.RRect,
        color: AppPallete.borderColor,
        dashPattern: const [10, 4],
        radius: const Radius.circular(12),
        strokeCap: StrokeCap.round,
        child: const SizedBox(
          height: 150,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_open_rounded, size: 40),
              SizedBox(height: 10),
              Text(
                'Select your image',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
