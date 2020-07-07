import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/model/model.dart';
import 'package:reed/repository/repository.dart';
import 'package:reed/scene/entry.dart';

class EntriesScene extends StatelessWidget {
  Widget _renderEntries(List<Entry> entries) {
    return ListView.builder(
      itemCount: entries.length,
      itemExtent: 60,
      itemBuilder: (BuildContext context, int i) {
        final _entry = entries[i];
        return ListTile(
          dense: true,
          onTap: () {
            final _repository = context.repository<EntryRepository>();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => RepositoryProvider.value(
                    value: _repository, child: EntryScene(id: _entry.id))));
          },
          title: Text(_entry.title, style: TextStyle(fontSize: 14.0)),
          subtitle: Row(children: <Widget>[
            Text(_entry.author,
                style: TextStyle(fontSize: 12.0, color: Colors.grey)),
            SizedBox(width: 12.0),
            Text(fromNow(_entry.publishedAt),
                style: TextStyle(fontSize: 12.0, color: Colors.grey))
          ]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<EntriesBloc, EntriesState>(
        builder: (BuildContext context, EntriesState state) {
          if (state is EntriesFetchSuccess) {
            final _entries = state.entries;
            return _renderEntries(_entries);
          }
          if (state is EntriesRefreshSuccess) {
            final _entries = state.entries;
            return _renderEntries(_entries);
          }
          return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
        },
      ),
    );
  }
}
