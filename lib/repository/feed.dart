part of repository;

class FeedRepository {
  final String apiKey;
  final String baseURL;

  FeedRepository({@required this.apiKey, @required this.baseURL})
      : assert(apiKey != null),
        assert(baseURL != null);

  Future<List<Category>> fetchCategories() async {
    http.Response ret = await APIClient(apiKey).get('$baseURL/categories');
    if (ret.statusCode != 200) {
      throw ("fetch categories failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body);
      List<Category> _categories =
          decoded.map<Category>((v) => Category.fromJSON(v)).toList();
      var _feeds = await fetchFeeds();
      _categories = _categories.map((_category) {
        _category.feeds =
            _feeds.where((v) => v.categoryID == _category.id).toList();
        return _category;
      }).toList();
      return _categories;
    }
  }

  Future<List<Feed>> fetchFeeds() async {
    http.Response ret = await APIClient(apiKey).get('${this.baseURL}/feeds');
    if (ret.statusCode != 200) {
      throw ("fetch feeds failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body);
      return decoded.map<Feed>((v) => Feed.fromJSON(v)).toList();
    }
  }

  Future<String> fetchFeedIcon(int id) async {
    http.Response ret =
        await APIClient(apiKey).get('${this.baseURL}/feeds/$id/icon');
    if (ret.statusCode != 200) {
      throw ("fetch feed icon failed");
    } else {
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      return decoded['data'];
    }
  }
}
