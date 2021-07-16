part of bloc;

abstract class FeedsEvent extends Equatable {
  const FeedsEvent();
  @override
  List<Object> get props => [];
}

class FetchFeeds extends FeedsEvent {}

class FetchFeedsIcon extends FeedsEvent {
  final List<Feed> feeds;
  const FetchFeedsIcon({required this.feeds});
  @override
  List<Object> get props => [feeds];
}

class CalculateFeeds extends FeedsEvent {
  final List<Entry> entries;
  const CalculateFeeds({required this.entries});
  @override
  List<Object> get props => [entries];
}

enum FeedsStatus {
  Inital,
  FetchSuccess,
  FetchFailure,
  IconFetchSuccess,
  Calculating,
  CalculateSuccess
}

class FeedsState extends Equatable {
  final FeedsStatus status;
  final List<Category> categories;
  const FeedsState(
      {this.status = FeedsStatus.Inital, this.categories = const []});

  FeedsState copyWith({FeedsStatus? status, List<Category>? categories}) {
    return FeedsState(
        status: status ?? this.status,
        categories: categories ?? this.categories);
  }

  @override
  List<Object> get props => [status, categories];
}

class FeedsBloc extends Bloc<FeedsEvent, FeedsState> {
  final FeedRepository repository;

  FeedsBloc({required this.repository}) : super(FeedsState());

  @override
  Stream<FeedsState> mapEventToState(FeedsEvent event) async* {
    if (event is FetchFeeds) {
      try {
        List<Category> categories = await repository.fetchCategories();
        yield state.copyWith(
            status: FeedsStatus.FetchSuccess, categories: categories);
      } catch (e) {
        print(e);
        yield state.copyWith(status: FeedsStatus.FetchFailure);
      }
    }
    if (event is FetchFeedsIcon) {
      List<int> _ids = [];
      // for (var _category in state.categories) {
      //   _ids.addAll(_category.feeds.map<int>((val) => val.id).toList());
      // }
      for (var _feed in event.feeds) {
        if(_feed.icon == null) {
          _ids.add(_feed.id);
        }
      }
      final _ret = await repository.fetchFeedIcon(_ids.sublist(0));
      List<Category> _next = state.categories.sublist(0);
      _next = _next.map<Category>((val) {
        val.feeds = val.feeds.map<Feed>((feed) {
          if (_ret[feed.id] != null) {
            feed.icon = _ret[feed.id];
          }
          return feed;
        }).toList();
        return val;
      }).toList();
      yield state.copyWith(
          status: FeedsStatus.IconFetchSuccess, categories: _next);
    }
    if (event is CalculateFeeds) {
      final _categories = state.categories;
      yield state.copyWith(status: FeedsStatus.Calculating);
      final _next = repository.calculateFeeds(_categories, event.entries);
      yield state.copyWith(
          status: FeedsStatus.CalculateSuccess, categories: _next);
    }
  }
}
