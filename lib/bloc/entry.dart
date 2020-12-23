part of bloc;

abstract class EntryEvent extends Equatable {
  const EntryEvent();
  @override
  List<Object> get props => [];
}

class FetchEntry extends EntryEvent {
  final int id;
  FetchEntry({@required this.id}) : assert(id != null);
  @override
  List<Object> get props => [id];
}

abstract class EntryState extends Equatable {
  const EntryState();

  @override
  List<Object> get props => [];
}

class EntryIntial extends EntryState {
  final Entry entry = null;
  @override
  List<Object> get props => [entry];
}

class EntryFetchSuccess extends EntryState {
  final Entry entry;
  const EntryFetchSuccess({@required this.entry}) : assert(entry != null);

  @override
  List<Object> get props => [entry];
}

class EntryFetchFailure extends EntryState {}

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  final EntryRepository repository;

  EntryBloc({@required this.repository})
      : assert(repository != null),
        super(EntryIntial());

  @override
  Stream<EntryState> mapEventToState(EntryEvent event) async* {
    if (event is FetchEntry) {
      try {
        final _ret = await repository.fetchEntry(id: event.id);
        yield EntryFetchSuccess(entry: _ret);
      } catch (e) {
        yield EntryFetchFailure();
      }
    }
  }
}
