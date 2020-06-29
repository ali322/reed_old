import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<FeedsBloc, FeedsState>(
        builder: (BuildContext context, FeedsState state) {
          if (state is FeedsFetchSuccess) {
            final _groups = state.groups;
            final _allFeeds = state.feeds;
            return ListView.builder(
              itemCount: _groups.length,
              itemBuilder: (BuildContext context, int i) {
                final _group = _groups[i];
                final _feeds = _allFeeds.takeWhile((_feed) => _group.feeds.contains(_feed.id));
                return ExpansionTile(
                  title: Text(_group.title),
                  children: _feeds.map<Widget>((_feed) {
                    return Text(_feed.title);
                  }).toList(),
                );
              },
            );
          }
          return Container();
        },
      )
    );
  }
}
