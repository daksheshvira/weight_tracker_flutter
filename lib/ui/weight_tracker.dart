import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weight_tracker/bloc/auth/auth_bloc.dart';
import 'package:weight_tracker/bloc/auth/auth_state.dart';
import 'package:weight_tracker/ui/auth/intro.dart';
import 'package:weight_tracker/ui/auth/loading.dart';
import 'package:weight_tracker/ui/auth/signin.dart';
import 'package:weight_tracker/ui/home/home.dart';

class WeightTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (prev, next) {
        return prev != next && next is! AuthLoadingState;
      },
      builder: (context, state) {
        print("AuthState : " + state.toString());
        if (state is AuthInitialState) {
          return AuthLoading();
        } else if (state is UnauthorisedState) {
          return IntroSplash();
        } else if (state is AuthFailState) {
          return SigninPage();
        } else if (state is AuthorisedState) {
          return HomePage();
        } else {
          return Container();
        }
      },
    );
  }

  _navigateHome(BuildContext context) {
    Navigator.pushReplacement(context,
        PageTransition(type: PageTransitionType.fade, child: HomePage()));
  }
}
