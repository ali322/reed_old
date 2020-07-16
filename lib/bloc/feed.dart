part of bloc;

abstract class FeedsEvent extends Equatable {
  const FeedsEvent();
  @override
  List<Object> get props => [];
}

class FetchFeeds extends FeedsEvent {}

class FetchFeedsIcon extends FeedsEvent {}

class CalculateUnreadEntries extends FeedsEvent {
  final List<Entry> entries;
  const CalculateUnreadEntries({@required this.entries});
  @override
  List<Object> get props => [entries];
}

abstract class FeedsState extends Equatable {
  final List<Category> categories;
  const FeedsState({@required this.categories});

  @override
  List<Object> get props => [];
}

class FeedsInitial extends FeedsState {
  final List<Category> categories = [];
  @override
  List<Object> get props => [categories];
}

class FeedsFetchSuccess extends FeedsState {
  final List<Category> categories;
  const FeedsFetchSuccess({@required this.categories})
      : assert(categories != null);

  @override
  List<Object> get props => [categories];
}

class FeedsFetchFailure extends FeedsState {}

class FeedsIconFetchSuccess extends FeedsState {
  final List<Category> categories;
  const FeedsIconFetchSuccess({@required this.categories})
      : assert(categories != null);

  @override
  List<Object> get props => [categories];
}

class FeedsCalculateSuccess extends FeedsState {
  final List<Category> categories;
  const FeedsCalculateSuccess({@required this.categories})
      : assert(categories != null);

  @override
  List<Object> get props => [categories];
}

class FeedsBloc extends Bloc<FeedsEvent, FeedsState> {
  final FeedRepository repository;

  FeedsBloc({@required this.repository}) : assert(repository != null);

  @override
  FeedsState get initialState => FeedsInitial();

  @override
  Stream<FeedsState> mapEventToState(FeedsEvent event) async* {
    if (event is FetchFeeds) {
      try {
        List<Category> categories = await repository.fetchCategories();
        yield FeedsFetchSuccess(categories: categories);
      } catch (e) {
        print(e);
        yield FeedsFetchFailure();
      }
    }
    if (event is FetchFeedsIcon) {
      List<int> _ids = [];
      for (var _category in state.categories) {
        _ids.addAll(_category.feeds.map<int>((val) => val.id).toList());
      }
      final _ret = await repository.fetchFeedIcon(_ids);
      List<Category> _next = state.categories.sublist(0);
      _next = _next.map<Category>((val) {
        val.feeds = val.feeds.map<Feed>((feed) {
          feed.icon = _ret[feed.id];
          return feed;
        }).toList();
        return val;
      }).toList();
      yield FeedsIconFetchSuccess(categories: _next);
    }
    if (event is CalculateUnreadEntries) {
      final _next =
          repository.calculateUnreadEntries(state.categories, event.entries);
      yield FeedsCalculateSuccess(categories: _next);
    }
  }
}
