import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';

class SideBar extends StatelessWidget {
  Widget _buildGroups(BuildContext context, List _groups, List _allFeeds) {
    return ListView.builder(
      itemCount: _groups.length,
      itemBuilder: (BuildContext context, int i) {
        final _group = _groups[i];
        final _feeds = _allFeeds
            .where((_feed) => _group.feeds.contains(_feed.id))
            .toList();
        if (_group.title == 'All') {
          return ListTile(
            title: Container(
              child: Text(_group.title),
            ),
          );
        }
        return ExpansionTile(
          title: Text(_group.title),
          children: _feeds
              .map<Widget>((_feed) => ListTile(
                    onTap: () {
                      BlocProvider.of<ItemsBloc>(context)
                          .add(FindItems(feedID: _feed.id));
                    },
                    title: Container(
                        child: Row(
                          children: <Widget>[
                            _feed.favicon != null
                                ? Image.memory(
                                    base64Decode(_feed.favicon
                                        .split(';')[1]
                                        .split(',')[1]),
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                    gaplessPlayback: true,
                                  )
                                : Container(child: Icon(Icons.rss_feed)),
                            SizedBox(width: 15.0),
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

  @override
  Widget build(BuildContext context) {
    return Container(child: BlocBuilder<FeedsBloc, FeedsState>(
      builder: (BuildContext context, FeedsState state) {
        if (state is FeedsFetchSuccess) {
          final _groups = state.groups;
          final _allFeeds = state.feeds;
          return Container(
              padding: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: _buildGroups(context, _groups, _allFeeds));
        }
        return Container();
      },
    ));
  }
}
