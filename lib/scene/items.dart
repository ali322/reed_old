import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/model/model.dart';
import 'package:reed/scene/item.dart';

class Items extends StatelessWidget {
  final String baseURL;
  final String apiKey;

  const Items({@required this.baseURL, @required this.apiKey})
      : assert(baseURL != null),
        assert(apiKey != null);

  Widget _renderItems(List<Item> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int i) {
        final _item = items[i];
        return ListTile(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ItemScene(item: _item)));
          },
          title: Text(_item.title),
          subtitle: Row(children: <Widget>[
            Text(_item.author,
                style: TextStyle(fontSize: 12.0, color: Colors.grey)),
            SizedBox(width: 12.0),
            Text(fromNow(_item.createdAt),
                style: TextStyle(fontSize: 12.0, color: Colors.grey))
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ItemsBloc, ItemsState>(
        builder: (BuildContext context, ItemsState state) {
          if (state is ItemsFetchSuccess) {
            final _items = state.items;
            return _renderItems(_items);
          } else if (state is ItemsFindSuccess) {
            final _items = state.items;
            return _renderItems(_items);
          }
          return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
        },
      ),
    );
  }
}
