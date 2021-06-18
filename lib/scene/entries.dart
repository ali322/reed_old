import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/model/model.dart';
import 'package:reed/repository/repository.dart';
import 'package:reed/scene/entry.dart';

import '../bloc/bloc.dart';

class EntriesScene extends StatefulWidget {
  final Feed? feed;
  final EntryStatus status;
  const EntriesScene({this.feed, required this.status});
  @override
  State<StatefulWidget> createState() {
    return _EntriesState();
  }
}

class _EntriesState extends State<EntriesScene> {
  String _sortDirection = 'desc';
  void _onEntryFetched(int id) {
    if (widget.status == EntryStatus.UnReaded) {
      context.read<EntriesBloc>().add(ChangeEntriesStatus(
          ids: [id], from: EntryStatus.UnReaded, to: EntryStatus.Read));
    }
  }

  Widget _renderEntries(List<Entry> entries) {
    return ListView.builder(
      itemCount: entries.length,
      itemExtent: 60,
      itemBuilder: (BuildContext context, int i) {
        final _entry = entries[i];
        return ListTile(
          dense: true,
          onTap: () {
            final _repository = context.read<EntryRepository>();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => RepositoryProvider.value(
                    value: _repository,
                    child: EntryScene(
                        id: _entry.id, onFetched: _onEntryFetched))));
          },
          title: Text(_entry.title,
              style: _entry.status != EntryStatus.Read
                  ? TextStyle(fontSize: 14.0)
                  : TextStyle(fontSize: 14.0, color: Colors.grey)),
          subtitle: Row(children: <Widget>[
            Text(_entry.author != '' ? _entry.author : _entry.feed.title,
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.feed == null ? "All".tr() : widget.feed!.title),
          elevation: 0.5,
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.sort),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              onSelected: (String val) {
                setState(() {
                  _sortDirection = val;
                });
                context
                    .read<EntriesBloc>()
                    .add(SortEntries(direction: val, status: widget.status));
              },
              itemBuilder: (context) => [
                CheckedPopupMenuItem(
                  checked: _sortDirection == 'desc',
                  value: 'desc',
                  child: Text('Newest to Oldest'.tr()),
                ),
                CheckedPopupMenuItem(
                  checked: _sortDirection == 'asc',
                  value: 'asc',
                  child: Text('Oldest to Newest'.tr()),
                )
              ],
            )
          ],
        ),
        body: BlocBuilder<EntriesBloc, EntriesState>(
          builder: (context, state) {
            if (state.status == EntriesStatus.FetchSuccess ||
                state.status == EntriesStatus.RefreshSuccess ||
                state.status == EntriesStatus.SortSuccess ||
                state.status == EntriesStatus.ChangeSuccess) {
              List<Entry> _entries = state.data[widget.status]!.entries;
              if (widget.feed != null) {
                _entries =
                    _entries.where((v) => v.feedID == widget.feed!.id).toList();
              }
              return _renderEntries(_entries);
            }
            return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
          },
        ));
  }
}
