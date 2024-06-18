import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:ttd_tutorial/core/errors/exceptions.dart';
import 'package:ttd_tutorial/core/utils/constants.dart';
import 'package:ttd_tutorial/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:ttd_tutorial/src/authentication/data/models/user_model.dart';

class MockClients extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClients();
    remoteDataSource = AuthenticationDataScrImpl(client);
    registerFallbackValue(Uri());
  });

  group("CreateUser", () {
    test("Should complete successfully when statusCode is 200 or 201",
        () async {
      when(() => client.post(any(), body: any(named: "body"))).thenAnswer(
        (_) async => http.Response('User Created successfully', 201),
      );

      final methodCall = remoteDataSource.createUser;

      expect(
          methodCall(
            createdAt: "createdAt",
            name: "name",
            avatar: "avatar",
          ),
          completes);
      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            'createdAt': "createdAt",
            'name': "name",
            'avtar': "avtar",
          }),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });

    test("Should throw [ApiException] when the status code is not 200 or 201",
        () async {
      when(() => client.post(any(), body: any(named: "body"))).thenAnswer(
        (_) async => http.Response('Invalid email address', 400),
      );

      final methodCall = remoteDataSource.createUser;

      expect(
        methodCall(
          createdAt: "createdAt",
          name: "name",
          avatar: "avatar",
        ),
        throwsA(
          const ApiException(
            message: "Invalid email address",
            statusCode: 400,
          ),
        ),
      );

      verify(
        () => client.post(
          Uri.https(kBaseUrl, kCreateUserEndpoint),
          body: jsonEncode({
            'createdAt': "createdAt",
            'name': "name",
            'avtar': "avtar",
          }),
        ),
      ).called(1);

      verifyNoMoreInteractions(client);
    });
  });

  group("GetUser", () {
    const tUsers = [UserModel.empty()];
    test("should return a[List<UserModel>] when the status code is 200",
        () async {
      when(() => client.get(any())).thenAnswer(
          (_) async => http.Response(jsonEncode([tUsers.first.toMap()]), 200));

      final result = await remoteDataSource.getUser();

      expect(result, equals(tUsers));

      verify(() => client.get(Uri.https(kBaseUrl, kGetUserEndpoint))).called(1);
      verifyNoMoreInteractions(client);
    });

    test("should throw [ApiException] when status code is not 200 or 201",
        () async {
      const tMessage = "server down, server down";
      when(() => client.get(any()))
          .thenAnswer((_) async => http.Response(tMessage, 500));

      final methodCall = remoteDataSource.getUser;

      expect(() => methodCall,
          throwsA(const ApiException(message: tMessage, statusCode: 500)));
      verify(() => client.get(Uri.https(kBaseUrl, kGetUserEndpoint))).called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
