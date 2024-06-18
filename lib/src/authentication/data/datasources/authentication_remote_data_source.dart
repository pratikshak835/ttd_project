import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ttd_tutorial/core/errors/exceptions.dart';
import 'package:ttd_tutorial/core/utils/constants.dart';
import 'package:ttd_tutorial/core/utils/typedef.dart';
import 'package:ttd_tutorial/src/authentication/data/models/user_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });
  Future<List<UserModel>> getUser();
}

const kCreateUserEndpoint = '/test-api/users';
const kGetUserEndpoint = '/test-api/users';

class AuthenticationDataScrImpl implements AuthenticationRemoteDataSource {
  const AuthenticationDataScrImpl(this._client);

  final http.Client _client;
  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    //1.check to make sure that it returns the right data when status code 200 or the proper response code
    //2.check to make sure it "Throws a custom Exception" with the right message with the status code is bad
    try {
      final response =
          await _client.post(Uri.https(kBaseUrl, kCreateUserEndpoint),
              body: jsonEncode({
                'createdAt': createdAt,
                'name': name,
                'avatar': avatar,
              }),
              headers: {'Content-type': 'application/json'});
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUser() async {
    try {
      final response = await _client.get(
        Uri.https(kBaseUrl, kGetUserEndpoint),
      );
      if (response.statusCode != 200) {
        throw ApiException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }
}
