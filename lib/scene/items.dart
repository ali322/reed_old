import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/model/model.dart';

class Items extends StatelessWidget {
  final String baseURL;
  final String apiKey;

  const Items({@required this.baseURL, @required this.apiKey})
      : assert(baseURL != null),
        assert(apiKey != null);

  Widget _buildList(List<Item> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int i) {
        final _item = items[i];
        return ListTile(
          title: Text(_item.title),
          subtitle: Text('${fromNow(_item.createdAt)}'),
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
            return _buildList(_items);
          } else if (state is ItemsFindSuccess) {
            final _items = state.items;
            return _buildList(_items);
          }
          return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
        },
      ),
    );
  }
}
