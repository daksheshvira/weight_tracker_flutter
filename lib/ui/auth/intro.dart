import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weight_tracker/ui/auth/signin.dart';
import 'package:weight_tracker/ui/auth/signup.dart';
import 'package:weight_tracker/ui/theme/colors.dart';
import 'package:weight_tracker/ui/widgets/primary_button.dart';
import 'package:weight_tracker/ui/widgets/primary_dialog.dart';

class IntroSplash extends StatefulWidget {
  @override
  _IntroSplashState createState() => _IntroSplashState();
}

class _IntroSplashState extends State<IntroSplash> {
  double _width = 0;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _width = 200;
    _visible = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _showExitDialog(context);
      },
      child: Scaffold(
        body: Stack(
//        fit: StackFit.expand,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  AnimatedOpacity(
                    opacity: _visible ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 2500),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 1800),
                      curve: Curves.decelerate,
                      width: _width,
                      child: Image(
                        image: AssetImage('lib/assets/weighttracker_logo.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CurvedShape(),
          ],
        ),
      ),
    );
  }

  _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PrimaryDialog(
          content: Text("Exit app?"),
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
                await SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
//
              },
              child: Text(
                "Exit",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CurvedShape extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          duration: Duration(milliseconds: 500),
                          child: SignupPage(),
                        ),
                      );
                    },
                    label: "Sign up",
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    color: WTColors.darkGrey,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      duration: Duration(milliseconds: 500),
                      child: SigninPage(),
                    ),
                  );
                },
                child: Text(
                  "Sign in",
                  style: TextStyle(color: WTColors.darkGrey),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ],
    );
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

    path.moveTo(0, size.height * 0.72);
    path.quadraticBezierTo(
        size.width / 1.8, size.height / 1.8, size.width, size.height * 0.72);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
