part of bloc;

abstract class APIEvent extends Equatable {
  const APIEvent();
  @override
  List<Object> get props => [];
}

class SaveAPICredential extends APIEvent {
  final String apiKey;
  final String baseURL;

  const SaveAPICredential({@required this.apiKey, @required this.baseURL})
      : assert(apiKey != null),
        assert(baseURL != null);

  @override
  List<Object> get props => [apiKey, baseURL];
}

class LoadAPICredential extends APIEvent {}

abstract class APIState extends Equatable {
  const APIState();
  @override
  List<Object> get props => [];
}

class APIInitial extends APIState {}

class APICredentialSaveSuccess extends APIState {
  final String apiKey;
  final String baseURL;

  const APICredentialSaveSuccess(
      {@required this.apiKey, @required this.baseURL})
      : assert(apiKey != null),
        assert(baseURL != null);

  @override
  List<Object> get props => [apiKey, baseURL];
}

class APICredentialSaveFailure extends APIState {}

class APICredentialLoadSuccess extends APIState {
  final String apiKey;
  final String baseURL;

  const APICredentialLoadSuccess(
      {@required this.apiKey, @required this.baseURL})
      : assert(apiKey != null),
        assert(baseURL != null);

  @override
  List<Object> get props => [apiKey, baseURL];
}

class APICredentialLoadFailure extends APIState {}

class APICredentialLoading extends APIState {}

class APIBloc extends Bloc<APIEvent, APIState> {
  final APIRepository repository;

  APIBloc({@required this.repository}) : assert(repository != null);

  @override
  APIState get initialState => APIInitial();

  @override
  Stream<APIState> mapEventToState(APIEvent event) async* {
    if (event is SaveAPICredential) {
      try {
        await repository.saveAPIKey(event.apiKey, event.baseURL);
        yield APICredentialSaveSuccess(
            apiKey: event.apiKey, baseURL: event.baseURL);
      } catch (e) {
        yield APICredentialSaveFailure();
      }
    }
    if (event is LoadAPICredential) {
      yield APICredentialLoading();
      final _ret = await repository.loadAPIKey();
      if (_ret != null) {
        yield APICredentialLoadSuccess(
            apiKey: _ret['key'], baseURL: _ret['baseURL']);
      } else {
        yield APICredentialLoadFailure();
      }
    }
  }
}
