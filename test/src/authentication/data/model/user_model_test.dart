//what is our dependency?
//how do we fake the dependency?
//ans: mocktail
//how do we control what that fake version does?
//ans: using mocktail api

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ttd_tutorial/core/utils/typedef.dart';
import 'package:ttd_tutorial/src/authentication/data/models/user_model.dart';
import 'package:ttd_tutorial/src/authentication/domain/entity/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();

  test("should be a sub class of [user] entity", () {
    //arrange

    //act
    // assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;
  group("fromMap", () {
    test("should return a [UserModel] with the right data ", () {
      //Act
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group("fromJson", () {
    test("should return a [UserModel] with the right data ", () {
      //Act
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group("toMap", () {
    test("Should return a [Map] with right data", () {
      //Act
      final result = tModel.toMap();
      //Assert
      expect(result, equals(tMap));
    });
  });

  group("toJson", () {
    test("Should return a [Json] with right data", () {
      //Act
      final result = tModel.toJson();
      //Assert

      final tJson = jsonEncode({
        "createdAt": "_empty.createdAt",
        "name": "_empty.name",
        "avatar": "_empty.avtar",
        "id": "1"
      });
      expect(result, equals(tJson));
    });
  });

  group("copyWith", () {
    test("should return a [User Model] with different data", () {
      //Arrange
      //Act
      final result = tModel.copyWith(name: "paul");

      expect(result.name, equals("paul"));
    });
  });
}
