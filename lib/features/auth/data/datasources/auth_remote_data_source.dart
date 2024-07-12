import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const ServerException('User is null!');
      }
      final modifiedUserDataJson =
          _getSimplifiedJsonFromSupabase(response.user!);
      return UserModel.fromJson(modifiedUserDataJson);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw const ServerException('User is null!');
      }
      final modifiedUserDataJson =
          _getSimplifiedJsonFromSupabase(response.user!);
      return UserModel.fromJson(modifiedUserDataJson);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUserSession != null) {
        final queryJsonDataList = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);

        //Need to modify the JSON received to match with the desired format defined
        final modifiedUserDataJson = {
          'id': queryJsonDataList.first['id'],
          'email': currentUserSession!.user.email,
          'name': currentUserSession!.user.userMetadata?['name'],
        };
        return UserModel.fromJson(modifiedUserDataJson);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  _getSimplifiedJsonFromSupabase(User user) {
    return {
      'id': user.id,
      'email': user.userMetadata?['email'],
      'name': user.userMetadata?['name'],
    };
  }
}
