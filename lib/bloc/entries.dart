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
  final String direction;
  final int limit;

  const FetchEntries(
      {this.feed, this.status, this.search, this.limit, this.direction});
}

class RefreshEntries extends EntriesEvent {
  final Feed feed;
  final EntryStatus status;
  final String direction;
  final int limit;

  const RefreshEntries({this.feed, this.status, this.limit, this.direction});
}

class SortEntries extends EntriesEvent {
  final String direction;
  const SortEntries({@required this.direction}) : assert(direction != null);
}

class ChangeEntriesStatus extends EntriesEvent {
  final List<int> ids;
  final String status;
  const ChangeEntriesStatus({@required this.ids, @required this.status})
      : assert(ids != null),
        assert(status != null);
}

abstract class EntriesState extends Equatable {
  final int total;
  final List<Entry> entries;
  final int offset;
  const EntriesState(
      {this.entries = const [], this.total = 0, this.offset = 0});

  @override
  List<Object> get props => [entries, total, offset];
}

class EntriesIntial extends EntriesState {}

class EntriesFetching extends EntriesState {}

class EntriesFetchSuccess extends EntriesState {
  final List<Entry> entries;
  final int total;
  final int offset;
  const EntriesFetchSuccess(
      {@required this.entries, @required this.total, @required this.offset})
      : assert(entries != null),
        assert(offset != null),
        assert(total != null);

  @override
  List<Object> get props => [entries, total, offset];
}

class EntriesFetchFailure extends EntriesState {}

class EntriesRefreshSuccess extends EntriesState {
  final List<Entry> entries;
  final int total;
  final int offset;
  const EntriesRefreshSuccess(
      {@required this.entries, @required this.total, @required this.offset})
      : assert(entries != null),
        assert(offset != null),
        assert(total != null);
  @override
  List<Object> get props => [entries, total, offset];
}

class EntriesSortSuccess extends EntriesState {
  final List<Entry> entries;
  final int total;
  final int offset;
  const EntriesSortSuccess(
      {@required this.entries, @required this.total, @required this.offset})
      : assert(entries != null),
        assert(offset != null),
        assert(total != null);
  @override
  List<Object> get props => [entries, total, offset];
}

class EntriesChangeSuccess extends EntriesState {
  final List<Entry> entries;
  final int total;
  final int offset;
  const EntriesChangeSuccess(
      {@required this.entries, @required this.total, @required this.offset})
      : assert(entries != null),
        assert(offset != null),
        assert(total != null);
  @override
  List<Object> get props => [entries, total, offset];
}

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  final EntryRepository repository;

  EntriesBloc({@required this.repository}) : assert(repository != null);

  @override
  EntriesState get initialState => EntriesIntial();

  List<Entry> _sort(List<Entry> entries, String direction) {
    List<Entry> _next = entries.sublist(0);
    _next.sort((a, b) {
      return direction == 'asc'
          ? DateTime.parse(a.publishedAt)
              .compareTo(DateTime.parse(b.publishedAt))
          : DateTime.parse(b.publishedAt)
              .compareTo(DateTime.parse(a.publishedAt));
    });
    return _next;
  }

  // int _now() {
  //   return (DateTime.now().toUtc().millisecondsSinceEpoch / 1000).round();
  // }

  @override
  Stream<EntriesState> mapEventToState(EntriesEvent event) async* {
    if (event is FetchEntries) {
      yield EntriesFetching();
      try {
        final _ret = await repository.fetchEntries(
            feed: event.feed,
            status: event.status,
            search: event.search,
            offset: state.offset,
            limit: event.limit);
        yield EntriesFetchSuccess(
            entries: _sort(_ret['rows'], event.direction),
            total: _ret['total'],
            offset: state.offset + event.limit);
      } catch (e) {
        yield EntriesFetchFailure();
      }
    }
    if (event is RefreshEntries) {
      try {
        final _ret = await repository.fetchEntries(
            feed: event.feed,
            status: event.status,
            offset: state.offset,
            limit: event.limit);
        final _next = state.entries.sublist(0)..addAll(_ret['rows']);
        final _offset = state.offset + event.limit;
        yield EntriesRefreshSuccess(
            entries: _sort(_next, event.direction), total: _ret['total'], offset: _offset);
      } catch (e) {
        yield EntriesFetchFailure();
      }
    }
    if (event is SortEntries) {
      yield EntriesSortSuccess(
          entries: _sort(state.entries, event.direction), total: state.total, offset: state.offset);
    }
    if (event is ChangeEntriesStatus) {
      List<Entry> _next = state.entries.sublist(0);
      await repository.changeEntriesStatus(event.ids, event.status);
      _next = _next.map<Entry>((val) {
        if (event.ids.any((id) => id == val.id)) {
          val.status = event.status;
        }
        return val;
      }).toList();
      yield EntriesChangeSuccess(
          entries: _next, total: state.total, offset: state.offset);
    }
  }
}
