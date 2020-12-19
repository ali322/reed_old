import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/model/model.dart';
import '../bloc/bloc.dart';
import './settings.dart';

typedef TitleChanged = void Function({Feed feed});

class SideBar extends StatelessWidget {
  final TitleChanged onChange;
  const SideBar({@required this.onChange}) : assert(onChange != null);

  Widget _renderUser(BuildContext context) {
    return BlocBuilder<MeBloc, MeState>(
      builder: (context, state) {
        if (state is MeFetchSuccess) {
          final _user = state.user;
          return Container(
              decoration: BoxDecoration(
                border: Border(bottom: Divider.createBorderSide(context)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 70.0, bottom: 30.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Text(_user.username[0].toUpperCase()),
                    ),
                    SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_user.username, style: TextStyle(fontSize: 16.0)),
                        SizedBox(height: 2.0),
                        Text(fromNow(_user.lastLoginAt),
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.grey))
                      ],
                    )
                  ],
                ),
              ));
        }
        return Container();
      },
    );
  }

  Widget _renderCategories(BuildContext context) {
    return BlocBuilder<FeedsBloc, FeedsState>(
      builder: (context, state) {
        if (state is FeedsFetchSuccess || state is FeedsIconFetchSuccess || state is FeedsCalculateSuccess) {
          final _categories = state.categories;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            itemCount: _categories.length,
            itemBuilder: (BuildContext context, int i) {
              final _category = _categories[i];
              if (_category.id == 1) {
                return ListTile(
                  dense: true,
                  onTap: () {
                    onChange();
                    Navigator.of(context).pop();
                  },
                  title: Container(
                    child: Text('Unread Articles'.tr(), style: TextStyle(fontSize: 16.0)),
                  ),
                  trailing: Text('${_category.unreadCount != null ? _category.unreadCount : 0}', style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                );
              }
              return ExpansionTile(
                title: Text(_category.title, style: TextStyle(fontSize: 16.0)),
                children: _category.feeds
                    .map<Widget>((_feed) => InkWell(
                          onTap: () {
                            onChange(feed: _feed);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16.0),
                              child: Row(
                                children: <Widget>[
                                  _feed.icon != null
                                ? Image.memory(
                                    base64Decode(_feed.icon
                                        .split(';')[1]
                                        .split(',')[1]),
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                    gaplessPlayback: true,
                                  )
                                : Container(child: Icon(Icons.rss_feed)),
                                  SizedBox(width: 12.0),
                                  Expanded(child: Text(_feed.title)),
                                  Text('${_feed.unreadCount}', style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                                ],
                              ),
                              alignment: Alignment.centerLeft),
                        ))
                    .toList(),
              );
            },
          );
        }
        return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
          _renderUser(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _renderCategories(context)
            ),
          ),
          SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                onTap: () async {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingsScene()));
                },
                dense: true,
                title: Text('Settings'.tr(), style: TextStyle(fontSize: 16.0)),
                trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
              )
            ),
          )
        ]));
  }
}
