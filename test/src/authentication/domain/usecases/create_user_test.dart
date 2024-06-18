import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ttd_tutorial/src/authentication/domain/repository/authentication_repository.dart';
import 'package:ttd_tutorial/src/authentication/domain/usecases/create_user.dart';

import 'Authentication_repository.mock.dart';

void main() {
  late CreateUsers useCase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepo();
    useCase = CreateUsers(repository);
  });

  const params = CreateUserParams.empty();
  test(
    "Should call the [AuthRepo.createUser]",
    () async {
      //Arrange
      when(
        () => repository.createUser(
          createdAt: any(named: "createdAt"),
          name: any(named: "name"),
          avatar: any(named: "avatar"),
        ),
      ).thenAnswer((_) async => const Right(null));
      //Act
      final result = await useCase(params);
      //Assert

      expect(result, equals(const Right<dynamic, void>(null)));
      verify(() => repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar)).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
