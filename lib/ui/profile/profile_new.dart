import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weight_tracker/bloc/auth/auth_bloc.dart';
import 'package:weight_tracker/bloc/auth/auth_event.dart';
import 'package:weight_tracker/bloc/auth/auth_state.dart';
import 'package:weight_tracker/models/user_model.dart';
import 'package:weight_tracker/ui/profile/account.dart';
import 'package:weight_tracker/ui/theme/colors.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';
import 'package:weight_tracker/ui/widgets/primary_circular_progress.dart';

class ProfileNewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
//        title: "Profile",
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: CurvedShape(),
    );
  }
}

class CurvedShape extends StatelessWidget {
  LocalUser user;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (ctx, state) {
        if (state is AuthLoadingState) {
          return Center(
            child: PrimaryCircularProgress(),
          );
        } else if (state is AuthorisedState) {
          user = state.user;
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                child: CustomPaint(
                  painter: _MyPainter(context: context),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildUserDetails(user, context, authBloc),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    SizedBox(height: 90),
                    ListTile(
                      title: Text("Account"),
                      subtitle: Text("Change your account details"),
                      leading: Icon(Icons.account_circle, color: Colors.grey),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: AccountSettings()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildUserDetails(
      LocalUser user, BuildContext context, AuthBloc authBloc) {
    return Column(
      children: <Widget>[
        Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user.displayUrl != ""
                    ? "${user.displayUrl}"
                    : "https://firebasestorage.googleapis.com/v0/b/weight-tracker-4d941.appspot.com/o/ppc.png?alt=media&token=490b02b6-df73-4e57-8da7-b142e492459e"),
              ),
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                      blurRadius: 8,
                      color: Colors.black.withOpacity(0.5))
                ],
                shape: BoxShape.circle,
                border: new Border.all(
                  color: Colors.white,
                  width: 4.0,
                ),
              ),
            ),
            Positioned(
              top: 80.0,
              left: 90.0,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(boxShadow: [
                  new BoxShadow(color: Colors.grey, blurRadius: 3),
                ], shape: BoxShape.circle),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.edit,
                    color: WTColors.darkGrey,
                  ),
                  onPressed: () {
                    _getLocalImage(authBloc);
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          "${user.firstName}",
          style: TextStyle(
              fontSize: 18.0,
              color: WTColors.darkGrey,
              fontWeight: FontWeight.bold),
        ),
        Text(
          "User since " + DateFormat.yMMM().format(user.createdAt.toDate()),
          style: TextStyle(color: WTColors.darkGrey.withOpacity(0.7)),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  _getLocalImage(AuthBloc authBloc) async {
    ImagePicker imagePicker = ImagePicker();
    File imageFile;

    final pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 80, maxWidth: 800);

    imageFile = File(pickedFile.path);

    if (imageFile != null) {
      authBloc.add(
        UploadDisplayPictureEvent(localFile: imageFile),
      );
    }
  }
}

class _MyPainter extends CustomPainter {
  BuildContext context;

  _MyPainter({this.context});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = Theme.of(context).primaryColor;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.lineTo(0, size.height / 4);
    path.quadraticBezierTo(
        size.width / 2, size.height / 1.8, size.width, size.height / 4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
