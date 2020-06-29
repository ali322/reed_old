import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/repository/repository.dart';

class Items extends StatefulWidget{
  final String baseURL;
  final String apiKey;

  const Items({@required this.baseURL, @required this.apiKey})
      : assert(baseURL != null),
        assert(apiKey != null);

  @override
  State<StatefulWidget> createState() => _ItemsState();
}

class _ItemsState extends State<Items>{
  ItemsBloc _bloc;

  @override
  void initState() {
    super.initState();
    ItemRepository _repository = ItemRepository(baseURL: widget.baseURL, apiKey: widget.apiKey);
    _bloc = ItemsBloc(repository: _repository);
    _bloc.add(FetchItems());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, ItemsState state) {
          if (state is ItemsFetchSuccess) {
            final _items = state.items;
            return ListView.builder(
              itemCount: _items.length,
              itemBuilder: (BuildContext context, int i) {
                final _item = _items[i];
                return ListTile(
                  title: Text(_item.title),
                  subtitle: Text(_item.createdAt),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
        },
      ),
    );
  }
}