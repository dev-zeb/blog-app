import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_session.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blogs/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blogs/data/repositories/blog_repository_impl.dart';
import 'package:blog_app/features/blogs/domain/repositories/blog_repository.dart';
import 'package:blog_app/features/blogs/domain/use_cases/fetch_all_blogs.dart';
import 'package:blog_app/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/blogs/domain/use_cases/upload_blog.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  await _initSupabaseClient();
  _initAuth();
  _initBlogs();

  // Core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

Future<void> _initSupabaseClient() async {
  await dotenv.load(fileName: ".env");
  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  // Repositories
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

  // Use Cases
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserSession(
      serviceLocator(),
    ),
  );

  // Blocs
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      userSession: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}

void _initBlogs() {
  // Data Source
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImpl(
      serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepositoryImpl(
      serviceLocator(),
    ),
  );

  // Use Case
  serviceLocator.registerFactory(
    () => UploadBlog(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => FetchAllBlogs(
      serviceLocator(),
    ),
  );

  // Bloc
  serviceLocator.registerLazySingleton(
    () => BlogBloc(
      uploadBlog: serviceLocator(),
      fetchAllBlogs: serviceLocator(),
    ),
  );
}
