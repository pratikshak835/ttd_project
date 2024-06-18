import 'package:equatable/equatable.dart';
import 'package:ttd_tutorial/core/usecase/usecase.dart';
import 'package:ttd_tutorial/core/utils/typedef.dart';
import 'package:ttd_tutorial/src/authentication/domain/repository/authentication_repository.dart';

class CreateUsers extends UseCaseWithParams<void, CreateUserParams> {
  const CreateUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultVoid call(CreateUserParams params) async => _repository.createUser(
      createdAt: params.createdAt, name: params.name, avatar: params.avatar);
}

class CreateUserParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUserParams.empty()
      : this(
            createdAt: "_empty.createdAt",
            name: "_empty.name",
            avatar: "_empty.avatar");

  const CreateUserParams(
      {required this.createdAt, required this.name, required this.avatar});

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
