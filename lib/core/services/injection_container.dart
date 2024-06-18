import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:ttd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:ttd_tutorial/src/authentication/data/repository/authentication_repository_implementation.dart';
import 'package:ttd_tutorial/src/authentication/domain/repository/authentication_repository.dart';
import 'package:ttd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:ttd_tutorial/src/authentication/presentstion/cubit/authentication_cubit.dart';

import '../../src/authentication/domain/usecases/create_user.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //App Logic

  sl
    ..registerFactory(() => AuthenticationCubit(
          createUser: sl(),
          getUser: sl(),
        ))
    //use cases
    ..registerLazySingleton(() => CreateUsers(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    //repository
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))
    //Data source
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationDataScrImpl(sl()))
    //External dependency
    ..registerLazySingleton(http.Client.new);
}
