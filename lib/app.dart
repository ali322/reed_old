import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reed/bloc/bloc.dart';
import 'package:reed/repository/repository.dart';
import 'package:reed/scene/home.dart';
import 'package:reed/scene/login.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  APIBloc _bloc;

  @override
  void initState() {
    super.initState();
    final _repository = APIRepository();
    _bloc = APIBloc(repository: _repository);
    _bloc.add(LoadAPICredential());
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
    return BlocProvider.value(
        value: _bloc,
        child: MaterialApp(
          title: 'Reed',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.deepOrange,
              iconTheme: IconThemeData(color: Colors.black54),
              hintColor: Colors.black54,
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: BlocBuilder<APIBloc, APIState>(builder: (context, state) {
            if (state is APICredentialSaveSuccess) {
              return _renderHome(context, state);
            }
            if (state is APICredentialLoadSuccess) {
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
