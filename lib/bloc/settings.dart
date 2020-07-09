part of bloc;

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class SettingsDarkModeChanged extends SettingsEvent {
  final bool truthy;
  SettingsDarkModeChanged({@required this.truthy}) : assert(truthy != null);
  @override
  List<Object> get props => [truthy];
}

class SettingsState extends Equatable {
  final bool isDarkMode;

  const SettingsState({@required this.isDarkMode});

  @override
  List<Object> get props => [isDarkMode];
}

class SettingsInitial extends SettingsState {
  final bool isDarkMode = false;

  @override
  List<Object> get props => [isDarkMode];
}

class SettingsLoadSuccess extends SettingsState {
  final bool isDarkMode;

  const SettingsLoadSuccess({@required this.isDarkMode})
      : assert(isDarkMode != null);

  @override
  List<Object> get props => [isDarkMode];
}

class SettingsLoadFailure extends SettingsState{}

class SettingsChanged extends SettingsState {
  final bool isDarkMode;

  SettingsChanged({this.isDarkMode});

  @override
  List<Object> get props => [isDarkMode];
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({@required this.repository}) : assert(repository != null);

  @override
  SettingsState get initialState => SettingsInitial();

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsDarkModeChanged) {
      await repository.saveSettings(isDarkMode: event.truthy);
      yield SettingsChanged(isDarkMode: event.truthy);
    }
    if (event is LoadSettings) {
      final _ret = await repository.loadSettings();
      if (_ret != null) {
        yield SettingsLoadSuccess(isDarkMode: _ret['isDarkMode']);
      }
    }
  }
}
