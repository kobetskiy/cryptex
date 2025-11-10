part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;

  SignUp({required this.email, required this.password, required this.name});

  @override
  List<Object?> get props => [email, password, name];
}

class LogIn extends AuthEvent {
  final String email;
  final String password;

  LogIn({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogOut extends AuthEvent {
  @override
  List<Object?> get props => [];
}
