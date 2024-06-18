import 'package:dartz/dartz.dart';
import 'package:ttd_tutorial/core/errors/exceptions.dart';
import 'package:ttd_tutorial/core/errors/failure.dart';
import 'package:ttd_tutorial/core/utils/typedef.dart';
import 'package:ttd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:ttd_tutorial/src/authentication/domain/entity/user.dart';
import 'package:ttd_tutorial/src/authentication/domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  ResultVoid createUser(
      {required createdAt, required name, required avatar}) async {
    //Test-Driven-Development
    //call the remote data source
    // check if the methods returns the proper data
    //make sure that it return a proper data if there is no exception
    // //check if the remote data source throws an exception, we return a failure
    try {
      await _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUser() async {
    try {
      final result = await _remoteDataSource.getUser();
      return Right(result);
    } on ApiException catch (e) {
      return Left(ApiFailure.fromException(e));
    }
  }
}
