import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weight_tracker/bloc/auth/auth_bloc.dart';
import 'package:weight_tracker/bloc/auth/auth_event.dart';
import 'package:weight_tracker/bloc/auth/auth_state.dart';
import 'package:weight_tracker/models/user_model.dart';
import 'package:weight_tracker/ui/profile/change_details.dart';
import 'package:weight_tracker/ui/profile/change_email.dart';
import 'package:weight_tracker/ui/profile/change_password.dart';
import 'package:weight_tracker/ui/weight_tracker.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';
import 'package:weight_tracker/ui/widgets/primary_dialog.dart';

class AccountSettings extends StatelessWidget {
  LocalUser user;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Account",
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (ctx, state) {
          if (state is AuthorisedState) {
            user = state.user;

            return Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ChangeEmail(user: user);
                        },
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.alternate_email,
                    color: Colors.grey,
                  ),
                  title: Text("Change email"),
                  subtitle: Text("${user.email}"),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ),
                ListTile(
                  onTap: () {
                    print(user.firstName);
                    _navigateToDetails(context, user);
                  },
                  leading: Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                  title: Text("Personal details"),
                  subtitle: Text("${user.firstName} ${user.lastName}"),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return ChangePassword(user: user);
                        },
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  title: Text("Change password"),
                  subtitle: Text("Current password required"),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.exit_to_app,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    _showSignoutDialog(context, authBloc);
                  },
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _showSignoutDialog(BuildContext context, AuthBloc authBloc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PrimaryDialog(
          content: Text("Are you sure you want to logout?"),
          actions: [
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              onPressed: () async {
                authBloc.add(SignoutEvent());
                Navigator.pop(context);
                Navigator.pop(context);

//                await Navigator.pushReplacement(
//                    context,
//                    PageTransition(
//                        type: PageTransitionType.fade, child: WeightTracker()));
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  _navigateToDetails(BuildContext context, LocalUser user) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return ChangeName(user: user);
      }),
    );
  }
}
