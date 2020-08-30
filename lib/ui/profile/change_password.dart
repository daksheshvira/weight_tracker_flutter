import 'package:flutter/material.dart';
import 'package:weight_tracker/bloc/auth/auth_bloc.dart';
import 'package:weight_tracker/bloc/auth/auth_event.dart';
import 'package:weight_tracker/bloc/auth/auth_state.dart';
import 'package:weight_tracker/models/user_model.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';
import 'package:weight_tracker/ui/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/ui/widgets/primary_form_field.dart';

class ChangePassword extends StatefulWidget {
  LocalUser user;

  ChangePassword({this.user});

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  LocalUser user;

  _ChangePasswordState({this.user});

  TextEditingController oldPWController = new TextEditingController();
  TextEditingController newPWController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthBloc bloc = BlocProvider.of<AuthBloc>(context);
    return Scaffold(
      appBar: PrimaryAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 40.0),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Change password",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 40.0),
                PrimaryFormField(
                  obscureText: true,
                  controller: oldPWController,
                  decoration: InputDecoration(labelText: "Old password"),
                ),
                PrimaryFormField(
                  obscureText: true,
                  controller: newPWController,
                  decoration: InputDecoration(labelText: "New password"),
                ),
                PrimaryFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirm new password"),
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
                            bloc.add(
                              ChangePasswordEvent(
                                  password: oldPWController.text,
                                  newPassword: newPWController.text),
                            );
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
