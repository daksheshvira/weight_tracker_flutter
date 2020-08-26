import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weight_tracker/ui/weight/weight.dart';
import 'package:weight_tracker/ui/widgets/primary_dialog.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () {
        _showExitDialog(context);
      },
      child: Scaffold(
        body: WeightPage(),
      ),
    );
  }

  _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PrimaryDialog(
          content: Text(
            "Exit app?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
