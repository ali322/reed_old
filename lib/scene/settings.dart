import 'package:flutter/material.dart';

class SettingsScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<SettingsScene> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.navigate_before),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Container(
          child: Column(children: <Widget>[
            ListTile(
              title: Text('Dark Mode'),
              // trailing: Switch(value: null, onChanged: null)
            )
          ]),
        )
      )
    );
  }
}
