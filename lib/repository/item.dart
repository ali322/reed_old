part of repository;

enum FeedType { UnReaded, Saved, All }

class ItemRepository extends Repository {
  final String apiKey;
  final String baseURL;

  List<Item> items = [];

  ItemRepository({@required this.apiKey, @required this.baseURL})
      : assert(apiKey != null),
        assert(baseURL != null);

  Future<List<Item>> fetchItems() async {
    List<Item> _all = [];
    for (var i = 0; i < 3; i++) {
      http.Response ret = await this.httpClient.post(
          '$baseURL?api&items&since_id=${i * 50 + 1}',
          body: {'api_key': apiKey});
      if (ret.statusCode != 200) {
        throw ("fetch items failed");
      } else {
        ret.headers['content-type'] = 'application/json;charset=utf-8';
        var decoded = json.decode(ret.body) as Map<String, dynamic>;
        List<Item> _items =
            decoded["items"].map<Item>((v) => Item.fromJSON(v)).toList();
        _all.addAll(_items);
      }
    }
    _all.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    this.items.addAll(_all);
    return this.items;
  }

  List<Item> findItems({Feed feed, FeedType type}) {
    var _next = this.items.sublist(0);
    // print('<===${_next.map((v) => v.id).toList()}');
    print('${_next.length}');
    if (feed != null) {
      _next = _next.where((v) => v.feedID == feed.id).toList();
    }
    if (_next.length > 0) {
      print('==>${_next[0].title} ${_next[0].id} ${_next[0].feedID}');
    }
    if (type == FeedType.UnReaded) {
      _next = _next.where((v) => v.isRead == false).toList();
    }
    if (type == FeedType.Saved) {
      _next = _next.where((v) => v.isSaved == true).toList();
    }
    return _next;
  }
}
