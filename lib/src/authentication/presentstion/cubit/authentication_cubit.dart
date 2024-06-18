import 'package:bloc/bloc.dart';
import 'package:ttd_tutorial/src/authentication/domain/usecases/create_user.dart';
import 'package:ttd_tutorial/src/authentication/domain/usecases/get_users.dart';
import 'package:ttd_tutorial/src/authentication/presentstion/bloc/authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required CreateUsers createUser,
    required GetUsers getUser,
  })  : _createUser = createUser,
        _getUsers = getUser,
        super(const AuthenticationInitial());

  final CreateUsers _createUser;
  final GetUsers _getUsers;

  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    emit(const CreatingUser());

    final result = await _createUser(CreateUserParams(
      createdAt: createdAt,
      name: name,
      avatar: avatar,
    ));

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (_) => emit(const UserCreated()),
    );
  }

  Future<void> getUser() async {
    emit(const GettingUser());
    final result = await _getUsers();

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (users) => emit(UserLoaded(users)),
    );
  }
}
