part of bloc;

abstract class SettingsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class SettingsChanged extends SettingsEvent {
  final String key;
  final dynamic value;
  SettingsChanged({required this.key, required this.value});
  @override
  List<Object> get props => [key, value];
}

enum SettingsStatus { Initial, LoadSuccess, LoadFailure, ChangeSuccess }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final Map<String, dynamic>? values;
  final String? key;
  final dynamic value;
  const SettingsState(
      {this.status = SettingsStatus.Initial,
      this.values = const {
        'isDarkMode': false,
        'language': 'English',
        'fetchPertime': 50,
        'fontSize': 14.0,
        'letterSpacing': 0.0,
        'bold': false
      },
      this.key,
      this.value});
  SettingsState copyWith(
          {SettingsStatus? status,
          Map<String, dynamic>? values,
          String? key,
          dynamic value}) =>
      SettingsState(
          status: status ?? this.status,
          values: values ?? this.values,
          key: key ?? this.key,
          value: value);
  @override
  List<Object?> get props => [key, value, values];
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository repository;

  SettingsBloc({required this.repository}) : super(SettingsState());

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is SettingsChanged) {
      final _next = await repository.saveSettings(
          key: event.key, value: event.value, values: state.values!);
      yield state.copyWith(
          status: SettingsStatus.ChangeSuccess,
          key: event.key,
          value: event.value,
          values: _next);
    }
    if (event is LoadSettings) {
      final _ret = await repository.loadSettings();
      if (_ret != null) {
        yield state.copyWith(status: SettingsStatus.LoadSuccess, values: _ret);
      }
    }
  }
}
