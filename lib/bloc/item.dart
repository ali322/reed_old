part of bloc;

abstract class ItemsEvent extends Equatable {
  const ItemsEvent();
  @override
  List<Object> get props => [];
}

class FetchItems extends ItemsEvent {}

class FindItems extends ItemsEvent {
  final Feed feed;
  final FeedType feedType;

  const FindItems({this.feed, this.feedType = FeedType.All});

  @override
  List<Object> get props => [feed, feedType];
}

abstract class ItemsState extends Equatable {
  final List<Item> items = const [];
  final String category = 'All Items';
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsIntial extends ItemsState {
  final List<Item> items = [];
  final String category = 'All Items';
  @override
  List<Object> get props => [items, category];
}

class ItemsFetchSuccess extends ItemsState {
  final List<Item> items;
  final String category = 'All Items';
  const ItemsFetchSuccess({@required this.items}) : assert(items != null);

  @override
  List<Object> get props => [items, category];
}

class ItemsFindSuccess extends ItemsState {
  final List<Item> items;
  final String category;
  const ItemsFindSuccess({@required this.items, @required this.category})
      : assert(items != null),
        assert(category != null);

  @override
  List<Object> get props => [items, category];
}

class ItemsBloc extends Bloc<ItemsEvent, ItemsState> {
  final ItemRepository repository;

  ItemsBloc({@required this.repository}) : assert(repository != null);

  @override
  ItemsState get initialState => ItemsIntial();

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
    if (event is FetchItems) {
      final items = await repository.fetchItems();
      yield ItemsFetchSuccess(items: items);
    } else if (event is FindItems) {
      final items =
          repository.findItems(feed: event.feed, type: event.feedType);
      yield ItemsFindSuccess(
          items: items,
          category: event.feed != null ? event.feed.title : 'All Items');
    }
  }
}
