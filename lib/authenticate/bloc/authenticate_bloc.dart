import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:portstacks1/authenticate/services/authenticate_services.dart';

part 'authenticate_event.dart';
part 'authenticate_state.dart';

class AuthenticateBloc extends Bloc<AuthenticateEvent, AuthenticateState> {
  AuthService authService = AuthService();
  AuthenticateBloc() : super(AuthenticateInitial());

  @override
  Stream<AuthenticateState> mapEventToState(
    AuthenticateEvent event,
  ) async* {
    if (event is AuthenticateUserLogin) {
      yield AuthenticateLoadingState();
      try {
        UserCredential cred =
            await authService.loginUser(event.email, event.password);

        yield AuthenticateLoggedIn(
          userId: cred.user.uid,
          userName: cred.user.email,
        );
      } catch (error) {
        yield AuthenticateError(errorMessage: error.toString());
      }
    } else if (event is AuthenticateUserSignUp) {
      yield AuthenticateLoadingState();
      try {
        UserCredential cred =
            await authService.createUser(event.email, event.password);
        yield AuthenticateLoggedIn(
          email: cred.user.email,
          userName: cred.user.email,
          userId: cred.user.uid,
        );
      } catch (error) {
        yield AuthenticateError(
          errorMessage: error.toString(),
        );
      }
    } else if (event is AuthenticateUserLogout) {
      yield AuthenticateLoadingState();
      try {
        authService.logoutUser();

        yield AuthenticateInitial();
      } catch (e) {
        AuthenticateError(errorMessage: "Unable to logout");
      }
    } else {
      yield AuthenticateError(
        errorMessage: "Event Does not exist",
      );
    }
  }
}
