import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/bloc/auth/auth_bloc.dart';
import 'package:weight_tracker/bloc/auth/auth_event.dart';
import 'package:weight_tracker/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/ui/theme/colors.dart';
import 'package:weight_tracker/ui/validators/email_validator.dart';
import 'package:weight_tracker/ui/widgets/primary_circular_progress.dart';
import 'package:weight_tracker/ui/widgets/primary_form_field.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();

  String message;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (prev, next) {
        if (next is AuthLoadingState) {
          setState(() {
            isLoading = true;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 40),
                  Container(
                    width: 120,
                    child: Image(
                      image: AssetImage('lib/assets/weighttracker_logo.png'),
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    child: Text(
                      "Reset password",
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: 250,
                    child: Text(
                      "An email with a password reset link will be sent to your email",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30),
                  PrimaryFormField(
                    key: Key('email-field'),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email address",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    validator: EmailFieldValidator.validate,
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (prev, next) {
                        next == UnauthorisedState;
                      },
                      builder: (ctx, state) {
                        if (state is UnauthorisedState) {
                          return Text(
                            state.message ?? "",
                            key: Key('message-text'),
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      key: Key('signin-button'),
                      padding: EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: isLoading
                          ? PrimaryCircularProgress()
                          : Text(
                              "Send reset email",
                              style: TextStyle(color: WTColors.darkGrey),
                            ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          bloc.add(
                            ResetPasswordEvent(email: emailController.text),
                          );
                        }
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _navigateToSignup(context);
                    },
                    child: Text("Back to sign in"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _navigateToSignup(BuildContext context) {
    Navigator.of(context).pop();
  }
}
