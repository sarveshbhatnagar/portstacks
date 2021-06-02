part of 'authenticate_bloc.dart';

abstract class AuthenticateEvent extends Equatable {
  final String email;
  final String password;
  const AuthenticateEvent({this.email, this.password});

  @override
  List<Object> get props => [];
}

class AuthenticateUserLogin extends AuthenticateEvent {
  AuthenticateUserLogin({String email, String password})
      : super(email: email, password: password);
}

class AuthenticateUserSignUp extends AuthenticateEvent {
  AuthenticateUserSignUp({
    String email,
    String password,
  }) : super(email: email, password: password);
}

class AuthenticateUserLogout extends AuthenticateEvent {
  AuthenticateUserLogout();
}
