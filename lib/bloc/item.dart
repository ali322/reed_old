part of bloc;

abstract class ItemsEvent extends Equatable{
  const ItemsEvent();
  @override
  List<Object> get props => [];
}

class FetchItems extends ItemsEvent{}

abstract class ItemsState extends Equatable{
  const ItemsState();

  @override
  List<Object> get props => [];
}

class ItemsIntial extends ItemsState{
  final List<Item> items = [];
  @override
  List<Object> get props => [items];
}

class ItemsFetchSuccess extends ItemsState{
  final List<Item> items;
  const ItemsFetchSuccess({@required this.items}): assert(items != null);

  @override
  List<Object> get props => [items];
}

class ItemsBloc extends Bloc<ItemsEvent, ItemsState>{
  final ItemRepository repository;

  ItemsBloc({@required this.repository}):assert(repository != null);

  @override
  ItemsState get initialState => ItemsIntial();

  @override
  Stream<ItemsState> mapEventToState(ItemsEvent event) async* {
    if (event is FetchItems) {
      final items = await repository.fetchItems();
      yield ItemsFetchSuccess(items: items);
    }
  }
}