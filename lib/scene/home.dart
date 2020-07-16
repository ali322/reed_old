import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/model/model.dart';
import 'package:reed/repository/repository.dart';
import 'package:reed/scene/entries.dart';
import 'package:reed/scene/sidebar.dart';

import '../bloc/bloc.dart';
import '../repository/repository.dart';

class HomeScene extends StatefulWidget {
  final Map<String, dynamic> settings;
  const HomeScene({@required this.settings});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeScene> {
  FeedsBloc _feedsBloc;
  EntriesBloc _entriesBloc;
  MeBloc _meBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<void> _completer;
  String _title = 'All';
  String _sortDirection = 'desc';
  Feed _selectedFeed;
  EntryStatus _selectedStatus = EntryStatus.All;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitial();
    _completer = Completer<void>();
  }

  void _fetchInitial() {
    FeedRepository _feedsRepository = context.repository<FeedRepository>();
    _feedsBloc = FeedsBloc(repository: _feedsRepository);
    _feedsBloc.add(FetchFeeds());

    EntryRepository _entryRepository = context.repository<EntryRepository>();
    _entriesBloc = EntriesBloc(repository: _entryRepository);
    _entriesBloc.add(FetchEntries(
        status: EntryStatus.UnReaded, limit: widget.settings['fetchPertime']));

    UserRepository _userRepository = context.repository<UserRepository>();
    _meBloc = MeBloc(repository: _userRepository);
    _meBloc.add(FetchMe());
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
    _entriesBloc.add(FetchEntries(
        feed: feed,
        status: EntryStatus.UnReaded,
        limit: widget.settings['fetchPertime']));
  }

  Future<void> _onRefresh() {
    _entriesBloc.add(RefreshEntries(
        feed: _selectedFeed,
        status: _selectedStatus,
        limit: widget.settings['fetchPertime']));
    return _completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _feedsBloc),
          BlocProvider.value(value: _entriesBloc),
          BlocProvider.value(value: _meBloc)
        ],
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text(_title),
            elevation: 0.5,
            leading: IconButton(icon: Icon(Icons.menu), onPressed: _openDrawer),
            actions: <Widget>[
              PopupMenuButton(
                icon: Icon(Icons.sort),
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                onSelected: (String val) {
                  setState(() {
                    _sortDirection = val;
                  });
                  _entriesBloc.add(SortEntries(direction: val));
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
          drawer: Drawer(
            child: BlocListener<FeedsBloc, FeedsState>(
              listener: (context, state) {
                if (state is FeedsFetchSuccess) {
                  _feedsBloc.add(FetchFeedsIcon());
                }
              },
              child: SideBar(onChange: _onSidebarChange)
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int i) {
              setState(() {
                _selectedIndex = i;
              });
              if (i == 0) {
                _selectedStatus = EntryStatus.UnReaded;
              }
              if (i == 1) {
                _selectedStatus = EntryStatus.All;
              }
              if (i == 2) {
                _selectedStatus = EntryStatus.Starred;
              }
              _entriesBloc.add(FetchEntries(
                  feed: _selectedFeed,
                  status: _selectedStatus,
                  limit: widget.settings['fetchPertime']));
            },
            currentIndex: _selectedIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.adjust),
                  title: Text('Unread'.tr(), style: TextStyle(fontSize: 14.0))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.public),
                  title: Text('All'.tr(), style: TextStyle(fontSize: 14.0))),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  title:
                      Text('Favorite'.tr(), style: TextStyle(fontSize: 14.0)))
            ],
          ),
          body: SafeArea(
              bottom: true,
              child: BlocListener<EntriesBloc, EntriesState>(
                  listener: (context, state) {
                    if (state is EntriesRefreshSuccess) {
                      _completer?.complete();
                      _completer = Completer();
                    }
                    if (state is EntriesFetchSuccess && _selectedFeed == null) {
                      context
                          .bloc<FeedsBloc>()
                          .add(CalculateUnreadEntries(entries: state.entries));
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
