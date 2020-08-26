import 'package:flutter/material.dart';

class PrimaryDialog extends StatelessWidget {
  Widget content;
  List<Widget> actions;
  Widget title;

  PrimaryDialog({
    this.content,
    this.actions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      content: content,
      actions: actions,
      title: title,
    );
  }
}
