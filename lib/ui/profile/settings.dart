import 'package:flutter/material.dart';
import 'package:weight_tracker/ui/widgets/primary_appbar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(title: "Settings"),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: Text("Switch units to Kg"),
            trailing: Switch(
              activeColor: Theme.of(context).primaryColor,
              value: false,
              onChanged: (value) => {},
            ),
          )
        ],
      ),
    );
  }
}
