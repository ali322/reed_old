import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:reed/model/model.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/repository/repository.dart';

class EntryScene extends StatefulWidget {
  final int id;
  const EntryScene({@required this.id}) : assert(id != null);
  @override
  State<StatefulWidget> createState() => _EntryState();
}

class _EntryState extends State<EntryScene> {
  EntryBloc _bloc;
  @override
  void initState() {
    super.initState();
    EntryRepository _repository = context.repository<EntryRepository>();
    _bloc = EntryBloc(repository: _repository);
    _bloc.add(FetchEntry(id: widget.id));
  }

  Widget _renderTitle(BuildContext context, Entry entry) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Text(entry.title, style: TextStyle(fontSize: 16.0)));
  }

  Widget _renderBrief(BuildContext context, Entry entry) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: Row(children: <Widget>[
          Text(entry.author,
              style: TextStyle(fontSize: 12.0, color: Colors.grey)),
          SizedBox(width: 12.0),
          Text(fromNow(entry.publishedAt),
              style: TextStyle(fontSize: 12.0, color: Colors.grey))
        ]));
  }

  Widget _renderBody(BuildContext context, Entry entry) {
    return Container(
        child: Html(
      data: entry.content,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
            bottom: true,
            child: BlocBuilder(
              bloc: _bloc,
              builder: (BuildContext context, state) {
                if (state is EntryFetchSuccess) {
                  final _entry = state.entry;
                  return SingleChildScrollView(
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(children: <Widget>[
                            _renderTitle(context, _entry),
                            _renderBrief(context, _entry),
                            _renderBody(context, _entry)
                          ])));
                }
                return Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0));
              },
            )));
  }
}
