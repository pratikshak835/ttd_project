import 'package:ttd_tutorial/core/usecase/usecase.dart';
import 'package:ttd_tutorial/core/utils/typedef.dart';
import 'package:ttd_tutorial/src/authentication/domain/repository/authentication_repository.dart';

import '../entity/user.dart';

class GetUsers extends UseCaseWithoutParams<List<User>> {
  const GetUsers(this._repository);
  final AuthenticationRepository _repository;
  @override
  ResultFuture<List<User>> call() async => _repository.getUser();
}
