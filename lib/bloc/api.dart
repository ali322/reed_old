part of bloc;

abstract class APIEvent extends Equatable {
  const APIEvent();
  @override
  List<Object> get props => [];
}

class VerifyAPI extends APIEvent {
  final String baseURL;
  final String username;
  final String password;

  const VerifyAPI(
      {@required this.baseURL,
      @required this.username,
      @required this.password})
      : assert(baseURL != null),
        assert(password != null),
        assert(username != null);

  @override
  List<Object> get props => [baseURL, username, password];
}

class LoadAPI extends APIEvent {}

abstract class APIState extends Equatable {
  const APIState();
  @override
  List<Object> get props => [];
}

class APIInitial extends APIState {}

class APIVerifySuccess extends APIState {
  final String baseURL;
  final String apiKey;

  const APIVerifySuccess({@required this.baseURL, @required this.apiKey})
      : assert(baseURL != null),
        assert(apiKey != null);

  @override
  List<Object> get props => [baseURL, apiKey];
}

class APIVerifyFailure extends APIState {}

class APILoadSuccess extends APIState {
  final String baseURL;
  final String apiKey;

  const APILoadSuccess({@required this.baseURL, @required this.apiKey})
      : assert(baseURL != null),
        assert(apiKey != null);

  @override
  List<Object> get props => [baseURL, apiKey];
}

class APILoadFailure extends APIState {}

class APIBloc extends Bloc<APIEvent, APIState> {
  final APIRepository repository;

  APIBloc({@required this.repository}) : assert(repository != null);

  @override
  APIState get initialState => APIInitial();

  @override
  Stream<APIState> mapEventToState(APIEvent event) async* {
    if (event is VerifyAPI) {
      final _bytes = utf8.encode('${event.username}:${event.password}');
      final _key = md5.convert(_bytes).bytes.toString();
      final _isValid = await repository.fetchAPI(event.baseURL, _key);
      if (_isValid) {
        yield APIVerifySuccess(baseURL: event.baseURL, apiKey: _key);
      } else {
        yield APIVerifyFailure();
      }
    }
    if (event is LoadAPI) {
      final _ret = await repository.loadAPI();
      if (_ret != null) {
        yield APILoadSuccess(baseURL: _ret["baseURL"], apiKey: _ret["key"]);
      } else {
        yield APILoadFailure();
      }
    }
  }
}
