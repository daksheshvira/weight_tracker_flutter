import 'package:flutter/material.dart';

class PrimaryCircularProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white70),
        strokeWidth: 6,
      ),
    );
  }
}
