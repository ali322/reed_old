import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/repository/repository.dart';
import 'package:reed/scene/entries.dart';
import 'package:reed/scene/sidebar.dart';

class HomeScene extends StatefulWidget {
  final String baseURL;
  final String apiKey;

  const HomeScene({@required this.baseURL, @required this.apiKey})
      : assert(baseURL != null),
        assert(apiKey != null);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScene> {
  FeedsBloc _feedsBloc;
  EntriesBloc _entriesBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<void> _completer;

  @override
  void initState() {
    super.initState();
    _fetchInitial();
    _completer = Completer<void>();
  }

  void _fetchInitial() {
    FeedRepository _feedsRepository =
        FeedRepository(baseURL: widget.baseURL, apiKey: widget.apiKey);
    _feedsBloc = FeedsBloc(repository: _feedsRepository);
    _feedsBloc.add(FeedsEvent.FetchFeeds);

    EntryRepository _repository =
        EntryRepository(baseURL: widget.baseURL, apiKey: widget.apiKey);
    _entriesBloc = EntriesBloc(repository: _repository);
    _entriesBloc.add(FetchEntries());
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _feedsBloc),
          BlocProvider.value(value: _entriesBloc),
        ],
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Container(
                child: BlocConsumer<EntriesBloc, EntriesState>(
                    listener: (BuildContext context, EntriesState state) {
              if (state is EntriesFetchSuccess) {
                _completer?.complete();
                _completer = Completer();
              }
            }, builder: (BuildContext context, EntriesState state) {
              return Text('123', style: TextStyle(fontSize: 14.0));
            })),
            elevation: 0.5,
            leading: IconButton(icon: Icon(Icons.menu), onPressed: _openDrawer),
          ),
          drawer: Drawer(
              child: Container(
            alignment: Alignment.center,
            child: BlocProvider.value(
              value: _feedsBloc,
              child: SideBar(),
            ),
          )),
          body: SafeArea(
              bottom: true,
              child: RefreshIndicator(
                onRefresh: () {
                  _fetchInitial();
                  return _completer.future;
                },
                child: Container(
                    child: BlocProvider.value(
                  value: _entriesBloc,
                  child: EntriesScene(
                      baseURL: widget.baseURL, apiKey: widget.apiKey),
                )),
              )),
        ));
  }
}
