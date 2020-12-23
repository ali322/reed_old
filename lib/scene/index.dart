import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/model/model.dart';
import 'package:reed/repository/repository.dart';
import 'package:reed/scene/settings.dart';
import 'package:reed/scene/entries.dart';

import '../bloc/bloc.dart';
import '../repository/repository.dart';

class IndexScene extends StatefulWidget {
  final Map<String, dynamic> settings;
  final String title;
  const IndexScene({Key key, @required this.settings, @required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IndexState();
  }
}

class _IndexState extends State<IndexScene> {
  FeedsBloc _feedsBloc;
  EntriesBloc _entriesBloc;
  EntryRepository _entryRepository;
  MeBloc _meBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<void> _completer;
  String _sortDirection = 'desc';
  EntryStatus _selectedStatus = EntryStatus.UnReaded;
  int _selectedIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitial();
    _completer = Completer<void>();
  }

  void _fetchInitial() {
    FeedRepository _feedsRepository = context.read<FeedRepository>();
    _feedsBloc = FeedsBloc(repository: _feedsRepository);
    _feedsBloc.add(FetchFeeds());

    _entryRepository = context.read<EntryRepository>();
    _entriesBloc = EntriesBloc(repository: _entryRepository);
    _entriesBloc.add(FetchEntries(
        direction: _sortDirection,
        status: EntryStatus.UnReaded,
        limit: widget.settings['fetchPertime']));

    UserRepository _userRepository = context.read<UserRepository>();
    _meBloc = MeBloc(repository: _userRepository);
    _meBloc.add(FetchMe());
  }

  Future<void> _onRefresh() {
    _entriesBloc.add(RefreshEntries(
        status: _selectedStatus,
        direction: _sortDirection,
        limit: widget.settings['fetchPertime']));
    return _completer.future;
  }

  Widget _renderTile(Category category, BuildContext context) {
    return ExpansionTile(
      title: Text(category.title, style: TextStyle(fontSize: 16.0)),
      children: category.feeds
          .map<Widget>((_feed) => InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RepositoryProvider.value(
                          value: _entryRepository,
                          child: BlocProvider.value(
                              value: _entriesBloc,
                              child: EntriesScene(
                                  feed: _feed, status: _selectedStatus)))));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        _feed.icon != null
                            ? Image.memory(
                                base64Decode(
                                    _feed.icon.split(';')[1].split(',')[1]),
                                width: 20,
                                height: 20,
                                fit: BoxFit.fill,
                                gaplessPlayback: true,
                              )
                            : Container(child: Icon(Icons.rss_feed)),
                        SizedBox(width: 12.0),
                        Expanded(child: Text(_feed.title)),
                        Text('${_feed.count}',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 12.0)),
                      ],
                    ),
                    alignment: Alignment.centerLeft),
              ))
          .toList(),
    );
  }

  Widget _renderCategories(BuildContext context) {
    if (_loading) {
      return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
    }
    return BlocBuilder<FeedsBloc, FeedsState>(
      builder: (context, state) {
        final _categories = state.categories;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemCount: _categories.length,
          itemBuilder: (BuildContext context, int i) {
            final _category = _categories[i];
            if (_category.id == 1) {
              return ListTile(
                dense: true,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RepositoryProvider.value(
                          value: _entryRepository,
                          child: BlocProvider.value(
                              value: _entriesBloc,
                              child: EntriesScene(status: _selectedStatus)))));
                },
                title: Container(
                  child: Text('All Articles'.tr(),
                      style: TextStyle(fontSize: 16.0)),
                ),
                trailing: Text(
                    '${_category.count != null ? _category.count : 0}',
                    style: TextStyle(color: Colors.grey, fontSize: 12.0)),
              );
            }
            final _themeData = Theme.of(context).copyWith(dividerColor: Colors.transparent);
            return Theme(data: _themeData, child: _renderTile(_category, context));
          },
        );
      },
    );
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
            title: Text(widget.title),
            elevation: 0.5,
            actions: [
              IconButton(
                  icon: Icon(Icons.settings_outlined),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SettingsScene(),
                        fullscreenDialog: true));
                  })
            ],
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<EntriesBloc, EntriesState>(
                  listener: (context, state) {
                if (state is EntriesRefreshSuccess) {
                  _completer?.complete();
                  _completer = Completer<void>();
                }
                if (state is EntriesFetchSuccess ||
                    state is EntriesRefreshSuccess) {
                  _feedsBloc.add(CalculateFeeds(
                      entries: state.data[_selectedStatus].entries));
                }
              }),
              BlocListener<FeedsBloc, FeedsState>(listener: (context, state) {
                if (state is FeedsCalculateSuccess) {
                  setState(() {
                    _loading = false;
                  });
                  // _feedsBloc.add(FetchFeedsIcon());
                }
              })
            ],
            child: SafeArea(
                bottom: true,
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: Container(
                    child: _renderCategories(context),
                  ),
                )),
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
              setState(() {
                _loading = true;
              });
              if (_entriesBloc.state.data[_selectedStatus].offset == 0) {
                _entriesBloc.add(FetchEntries(
                    status: _selectedStatus,
                    direction: _sortDirection,
                    limit: widget.settings['fetchPertime']));
              } else {
                _feedsBloc.add(CalculateFeeds(
                    entries: _entriesBloc.state.data[_selectedStatus].entries));
              }
            },
            currentIndex: _selectedIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.adjust), label: 'Unread'.tr()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.public), label: 'All'.tr()),
              BottomNavigationBarItem(
                  icon: Icon(Icons.star), label: 'Starred'.tr())
            ],
          ),
        ));
  }
}
