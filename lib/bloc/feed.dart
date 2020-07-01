part of bloc;

enum FeedsEvent { FetchFeeds }

abstract class FeedsState extends Equatable {
  const FeedsState();

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

class FeedsBloc extends Bloc<FeedsEvent, FeedsState> {
  final FeedRepository repository;

  FeedsBloc({@required this.repository}) : assert(repository != null);

  @override
  FeedsState get initialState => FeedsInitial();

  @override
  Stream<FeedsState> mapEventToState(FeedsEvent event) async* {
    if (event == FeedsEvent.FetchFeeds) {
      try {
        List<Category> categories = await repository.fetchCategories();
        yield FeedsFetchSuccess(categories: categories);
      } catch (e) {
        yield FeedsFetchFailure();
      }
    }
  }
}
