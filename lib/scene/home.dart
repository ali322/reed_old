import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/model/model.dart';
import 'package:reed/repository/repository.dart';
import 'package:reed/scene/entries.dart';
import 'package:reed/scene/sidebar.dart';

class HomeScene extends StatefulWidget {
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
  String _title = 'All';
  Feed _selectedFeed;

  @override
  void initState() {
    super.initState();
    _fetchInitial();
    _completer = Completer<void>();
  }

  void _fetchInitial() {
    FeedRepository _feedsRepository = context.repository<FeedRepository>();
    _feedsBloc = FeedsBloc(repository: _feedsRepository);
    _feedsBloc.add(FeedsEvent.FetchFeeds);

    EntryRepository _repository = context.repository<EntryRepository>();
    _entriesBloc = EntriesBloc(repository: _repository);
    _entriesBloc.add(FetchEntries());
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  void _onSidebarChange({Feed feed}) {
    setState(() {
      if (feed != null) {
        _title = feed.title;
      } else {
        _title = 'All';
      }
      _selectedFeed = feed;
    });
    _entriesBloc.add(FetchEntries(feed: feed));
  }

  Future<void> _onRefresh() {
    _entriesBloc.add(RefreshEntries(feed: _selectedFeed));
    return _completer.future;
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
            title: Text(_title),
            elevation: 0.5,
            leading: IconButton(icon: Icon(Icons.menu), onPressed: _openDrawer),
          ),
          drawer: Drawer(
              child: Container(
            alignment: Alignment.center,
            child: SideBar(onChange: _onSidebarChange),
          )),
          bottomNavigationBar: BottomAppBar(
              child: SizedBox(
            height: 64.0,
            child: Row(children: <Widget>[
              Expanded(
                child: InkWell(
                    onTap: () {
                      _entriesBloc.add(FetchEntries(
                          feed: _selectedFeed, status: EntryStatus.UnReaded));
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.adjust),
                          SizedBox(height: 6.0),
                          Text('Unread')
                        ])),
              ),
              Expanded(
                child: InkWell(
                    onTap: () {
                      _entriesBloc.add(FetchEntries(
                          feed: _selectedFeed, status: EntryStatus.All));
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.public),
                          SizedBox(height: 6.0),
                          Text('All')
                        ])),
              ),
              Expanded(
                child: InkWell(
                    onTap: () {
                      _entriesBloc.add(FetchEntries(
                          feed: _selectedFeed, status: EntryStatus.Starred));
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.favorite_border),
                          SizedBox(height: 6.0),
                          Text('Favorite')
                        ])),
              ),
            ]),
          )),
          body: SafeArea(
              bottom: true,
              child: BlocListener<EntriesBloc, EntriesState>(
                  listener: (context, state) {
                    if (state is EntriesRefreshSuccess) {
                      _completer?.complete();
                      _completer = Completer();
                    }
                  },
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: Container(
                      child: EntriesScene(),
                    ),
                  ))),
        ));
  }
}
