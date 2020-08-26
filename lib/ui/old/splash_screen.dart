import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'file:///E:/AndroidStudioProjects/weight_tracker/lib/ui/old/login_screen.dart';
import 'package:weight_tracker/utils/Colors.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({
    Key key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    new Future.delayed(
      const Duration(seconds: 5),
      () {
        Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: LoginScreen(),
          ),
        );
      },
    );

//    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    var imageHeight = 250.0;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-3.8, -3.3),
          end: Alignment(0, 0),
          colors: [
            off_yellow,
            midnight,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(),
      ),
    );
  }
}
