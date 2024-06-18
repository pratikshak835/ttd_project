import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ttd_tutorial/core/errors/exceptions.dart';
import 'package:ttd_tutorial/core/errors/failure.dart';
import 'package:ttd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:ttd_tutorial/src/authentication/data/repository/authentication_repository_implementation.dart';
import 'package:ttd_tutorial/src/authentication/domain/entity/user.dart';

class MockAuthRemoteDataSrc extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;

  setUp(() {
    remoteDataSource = MockAuthRemoteDataSrc();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tException =
      ApiException(message: "Unknown error occurred", statusCode: 500);

  group("createUser", () {
    const createdAt = 'whatever.createdAt';
    const name = 'whatever.name';
    const avatar = 'whatever.avtar';
    test(
        "should call the [RemoteDataSource.CreateUser] and complete "
        "successfully when the call to the remote source successful", () async {
      when(
        () => remoteDataSource.createUser(
            createdAt: any(named: "createdAt"),
            name: any(named: "name"),
            avatar: any(named: "avatar")),
      ).thenAnswer((_) async => Future.value());

      //act
      final result = await repoImpl.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      //assert
      expect(result, equals(const Right(null)));
      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        "Should return a [ApiFailure] when the call to the remote  source is unsuccessful",
        () async {
      //arrange
      when(() => remoteDataSource.createUser(
          createdAt: any(named: "createdAt"),
          name: any(named: "name"),
          avatar: any(
            named: "avatar",
          ))).thenThrow(tException);
      //act
      final result = await repoImpl.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );

      expect(
          result,
          equals(Left(
            ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode,
            ),
          )));

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group("getUser", () {
    test(
        "should call the [RemoteDataSource.GetUser] and return [list<User>]"
        " when the call to the remote source successful", () async {
      when(() => remoteDataSource.getUser()).thenAnswer((_) async => []);
      final result = await repoImpl.getUser();

      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUser()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
  test(
      "Should return a [ApiFailure] when the call to the remote  source is unsuccessful",
      () async {
    when(() => remoteDataSource.getUser()).thenThrow(tException);

    final result = await repoImpl.getUser();

    expect(result, equals(Left(ApiFailure.fromException(tException))));
    verify(() => remoteDataSource.getUser()).called(1);
    verifyNoMoreInteractions(remoteDataSource);
  });
}
