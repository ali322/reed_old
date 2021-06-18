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

  const FetchEntries(
      {required this.status, required this.limit, required this.direction});
}

class RefreshEntries extends EntriesEvent {
  final EntryStatus status;
  final String direction;
  final int limit;

  const RefreshEntries(
      {required this.status, required this.limit, required this.direction});
}

class SortEntries extends EntriesEvent {
  final String direction;
  final EntryStatus status;
  const SortEntries({required this.direction, required this.status});
}

class SelectEntries extends EntriesEvent {
  final EntryStatus status;
  final String direction;
  final int limit;

  const SelectEntries(
      {required this.status, required this.limit, required this.direction});
}

class ChangeEntriesStatus extends EntriesEvent {
  final List<int> ids;
  final EntryStatus from;
  final EntryStatus to;
  const ChangeEntriesStatus(
      {required this.ids, required this.from, required this.to});
}

class Entries {
  final int total;
  final List<Entry> entries;
  final int offset;
  const Entries({this.total = 0, this.offset = 0, this.entries = const []});
}

enum EntriesStatus {
  Inital,
  FetchSuccess,
  FetchFailure,
  RefreshSuccess,
  SortSuccess,
  ChangeSuccess
}

class EntriesState extends Equatable {
  final EntriesStatus status;
  final Map<EntryStatus, Entries> data;
  const EntriesState(
      {this.status = EntriesStatus.Inital,
      this.data = const <EntryStatus, Entries>{
        EntryStatus.UnReaded: Entries(),
        EntryStatus.All: Entries(),
        EntryStatus.Starred: Entries()
      }});
  EntriesState copyWith(
      {EntriesStatus? status, Map<EntryStatus, Entries>? data}) {
    return EntriesState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }

  @override
  List<Object> get props => [status, data];
}

class EntriesBloc extends Bloc<EntriesEvent, EntriesState> {
  final EntryRepository repository;

  EntriesBloc({required this.repository}) : super(EntriesState());

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
      final _offset = state.data[event.status]!.offset;
      var _next = Map.fromEntries(state.data.entries);
      try {
        final _ret = await repository.fetchEntries(
            status: event.status, offset: _offset, limit: event.limit);
        _next[event.status] = Entries(
          entries: _sort(_ret["rows"], event.direction),
          total: _ret['total'],
          offset: _offset + event.limit,
        );
        yield state.copyWith(status: EntriesStatus.FetchSuccess, data: _next);
      } catch (e) {
        print("===>errrr $e");
        yield state.copyWith(status: EntriesStatus.FetchFailure);
      }
    }
    if (event is RefreshEntries) {
      try {
        final _offset = state.data[event.status]!.offset;
        final _ret = await repository.fetchEntries(
            status: event.status, offset: _offset, limit: event.limit);
        final _entries = state.data[event.status]!.entries.sublist(0)
          ..addAll(_ret['rows']);
        var _next = Map.fromEntries(state.data.entries);
        _next[event.status] = Entries(
          entries: _sort(_entries, event.direction),
          total: _ret['total'],
          offset: _offset + event.limit,
        );
        yield state.copyWith(status: EntriesStatus.RefreshSuccess, data: _next);
      } catch (e) {
        print("===>$e");
        yield state.copyWith(status: EntriesStatus.FetchFailure);
      }
    }
    if (event is SortEntries) {
      var _next = Map.fromEntries(state.data.entries);
      _next[event.status] = Entries(
        entries: _sort(state.data[event.status]!.entries, event.direction),
        total: state.data[event.status]!.total,
        offset: state.data[event.status]!.offset,
      );
      yield state.copyWith(status: EntriesStatus.SortSuccess, data: _next);
    }
    if (event is ChangeEntriesStatus) {
      List<Entry> _entries = state.data[event.from]!.entries.sublist(0);
      await repository.changeEntriesStatus(event.ids, event.to);
      _entries = _entries.map<Entry>((val) {
        if (event.ids.any((id) => id == val.id)) {
          val.status = event.to;
        }
        return val;
      }).toList();
      var _next = Map.fromEntries(state.data.entries);
      _next[event.from] = Entries(
        entries: _entries,
        total: state.data[event.from]!.total,
        offset: state.data[event.from]!.offset,
      );
      yield state.copyWith(status: EntriesStatus.ChangeSuccess, data: _next);
    }
  }
}
