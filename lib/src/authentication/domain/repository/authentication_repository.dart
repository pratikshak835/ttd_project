import 'package:ttd_tutorial/core/utils/typedef.dart';

import '../entity/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  ResultVoid createUser({required createdAt, required name, required avatar});

  ResultFuture<List<User>> getUser();
}
