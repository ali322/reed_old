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
    _bloc.add(LoadAPI());
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
              visualDensity: VisualDensity.adaptivePlatformDensity),
          home: BlocBuilder<APIBloc, APIState>(builder: (context, state) {
            if (state is APIVerifySuccess) {
              return HomeScene(baseURL: state.baseURL, apiKey: state.apiKey);
            }
            if (state is APILoadSuccess) {
              return HomeScene(baseURL: state.baseURL, apiKey: state.apiKey);
            }
            return LoginScene();
            // return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
          }),
        ));
  }
}
