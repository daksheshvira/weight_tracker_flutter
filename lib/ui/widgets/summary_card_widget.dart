import 'package:flutter/material.dart';

class SummaryCardWidget extends StatelessWidget {
  String title;
  Color titleColor;
  String subtitle;
  Color subtitleColor;
  Widget widget;

  SummaryCardWidget(
      {this.title,
      this.titleColor,
      this.subtitle,
      this.subtitleColor,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget,
        ),
      ),
    );
  }
}
