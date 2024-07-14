import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: maxLines,
      validator: (value) {
        if(value!.isEmpty) {
          return '$hintText is missing';
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
