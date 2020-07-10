part of bloc;

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class SettingsChanged extends SettingsEvent {
  final String key;
  final dynamic value;
  SettingsChanged({@required this.key, @required this.value})
      : assert(key != null),
        assert(value != null);
  @override
  List<Object> get props => [key, value];
}

class SettingsState extends Equatable {
  final Map<String, dynamic> values;

  const SettingsState({@required this.values});

  @override
  List<Object> get props => [values];
}

class SettingsInitial extends SettingsState {
  final Map<String, dynamic> values = {
    'isDarkMode': false,
    'language': 'English'
  };

  @override
  List<Object> get props => [values];
}

class SettingsLoadSuccess extends SettingsState {
  final Map<String, dynamic> values;

  const SettingsLoadSuccess({@required this.values}) : assert(values != null);

  @override
  List<Object> get props => [values];
}

class SettingsLoadFailure extends SettingsState {}

class SettingsChangeSuccess extends SettingsState {
  final String key;
  final dynamic value;
  SettingsChangeSuccess({@required this.key, @required this.value})
      : assert(key != null),
        assert(value != null);
  @override
  List<Object> get props => [key, value];
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({@required this.repository}) : assert(repository != null);

  @override
  SettingsState get initialState => SettingsInitial();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsChanged) {
      await repository.saveSettings(key: event.key, value: event.value);
      yield SettingsChangeSuccess(key: event.key, value: event.value);
    }
    if (event is LoadSettings) {
      final _ret = await repository.loadSettings();
      if (_ret != null) {
        yield SettingsLoadSuccess(values: _ret);
      }
    }
  }
}
