part of bloc;

abstract class APIEvent extends Equatable {
  const APIEvent();
  @override
  List<Object> get props => [];
}

class SaveAPICredential extends APIEvent {
  final String title;
  final String apiKey;
  final String baseURL;

  const SaveAPICredential(
      {required this.title, required this.apiKey, required this.baseURL});

  @override
  List<Object> get props => [apiKey, baseURL];
}

class LoadAPICredential extends APIEvent {}

class ResetAPICredential extends APIEvent {}

enum APIStatus {
  Initial,
  CredentialSaveSuccess,
  CredentialSaveFailure,
  CredentialLoadSuccess,
  CredentialLoadFailure,
  CredentialLoading
}

class APIState extends Equatable {
  final APIStatus status;
  final String apiKey;
  final String baseURL;
  final String? title;
  const APIState(
      {this.status = APIStatus.Initial,
      this.apiKey = "",
      this.baseURL = "",
      this.title});
  APIState copyWith(
          {APIStatus? status,
          String? apiKey,
          String? baseURL,
          String? title}) =>
      APIState(
        status: status ?? this.status,
        apiKey: apiKey ?? this.apiKey,
        baseURL: baseURL ?? this.baseURL,
        title: title ?? this.title,
      );
  @override
  List<Object?> get props => [apiKey, baseURL, title, status];
}

class APIBloc extends Bloc<APIEvent, APIState> {
  final APIRepository repository;

  APIBloc({required this.repository}) : super(APIState());

  @override
  Stream<APIState> mapEventToState(APIEvent event) async* {
    if (event is SaveAPICredential) {
      try {
        await repository.saveAPI(
            apiKey: event.apiKey, baseURL: event.baseURL, title: event.title);
        yield state.copyWith(
            status: APIStatus.CredentialSaveSuccess,
            title: event.title,
            apiKey: event.apiKey,
            baseURL: event.baseURL);
      } catch (e) {
        yield state.copyWith(status: APIStatus.CredentialSaveFailure);
      }
    }
    if (event is LoadAPICredential) {
      yield state.copyWith(status: APIStatus.CredentialLoading);
      final _ret = await repository.loadAPI();
      if (_ret != null) {
        yield state.copyWith(
            status: APIStatus.CredentialLoadSuccess,
            title: _ret['title'],
            apiKey: _ret['key'],
            baseURL: _ret['baseURL']);
      } else {
        yield state.copyWith(status: APIStatus.CredentialLoadFailure);
      }
    }
    if (event is ResetAPICredential) {
      await repository.deleteAPI();
      yield state.copyWith(status: APIStatus.Initial);
    }
  }
}
