import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends AuthenticationEvent {
  const CreateUserEvent({
    required this.createdAt,
    required this.name,
    required this.avtar,
  });

  final String createdAt;
  final String name;
  final String avtar;

  @override
  List<Object> get props => [createdAt, name, avtar];
}

class GetUserEvent extends AuthenticationEvent {
  const GetUserEvent();
}
