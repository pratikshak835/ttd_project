import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ttd_tutorial/core/errors/failure.dart';
import 'package:ttd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:ttd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:ttd_tutorial/src/authentication/presentstion/bloc/authentication_state.dart';
import 'package:ttd_tutorial/src/authentication/presentstion/cubit/authentication_cubit.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUsers extends Mock implements CreateUsers {}

void main() {
  late GetUsers getUsers;
  late CreateUsers createUsers;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tApiFailure = ApiFailure(message: "message", statusCode: 400);
  setUp(() {
    getUsers = MockGetUsers();
    createUsers = MockCreateUsers();
    cubit = AuthenticationCubit(createUser: createUsers, getUser: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test("initial state should be [AuthenticationInitial]", () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group("createUser", () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      "should emit[CreateUser, UserCrested] when successful",
      build: () {
        when(() => createUsers(any()))
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
          createdAt: tCreateUserParams.createdAt,
          name: tCreateUserParams.name,
          avatar: tCreateUserParams.avatar),
      expect: () => const [CreatingUser(), UserCreated()],
      verify: (_) {
        verify(() => createUsers(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUsers);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      "Should emit [CreateUser , AuthenticationError] when unsuccessful",
      build: () {
        when(() => createUsers(any()))
            .thenAnswer((_) async => const Left(tApiFailure));
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => [
        const CreatingUser(),
        AuthenticationError(tApiFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => createUsers(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUsers);
      },
    );
  });

  group("getUser", () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      "Should emit the[GettingUser, UserLoaded]when successful",
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getUser(),
      expect: () => const [
        GettingUser(),
        UserLoaded([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      "Should emit [GettingUsers, AuthenticationError] when unsuccessful",
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tApiFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUser(),
      expect: () =>
          [const GettingUser(), AuthenticationError(tApiFailure.errorMessage)],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
