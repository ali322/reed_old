part of bloc;

abstract class EntriesEvent extends Equatable {
  const EntriesEvent();
  @override
  List<Object> get props => [];
}

class FetchEntries extends EntriesEvent {
  final Feed feed;
  final EntryStatus status;
  final String search;

  const FetchEntries({this.feed, this.status, this.search});
}

class RefreshEntries extends EntriesEvent {
  final Feed feed;
  final int lastRefreshedAt;

  const RefreshEntries({this.feed, this.lastRefreshedAt});
}

class SortEntries extends EntriesEvent {
  final String direction;
  const SortEntries({@required this.direction}) : assert(direction != null);
}

abstract class EntriesState extends Equatable {
  final int total;
  final List<Entry> entries;
  final int lastFetchedAt;
  const EntriesState({this.entries, this.total, this.lastFetchedAt});

  @override
  List<Object> get props => [entries, total, lastFetchedAt];
}

class EntriesIntial extends EntriesState {}

class EntriesFetching extends EntriesState {}

class EntriesFetchSuccess extends EntriesState {
  final List<Entry> entries;
  final int total;
  final int lastFetchedAt;
  const EntriesFetchSuccess(
      {@required this.entries,
      @required this.total,
      @required this.lastFetchedAt})
      : assert(entries != null),
        assert(lastFetchedAt != null),
        assert(total != null);

  @override
  List<Object> get props => [entries, total, lastFetchedAt];
}

class EntriesFetchFailure extends EntriesState {}

class EntriesRefreshSuccess extends EntriesState {
  final List<Entry> entries;
  final int total;
  final int lastFetchedAt;
  const EntriesRefreshSuccess(
      {@required this.entries,
      @required this.total,
      @required this.lastFetchedAt})
      : assert(entries != null),
        assert(lastFetchedAt != null),
        assert(total != null);
  @override
  List<Object> get props => [entries, total, lastFetchedAt];
}

class EntriesSortSuccess extends EntriesState {
  final List<Entry> entries;
  final int total;
  final int lastFetchedAt;
  const EntriesSortSuccess(
      {@required this.entries,
      @required this.total,
      @required this.lastFetchedAt})
      : assert(entries != null),
        assert(lastFetchedAt != null),
        assert(total != null);
  @override
  List<Object> get props => [entries, total, lastFetchedAt];
}

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  final EntryRepository repository;

  EntriesBloc({@required this.repository}) : assert(repository != null);

  @override
  EntriesState get initialState => EntriesIntial();

  int _now() {
    return (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).round();
  }

  @override
  Stream<EntriesState> mapEventToState(EntriesEvent event) async* {
    if (event is FetchEntries) {
      yield EntriesFetching();
      try {
        final _ret = await repository.fetchEntries(
            feed: event.feed, status: event.status, search: event.search);
        yield EntriesFetchSuccess(
            entries: _ret['rows'], total: _ret['total'], lastFetchedAt: _now());
      } catch (e) {
        yield EntriesFetchFailure();
      }
    }
    if (event is RefreshEntries) {
      try {
        final _ret = await repository.fetchEntries(
            feed: event.feed, lastRefreshedAt: state.lastFetchedAt);
        final _next = _ret['rows']..addAll(state.entries.sublist(0));
        yield EntriesRefreshSuccess(
            entries: _next, total: _ret['total'], lastFetchedAt: _now());
      } catch (e) {
        yield EntriesFetchFailure();
      }
    }
    if (event is SortEntries) {
      List<Entry> _next = state.entries.sublist(0);
      _next.sort((a, b) {
        return event.direction == 'asc'? DateTime.parse(a.publishedAt)
            .compareTo(DateTime.parse(b.publishedAt)) : DateTime.parse(b.publishedAt)
            .compareTo(DateTime.parse(a.publishedAt));
      });
      print(_next.map((e) => e.publishedAt).toList());
      yield EntriesSortSuccess(
          entries: _next,
          total: state.total,
          lastFetchedAt: state.lastFetchedAt);
    }
  }
}
