import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/repository/repository.dart';
import 'package:reed/scene/home.dart';
import 'package:reed/scene/login.dart';

import 'bloc/bloc.dart';
import 'repository/repository.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  APIBloc _apiBloc;
  SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    BlocSupervisor.delegate = SimpleBlocDelegate();
    final _apiRepository = APIRepository();
    _apiBloc = APIBloc(repository: _apiRepository);
    _apiBloc.add(LoadAPICredential());

    final _settingsRepository = SettingsRepository();
    _settingsBloc = SettingsBloc(repository: _settingsRepository);
    _settingsBloc.add(LoadSettings());
  }

  Widget _renderHome(context, state) {
    return MultiRepositoryProvider(providers: [
      RepositoryProvider<FeedRepository>(
          create: (context) =>
              FeedRepository(apiKey: state.apiKey, baseURL: state.baseURL)),
      RepositoryProvider<EntryRepository>(
        create: (context) =>
            EntryRepository(apiKey: state.apiKey, baseURL: state.baseURL),
      )
    ], child: HomeScene());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _apiBloc),
          BlocProvider.value(value: _settingsBloc),
        ],
        child: MaterialApp(
          title: 'Reed',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              iconTheme: IconThemeData(color: Colors.black54),
              hintColor: Colors.black54,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: BlocBuilder<APIBloc, APIState>(builder: (context, state) {
            if (state is APICredentialSaveSuccess ||
                state is APICredentialLoadSuccess) {
              return _renderHome(context, state);
            }
            if (state is APICredentialLoading) {
              return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
            }
            return LoginScene();
          }),
        ));
  }
}
