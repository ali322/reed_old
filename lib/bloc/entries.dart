part of bloc;

abstract class EntriesEvent extends Equatable {
  const EntriesEvent();
  @override
  List<Object> get props => [];
}

class FetchEntries extends EntriesEvent {
  final EntryStatus status;
  final String direction;
  final int limit;

  const FetchEntries({this.status, this.limit, this.direction});
}

class RefreshEntries extends EntriesEvent {
  final EntryStatus status;
  final String direction;
  final int limit;

  const RefreshEntries({this.status, this.limit, this.direction});
}

class SortEntries extends EntriesEvent {
  final String direction;
  final EntryStatus status;
  const SortEntries({@required this.direction, @required this.status})
      : assert(direction != null),
        assert(status != null);
}

class SelectEntries extends EntriesEvent {
  final EntryStatus status;
  final String direction;
  final int limit;

  const SelectEntries({this.status, this.limit, this.direction});
}

class ChangeEntriesStatus extends EntriesEvent {
  final List<int> ids;
  final EntryStatus status;
  const ChangeEntriesStatus({@required this.ids, @required this.status})
      : assert(ids != null),
        assert(status != null);
}

class Entries {
  final int total;
  final List<Entry> entries;
  final int offset;
  const Entries({this.total = 0, this.offset = 0, this.entries = const []});
}

abstract class EntriesState extends Equatable {
  final Map<EntryStatus, Entries> data;
  const EntriesState({@required this.data});
  @override
  List<Object> get props => [data];
}

class EntriesIntial extends EntriesState {
  final Map<EntryStatus, Entries> data;
  const EntriesIntial(
      {this.data = const <EntryStatus, Entries>{
        EntryStatus.UnReaded: Entries(),
        EntryStatus.All: Entries(),
        EntryStatus.Starred: Entries()
      }});

  @override
  List<Object> get props => [data];
}

class EntriesFetching extends EntriesState {}

class EntriesFetchSuccess extends EntriesState {
  final Map<EntryStatus, Entries> data;
  const EntriesFetchSuccess({@required this.data}) : assert(data != null);
  @override
  List<Object> get props => [data];
}

class EntriesFetchFailure extends EntriesState {}

class EntriesRefreshSuccess extends EntriesState {
  final Map<EntryStatus, Entries> data;
  const EntriesRefreshSuccess({@required this.data}) : assert(data != null);
  @override
  List<Object> get props => [data];
}

class EntriesSortSuccess extends EntriesState {
  final Map<EntryStatus, Entries> data;
  const EntriesSortSuccess({@required this.data}) : assert(data != null);
  @override
  List<Object> get props => [data];
}

class EntriesChangeSuccess extends EntriesState {
  final Map<EntryStatus, Entries> data;
  const EntriesChangeSuccess({@required this.data}) : assert(data != null);
  @override
  List<Object> get props => [data];
}

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  final EntryRepository repository;

  EntriesBloc({@required this.repository})
      : assert(repository != null),
        super(EntriesIntial());

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
      final _offset = state.data[event.status].offset;
      var _next = Map.fromEntries(state.data.entries);
      yield EntriesFetching();
        try {
          final _ret = await repository.fetchEntries(
              status: event.status, offset: _offset, limit: event.limit);
          _next[event.status] = Entries(
            entries: _sort(_ret["rows"], event.direction),
            total: _ret['total'],
            offset: _offset + event.limit,
          );
          yield EntriesFetchSuccess(data: _next);
        } catch (e) {
          print("===>$e");
          yield EntriesFetchFailure();
        }
    }
    if (event is RefreshEntries) {
      try {
        final _offset = state.data[event.status].offset;
        final _ret = await repository.fetchEntries(
            status: event.status, offset: _offset, limit: event.limit);
        final _entries = state.data[event.status].entries.sublist(0)
          ..addAll(_ret['rows']);
        var _next = Map.fromEntries(state.data.entries);
        _next[event.status] = Entries(
          entries: _sort(_entries, event.direction),
          total: _ret['total'],
          offset: _offset + event.limit,
        );
        yield EntriesRefreshSuccess(data: _next);
      } catch (e) {
        print("===>$e");
        yield EntriesFetchFailure();
      }
    }
    if (event is SortEntries) {
      var _next = Map.fromEntries(state.data.entries);
      _next[event.status] = Entries(
        entries: _sort(state.data[event.status].entries, event.direction),
        total: state.data[event.status].total,
        offset: state.data[event.status].offset,
      );
      yield EntriesSortSuccess(data: _next);
    }
    if (event is ChangeEntriesStatus) {
      List<Entry> _entries = state.data[event.status].entries.sublist(0);
      await repository.changeEntriesStatus(event.ids, event.status);
      _entries = _entries.map<Entry>((val) {
        if (event.ids.any((id) => id == val.id)) {
          val.status = event.status;
        }
        return val;
      }).toList();
      var _next = Map.fromEntries(state.data.entries);
      _next[event.status] = Entries(
        entries: _entries,
        total: state.data[event.status].total,
        offset: state.data[event.status].offset,
      );
      yield EntriesChangeSuccess(data: _next);
    }
  }
}
