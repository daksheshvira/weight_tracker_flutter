import 'package:flutter/material.dart';
import 'package:weight_tracker/bloc/auth/auth_bloc.dart';
import 'package:weight_tracker/bloc/auth/auth_event.dart';
import 'package:weight_tracker/bloc/auth/auth_state.dart';
import 'package:weight_tracker/models/user_model.dart';
import 'package:weight_tracker/ui/validators/email_validator.dart';
import 'package:weight_tracker/ui/validators/password_validator.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';
import 'package:weight_tracker/ui/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/ui/widgets/primary_form_field.dart';

class ChangeEmail extends StatefulWidget {
  LocalUser user;

  ChangeEmail({this.user});

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  LocalUser user;
  bool passwordsMatch;

  _ChangeEmailState({this.user});

  final _formKey = GlobalKey<FormState>();
  TextEditingController emController = new TextEditingController();
  TextEditingController confirmController = new TextEditingController();
  TextEditingController pwController = new TextEditingController();

  @override
  void initState() {
    passwordsMatch = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: PrimaryAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 40.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Change email",
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      passwordsMatch ? "" : "Passwords must match",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  PrimaryFormField(
                    controller: emController,
                    decoration: InputDecoration(labelText: "New email"),
                    validator: EmailFieldValidator.validate,
                  ),
                  PrimaryFormField(
                    controller: confirmController,
                    decoration: InputDecoration(labelText: "Confirm email"),
                    validator: EmailFieldValidator.validate,
                  ),
                  PrimaryFormField(
                    controller: pwController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Current password"),
                    validator: PasswordFieldValidator.validate,
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (ctx, state) {
                        if (state is AuthLoadingState) {
                          return PrimaryButton(
                            loading: true,
                            onPressed: () {},
                          );
                        } else {
                          return PrimaryButton(
                            label: "Submit",
                            onPressed: () {
                              if (emController.text == confirmController.text &&
                                  emController.text != "") {
                                passwordsMatch = true;
                                if (_formKey.currentState.validate()) {
                                  bloc.add(
                                    ChangeEmailEvent(
                                        newEmail: emController.text,
                                        password: pwController.text),
                                  );
                                }
                              } else {
                                setState(() {
                                  passwordsMatch = false;
                                });
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                  BlocListener<AuthBloc, AuthState>(
                    listenWhen: (prev, next) {
                      next == ChangedSuccessState;
                    },
                    child: Container(),
                    listener: (prev, next) {
                      if (next is ChangedSuccessState) {
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
