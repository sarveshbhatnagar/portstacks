part of 'authenticate_bloc.dart';

abstract class AuthenticateState extends Equatable {
  final String message;
  final bool isLoggedIn;
  final String userId;
  const AuthenticateState({this.message, this.isLoggedIn, this.userId});

  @override
  List<Object> get props => [message, isLoggedIn, userId];
}

class AuthenticateInitial extends AuthenticateState {
  AuthenticateInitial()
      : super(message: "Initial", isLoggedIn: false, userId: "myuser");
}

class AuthenticateLoggedIn extends AuthenticateState {
  final String userName;
  final String email;
  AuthenticateLoggedIn({
    String userId,
    this.userName,
    this.email,
  }) : super(message: "LoggedIn", isLoggedIn: true, userId: userId);
}

class AuthenticateError extends AuthenticateState {
  final String errorMessage;
  AuthenticateError({
    this.errorMessage,
  }) : super(message: "Some Error Occured", isLoggedIn: false);
}

class AuthenticateLoadingState extends AuthenticateState {
  AuthenticateLoadingState()
      : super(
          isLoggedIn: false,
          message: "Loading",
        );
}
