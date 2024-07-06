import 'package:blog_app/features/auth/domain/entities/user.dart';
import 'package:flutter/cupertino.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    debugPrint('UserModel fromJson | map: $map');
    return UserModel(
      id: map['id'],
      email: map['user_metadata']['email'],
      name: map['user_metadata']['name'],
    );
  }
}
