import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bloc.dart';
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
                    SettingsSection(
                      header: Text('General'),
                      tiles: <Widget>[
                        ListTile(
                            dense: true,
                            leading: Icon(Icons.iso),
                            title: Text('Dark Mode'),
                            trailing: Switch(
                                value: state.values['isDarkMode'],
                                onChanged: (bool truthy) {
                                  context.bloc<SettingsBloc>().add(
                                    SettingsChanged(key: 'isDarkMode', value: truthy)
                                  );
                                })),
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.language),
                          title: Text('Language'),
                          trailing: DropdownButton(
                            value: state.values['language'],
                            onChanged: (val) {
                              context.bloc<SettingsBloc>().add(
                                SettingsChanged(key: 'language', value: val)
                              );
                            },
                            items: <String>['English', 'Chinese']
                                .map<DropdownMenuItem>((val) =>
                                    DropdownMenuItem(
                                        child: Text(val), value: val))
                                .toList(),
                          ),
                        ),
                      ],
                    )
                  ]),
                );
              },
            )));
  }
}

class SettingsSection extends StatelessWidget {
  final List<Widget> tiles;
  final Widget header;
  final Widget footer;
  const SettingsSection({this.tiles, this.header, this.footer});

  @override
  Widget build(BuildContext context) {
    final List<Widget> _colums = [];
    if (header != null) {
      _colums.add(DefaultTextStyle(
        style:
            TextStyle(fontSize: 13.5, letterSpacing: -0.5, color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 12.0),
          child: header,
        ),
      ));
    }
    List<Widget> _tiles = [];
    for (var i = 0; i < tiles.length; i++) {
      if (i < tiles.length - 1) {
        _tiles.add(tiles[i]);
        _tiles.add(Divider(height: 0.3));
      } else {
        _tiles.add(tiles[i]);
      }
    }
    _colums.add(Container(
      decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).primaryColorDark,
          border: Border(
            top: Divider.createBorderSide(context),
            bottom: Divider.createBorderSide(context),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _tiles,
      ),
    ));
    return Padding(
      padding: EdgeInsets.only(top: header != null ? 22.0 : 35.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _colums,
      ),
    );
  }
}
