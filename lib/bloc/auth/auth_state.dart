import 'package:equatable/equatable.dart';
import 'package:weight_tracker/models/user_model.dart';

abstract class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthorisedState extends AuthState {
  LocalUser user;
  AuthorisedState({this.user});

  @override
  List<Object> get props => [];
}

class UnauthorisedState extends AuthState {
  String message;
  UnauthorisedState({this.message});

  @override
  List<Object> get props => [message];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthFailState extends AuthState {
  String message;
  AuthFailState({this.message});

  @override
  List<Object> get props => [message];
}

class ChangedSuccessState extends AuthState {
  @override
  List<Object> get props => [];
}
