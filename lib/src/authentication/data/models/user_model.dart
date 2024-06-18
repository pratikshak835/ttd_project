import 'dart:convert';

import 'package:ttd_tutorial/core/utils/typedef.dart';
import 'package:ttd_tutorial/src/authentication/domain/entity/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.createdAt,
      required super.id,
      required super.name,
      required super.avatar});

  const UserModel.empty()
      : this(
            id: "1",
            createdAt: "_empty.createdAt",
            avatar: "_empty.avatar",
            name: "_empty.name");

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source) as DataMap);

  UserModel.fromMap(DataMap map)
      : this(
          createdAt: map["createdAt"] as String,
          name: map["name"] as String,
          id: map["id"] as String,
          avatar: map["avatar"] as String,
        );

  UserModel copyWith({
    String? createdAt,
    String? name,
    String? id,
    String? avatar,
  }) {
    return UserModel(
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar);
  }

  DataMap toMap() => {
        "createdAt": createdAt,
        "name": name,
        "avatar": avatar,
        "id": id,
      };

  String toJson() => jsonEncode(toMap());
}
