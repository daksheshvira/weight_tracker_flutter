import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  String title;
  Color titleColor;
  String subtitle;
  Color subtitleColor;

  SummaryCard({this.title, this.titleColor, this.subtitle, this.subtitleColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              Text(
                subtitle ?? "",
                style: TextStyle(
                    color: subtitleColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
