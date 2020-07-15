import 'package:flutter/material.dart';
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
                        Text(_user.username),
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
        if (state is FeedsFetchSuccess) {
          final _categories = state.categories;
          return ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (BuildContext context, int i) {
              final _category = _categories[i];
              if (_category.feeds.length == 0) {
                return ListTile(
                  dense: true,
                  onTap: () {
                    onChange();
                    Navigator.of(context).pop();
                  },
                  title: Container(
                    child: Text(_category.title),
                  ),
                );
              }
              return ExpansionTile(
                title: Text(_category.title),
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
                                  Container(child: Icon(Icons.rss_feed)),
                                  SizedBox(width: 12.0),
                                  Expanded(child: Text(_feed.title))
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
                title: Text('Settings'.tr(), style: TextStyle(fontSize: 14.0)),
                trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
              )
            ),
          )
        ]));
  }
}
