part of repository;

class FeedRepository {
  final String apiKey;
  final String baseURL;

  FeedRepository({required this.apiKey, required this.baseURL});

  Future<List<Category>> fetchCategories() async {
    http.Response ret = await APIClient(apiKey).get(Uri.parse('$baseURL/categories'));
    if (ret.statusCode != 200) {
      throw ("fetch categories failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body);
      List<Category> _categories =
          decoded.map<Category>((v) => Category.fromJSON(v)).toList();
      final _feeds = await fetchFeeds();
      _categories = _categories.map((_category) {
        _category.feeds =
            _feeds.where((v) => v.categoryID == _category.id).toList();
        return _category;
      }).toList();
      return _categories;
    }
  }

  Future<List<Feed>> fetchFeeds() async {
    http.Response ret = await APIClient(apiKey).get(Uri.parse('${this.baseURL}/feeds'));
    if (ret.statusCode != 200) {
      throw ("fetch feeds failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body);
      return decoded.map<Feed>((v) => Feed.fromJSON(v)).toList();
    }
  }

  Future<Map<int, dynamic>> fetchFeedIcon(List<int> ids) async {
    Map<int, dynamic> _next = {};
    for (var id in ids) {
      final _ret =
          await APIClient(apiKey).get(Uri.parse('${this.baseURL}/feeds/$id/icon'));
      if (_ret.statusCode == 200) {
        var decoded = json.decode(_ret.body) as Map<String, dynamic>;
        _next[decoded['id']] = decoded['data'];
      }
    }
    return _next;
  }

  List<Category> calculateFeeds(
      List<Category> categories, List<Entry> entries) {
    List<Category> _next = categories.sublist(0);
    Map<int, int> _countOfFeeds = {};
    for (var entry in entries) {
      if (_countOfFeeds[entry.feedID] != null) {
        _countOfFeeds[entry.feedID] = _countOfFeeds[entry.feedID]! + 1;
      } else {
        _countOfFeeds[entry.feedID] = 1;
      }
    }
    int _amount = 0;
    _next = _next.map<Category>((category) {
      category.feeds = category.feeds.map((feed) {
        feed.count = _countOfFeeds[feed.id] ?? 0;
        _amount += feed.count;
        return feed;
      }).toList();
      return category;
    }).toList();
    _next[0].count = _amount;
    return _next;
  }
}
