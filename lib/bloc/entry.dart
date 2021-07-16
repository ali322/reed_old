part of bloc;

abstract class EntryEvent extends Equatable {
  const EntryEvent();
  @override
  List<Object> get props => [];
}

class FetchEntry extends EntryEvent {
  final int id;
  FetchEntry({required this.id});
  @override
  List<Object> get props => [id];
}

enum EntryStateStatus{
  Inital,
  FetchSuccess,
  FetchFailure
}

class EntryState extends Equatable{
  final EntryStateStatus status;
  final Entry? entry;
  List<Object?> get props => [entry];
  EntryState({this.status = EntryStateStatus.Inital, this.entry});
  EntryState copyWith({EntryStateStatus? status, Entry? entry}) => EntryState(
    status: status ?? this.status,
    entry: entry ?? this.entry
  );
}

class EntryBloc extends Bloc<EntryEvent, EntryState> {
  final EntryRepository repository;

  EntryBloc({required this.repository})
      : super(EntryState());

  @override
  Stream<EntryState> mapEventToState(EntryEvent event) async* {
    if (event is FetchEntry) {
      try {
        final _ret = await repository.fetchEntry(id: event.id);
        yield state.copyWith( status: EntryStateStatus.FetchSuccess,entry: _ret);
      } catch (e) {
        yield state.copyWith(status: EntryStateStatus.FetchFailure);
      }
    }
  }
}
