import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  const AuthRepositoryImpl(this.remoteDataSource, this.connectionChecker);

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
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noInternetConnectionMessage));
      }
      final user = await functionToExecute();
      return right(user);
    } on ServerException catch (err) {
      return left(Failure(err.message));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failure(Constants.userNotLoggedInMessage));
        }
        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: session
                .user.identities?.first.identityData![Constants.nameColumn],
          ),
        );
      }
      final currentUser = await remoteDataSource.getCurrentUser();
      if (currentUser == null) {
        return left(Failure(Constants.userNotLoggedInMessage));
      }
      return right(currentUser);
    } on ServerException catch (err) {
      return left(Failure(err.message));
    }
  }
}
