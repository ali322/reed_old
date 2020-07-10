import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';

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
            child: BlocBuilder<SettingsBloc, SettingsState>(
              builder: (context, state) {
                return Container(
                  child: Column(children: <Widget>[
                    ListTile(
                        title: Text('Dark Mode'),
                        trailing: Switch(
                            value: state.isDarkMode,
                            onChanged: (bool truthy) {
                              context
                                  .bloc<SettingsBloc>()
                                  .add(SettingsChangeDarkMode(truthy: truthy));
                            }))
                  ]),
                );
              },
            )));
  }
}
