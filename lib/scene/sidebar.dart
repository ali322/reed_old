import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/model/model.dart';
import './settings.dart';

typedef TitleChanged = void Function({Feed feed});

class SideBar extends StatelessWidget {
  final TitleChanged onChange;
  const SideBar({@required this.onChange}) : assert(onChange != null);

  Widget _renderCategories(BuildContext context, List<Category> categories) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int i) {
        final _category = categories[i];
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

  @override
  Widget build(BuildContext context) {
    return Container(child: BlocBuilder<FeedsBloc, FeedsState>(
      builder: (BuildContext context, FeedsState state) {
        if (state is FeedsFetchSuccess) {
          final _categories = state.categories;
          return Container(
              padding: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: Column(children: [
                SizedBox(height: 40.0),
                Expanded(child: _renderCategories(context, _categories)),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SettingsScene()
                    ));
                  },
                  dense: true,
                  title: Text('Setting'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                )
              ]));
        }
        return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
      },
    ));
  }
}
