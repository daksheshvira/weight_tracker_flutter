import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:weight_tracker/bloc/auth/auth_event.dart';
import 'package:weight_tracker/bloc/auth/auth_state.dart';
import 'package:weight_tracker/services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthService authService;

  AuthBloc({this.authService}) : super(null) {
    authSub =
        authService.firebaseAuth.authStateChanges().listen((User firebaseUser) {
      add(InitialAuthEvent(firebaseUser: firebaseUser));
      print(firebaseUser);
    });
  }

  StreamSubscription<User> authSub;

  @override
  AuthState get initialState => AuthInitialState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is InitialAuthEvent) {
      yield AuthLoadingState();
      if (event.firebaseUser != null) {
        var user = await authService.getCurrentUserObject();
        yield AuthorisedState(user: user);
      } else {
        yield UnauthorisedState();
      }
    }

    if (event is SignupEvent) {
      yield AuthLoadingState();
      try {
        var user = await authService.signUp(
          event.email.trim(),
          event.password.trim(),
          event.firstName.trim(),
          event.lastName.trim(),
        );
        yield AuthorisedState(user: user);
      } catch (e) {
        yield UnauthorisedState(message: "That didn't work, please try again");
      }
    } else if (event is SigninEvent) {
      print("SigninEvent");
      yield AuthLoadingState();
      try {
        var user = await authService.signIn(
          event.email.trim(),
          event.password.trim(),
        );
        yield AuthorisedState(user: user);
      } catch (e) {

        print(e);
        yield UnauthorisedState(message: "Check your username and password");
      }
    } else if (event is SignoutEvent) {
//      User user = new User();
//      yield AuthorisedState(user: user);
      await authService.signOut();
      yield UnauthorisedState(message: "");
    } else if (event is ChangeEmailEvent) {
      yield AuthLoadingState();
      await authService.changeEmail(
        event.newEmail.trim(),
        event.password.trim(),
      );
      var user = await authService.getCurrentUserObject();
      yield AuthorisedState(user: user);
    } else if (event is ChangePasswordEvent) {
      yield AuthLoadingState();
      await authService.changePassword(
        event.password.trim(),
        event.newPassword.trim(),
      );
      var user = await authService.getCurrentUserObject();
      yield AuthorisedState(user: user);
    } else if (event is ChangeDetailsEvent) {
      yield AuthLoadingState();
      await authService.changeUserDetails(event.firstName, event.lastName);
      var user = await authService.getCurrentUserObject();
      yield ChangedSuccessState();
      yield AuthorisedState(user: user);
    } else if (event is ResetPasswordEvent) {
      yield AuthLoadingState();
      await authService.resetPassword(event.email);
      yield UnauthorisedState(message: "Email sent");
    } else if (event is UploadDisplayPictureEvent) {
      yield AuthLoadingState();
      await authService.uploadDisplayPicture(event.localFile);
      var user = await authService.getCurrentUserObject();
      yield AuthorisedState(user: user);
    }
  }

  @override
  void dispose() {
    authSub.cancel();
  }
}
