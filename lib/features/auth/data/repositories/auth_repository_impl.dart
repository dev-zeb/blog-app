import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
      Future<User> Function() functionToExecute) async {
    try {
      final user = await functionToExecute();
      return right(user);
    } on sb.AuthException catch (err, stk) {
      debugPrint("AuthException\nError: ${err.message}\nStack: $stk");
      return left(Failure(err.message));
    } on ServerException catch (err, stk) {
      debugPrint("ServerException\nError: ${err.message}\nStack: $stk");
      return left(Failure(err.message));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final currentUser = await remoteDataSource.getCurrentUser();
      if(currentUser == null) {
        return left(Failure('User is not logged in.'));
      }
      return right(currentUser);
    } on ServerException catch (err, stk) {
      debugPrint("ServerException\nError: ${err.message}\nStack: $stk");
      return left(Failure(err.message));
    }
  }
}
