import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/repository/repository.dart';
import 'package:reed/scene/items.dart';
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
  ItemsBloc _itemsBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    FeedRepository _feedsRepository =
        FeedRepository(baseURL: widget.baseURL, apiKey: widget.apiKey);
    _feedsBloc = FeedsBloc(repository: _feedsRepository);
    _feedsBloc.add(FeedsEvent.FetchFeeds);

    ItemRepository _repository =
        ItemRepository(baseURL: widget.baseURL, apiKey: widget.apiKey);
    _itemsBloc = ItemsBloc(repository: _repository);
    _itemsBloc.add(FetchItems());
  }

  void _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _feedsBloc),
          BlocProvider.value(value: _itemsBloc),
        ],
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            title: Text('Home'),
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
            child: Container(
                child: BlocProvider.value(
              value: _itemsBloc,
              child: Items(baseURL: widget.baseURL, apiKey: widget.apiKey),
            )),
          ),
        ));
  }
}
