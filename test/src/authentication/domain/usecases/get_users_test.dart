import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ttd_tutorial/src/authentication/domain/entity/user.dart';
import 'package:ttd_tutorial/src/authentication/domain/repository/authentication_repository.dart';
import 'package:ttd_tutorial/src/authentication/domain/usecases/get_users.dart';

import 'Authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers useCase;

  setUp(() {
    repository = MockAuthRepo();
    useCase = GetUsers(repository);
  });

  const tResponse = [User.empty()];

  test("Should call [AuthRepo.getUsers] and return [List<Users>]", () async {
    //Arrange
    when(() => repository.getUser()).thenAnswer(
      (_) async => const Right(tResponse),
    );
    //act
    final result = await useCase();

    expect(result, equals(const Right<dynamic, List<User>>(tResponse)));
    verify(() => repository.getUser()).called(1);
    verifyNoMoreInteractions(repository);
    //asset
  });
}
