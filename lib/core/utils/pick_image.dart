import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(ImageSource source) async {
  try {
    final xFile = await ImagePicker().pickImage(source: source);
    return xFile != null ? File(xFile.path) : null;
  } catch (e) {
    debugPrint('Error picking image: $e');
    return null;
  }
}
