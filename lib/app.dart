import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
    print(context.locale.toLanguageTag());
    return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _apiBloc),
          BlocProvider.value(value: _settingsBloc),
        ],
        child: BlocConsumer<SettingsBloc, SettingsState>(
            listener: (context, state) {
          if (state is SettingsChangeSuccess && state.key == 'language') {
            context.locale = Locale('zh', 'CN');
          }
        }, builder: (context, state) {
          return MaterialApp(
            title: 'Reed',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            theme: ThemeData(
                brightness: state.values['isDarkMode'] == true
                    ? Brightness.dark
                    : Brightness.light,
                primaryColor: state.values['isDarkMode'] == true
                    ? Colors.black
                    : Colors.deepOrange,
                primaryColorDark: Colors.black,
                primaryColorLight: Colors.white,
                // iconTheme: IconThemeData(color: Colors.black54),
                // hintColor: Colors.black54,
                visualDensity: VisualDensity.adaptivePlatformDensity),
            home: BlocBuilder<APIBloc, APIState>(builder: (context, state) {
              if (state is APICredentialSaveSuccess ||
                  state is APICredentialLoadSuccess) {
                return _renderHome(context, state);
              }
              if (state is APICredentialLoading) {
                return Center(
                    child: CircularProgressIndicator(strokeWidth: 2.0));
              }
              return LoginScene();
            }),
          );
        }));
  }
}

class AppWithLocalization extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
        supportedLocales: [Locale('en', 'US')],
        path: 'assets/i18n',
        fallbackLocale: Locale('en', 'US'),
        child: App());
  }
}
