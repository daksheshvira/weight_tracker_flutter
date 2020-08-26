import 'package:equatable/equatable.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent extends Equatable {}

class InitialAuthEvent extends AuthEvent {
  User firebaseUser;
  InitialAuthEvent({this.firebaseUser});

  @override
  List<Object> get props => [firebaseUser];
}

class SigninEvent extends AuthEvent {
  SigninEvent({this.email, this.password});
  final String email;
  final String password;

  List<Object> get props => [email, password];
}

class SigninGoogleEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SignupEvent extends AuthEvent {
  SignupEvent({this.email, this.password, this.firstName, this.lastName});
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  List<Object> get props => [email, password, firstName, lastName];
}

class SignoutEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class ResetPasswordEvent extends AuthEvent {
  ResetPasswordEvent({this.email});
  String email;

  @override
  List<Object> get props => [email];
}

class ChangeEmailEvent extends AuthEvent {
  ChangeEmailEvent({this.newEmail, this.password});
  final String newEmail;
  final String password;

  @override
  List<Object> get props => [newEmail, password];
}

class ChangePasswordEvent extends AuthEvent {
  ChangePasswordEvent({this.password, this.newPassword});
  final String password;
  final String newPassword;

  @override
  List<Object> get props => [password, newPassword];
}

class ChangeDetailsEvent extends AuthEvent {
  ChangeDetailsEvent({this.firstName, this.lastName});
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => [firstName, lastName];
}

class UploadDisplayPictureEvent extends AuthEvent {
  UploadDisplayPictureEvent({this.localFile});

  final File localFile;

  @override
  List<Object> get props => [localFile];
}
