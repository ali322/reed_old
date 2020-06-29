part of bloc;

enum FeedsEvent { FetchFeeds }

abstract class FeedsState extends Equatable {
  const FeedsState();

  @override
  List<Object> get props => [];
}

class FeedsInitial extends FeedsState {
  final List<Feed> feeds = [];
  final List<Group> groups = [];
  @override
  List<Object> get props => [feeds, groups];
}

class FeedsFetchSuccess extends FeedsState {
  final List<Feed> feeds;
  final List<Group> groups;
  const FeedsFetchSuccess({@required this.feeds, @required this.groups})
      : assert(feeds != null),
        assert(groups != null);

  @override
  List<Object> get props => [feeds, groups];
}

class FeedsBloc extends Bloc<FeedsEvent, FeedsState> {
  final FeedRepository repository;

  FeedsBloc({@required this.repository}) : assert(repository != null);

  @override
  FeedsState get initialState => FeedsInitial();

  @override
  Stream<FeedsState> mapEventToState(FeedsEvent event) async* {
    if (event == FeedsEvent.FetchFeeds) {
      List<Group> groups = await repository.fetchGroups();
      List<Feed> feeds = await repository.fetchFeeds();
      final favicons = await repository.fetchFavicons();
      feeds = feeds.map<Feed>((feed) {
        Favicon favicon =
            favicons.singleWhere((favicon) => favicon.id == feed.faviconID);
        feed.favicon = favicon.data;
        return feed;
      }).toList();
      yield FeedsFetchSuccess(feeds: feeds, groups: groups);
    }
  }
}
