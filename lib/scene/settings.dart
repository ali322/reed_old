import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './authorization.dart';
import './about.dart';
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
          title: Text('Settings'.tr()),
          leading: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.of(context).maybePop();
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
                      header: Text('General'.tr()),
                      tiles: <Widget>[
                        ListTile(
                            dense: true,
                            leading: Icon(Icons.brightness_4),
                            title: Text('Dark Mode'.tr(),
                                style: TextStyle(fontSize: 16.0)),
                            trailing: Switch(
                                value: state.values['isDarkMode'],
                                onChanged: (bool truthy) {
                                  context.bloc<SettingsBloc>().add(
                                      SettingsChanged(
                                          key: 'isDarkMode', value: truthy));
                                })),
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.language),
                          title: Text('Language'.tr(),
                              style: TextStyle(fontSize: 16.0)),
                          trailing: DropdownButton(
                            value: state.values['language'],
                            onChanged: (val) {
                              context.bloc<SettingsBloc>().add(
                                  SettingsChanged(key: 'language', value: val));
                            },
                            items: <String>['English', 'Chinese']
                                .map<DropdownMenuItem>((val) =>
                                    DropdownMenuItem(
                                        child: Text(val), value: val))
                                .toList(),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.file_download),
                          title: Text('Fetch Pertime'.tr(),
                              style: TextStyle(fontSize: 16.0)),
                          trailing: DropdownButton(
                            value: state.values['fetchPertime'],
                            onChanged: (val) {
                              context.bloc<SettingsBloc>().add(
                                  SettingsChanged(key: 'fetchPertime', value: val));
                            },
                            items: <int>[50, 100, 200, 500]
                                .map<DropdownMenuItem>((val) =>
                                    DropdownMenuItem(
                                        child: Text('$val ${"Entries".tr()}'), value: val))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    SettingsSection(
                      header: Text('Read'.tr()),
                      tiles: <Widget>[
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.format_size),
                          title: Text('FontSize'.tr(),
                              style: TextStyle(fontSize: 16.0)),
                          trailing: DropdownButton(
                            value: state.values['fontSize'],
                            onChanged: (val) {
                              context.bloc<SettingsBloc>().add(
                                  SettingsChanged(key: 'fontSize', value: val));
                            },
                            items: <double>[12.0, 14.0, 16.0, 18.0]
                                .map<DropdownMenuItem>((val) =>
                                    DropdownMenuItem(
                                        child: Text(val.toString()),
                                        value: val))
                                .toList(),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          leading: Icon(Icons.format_line_spacing),
                          title: Text('LetterSpacing'.tr(),
                              style: TextStyle(fontSize: 16.0)),
                          trailing: DropdownButton(
                            value: state.values['letterSpacing'],
                            onChanged: (val) {
                              context.bloc<SettingsBloc>().add(SettingsChanged(
                                  key: 'letterSpacing', value: val));
                            },
                            items: <double>[0.0, 2.0, 4.0, 6.0]
                                .map<DropdownMenuItem>((val) =>
                                    DropdownMenuItem(
                                        child: Text(val.toString()),
                                        value: val))
                                .toList(),
                          ),
                        ),
                        ListTile(
                            dense: true,
                            leading: Icon(Icons.format_bold),
                            title: Text('Bold'.tr(),
                                style: TextStyle(fontSize: 16.0)),
                            trailing: Switch(
                                value: state.values['isDarkMode'],
                                onChanged: (bool truthy) {
                                  context.bloc<SettingsBloc>().add(
                                      SettingsChanged(
                                          key: 'isDarkMode', value: truthy));
                                })),
                      ],
                    ),
                    SettingsSection(
                      header: Text('System'.tr()),
                      tiles: <Widget>[
                        ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: context.bloc<APIBloc>(),
                                    child: AuthorizationScene(),
                                  )));
                            },
                            dense: true,
                            leading: Icon(Icons.lock),
                            title: Text('Authorization'.tr(),
                                style: TextStyle(fontSize: 16.0)),
                            trailing:
                                Icon(Icons.navigate_next)),
                        ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AboutScene()));
                            },
                            dense: true,
                            leading: Icon(Icons.info),
                            title: Text('About'.tr(),
                                style: TextStyle(fontSize: 16.0)),
                            trailing:
                                Icon(Icons.navigate_next)),
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
      _colums.add(SizedBox(
          height: 30.0,
          child: DefaultTextStyle(
            style: TextStyle(
                fontSize: 13.5, letterSpacing: -0.5, color: Colors.grey),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 12.0),
              child: header,
            ),
          )));
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
