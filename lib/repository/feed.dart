part of repository;

class FeedRepository extends Repository {
  final String apiKey;
  final String baseURL;

  FeedRepository({@required this.apiKey, @required this.baseURL})
      : assert(apiKey != null),
        assert(baseURL != null);

  Future<List<Group>> fetchGroups() async {
    http.Response ret = await this
        .httpClient
        .post('$baseURL?api&groups', body: {'api_key': apiKey});
    if (ret.statusCode != 200) {
      throw ("fetch groups failed");
    } else {
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      List<Group> _groups = decoded['groups'].map<Group>((v) {
        Group _group = Group.fromJSON(v);
        if (_group.title != 'All') {
          _group.feeds = Group.groupFeeds(decoded['feeds_groups'], _group.id);
        }
        return _group;
      }).toList();
      return _groups.toList();
    }
  }

  Future<List<Feed>> fetchFeeds() async {
    http.Response ret = await this
        .httpClient
        .post('${this.baseURL}?api&feeds', body: {'api_key': apiKey});
    if (ret.statusCode != 200) {
      throw ("fetch feeds failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      return decoded["feeds"].map<Feed>((v) => Feed.fromJSON(v)).toList();
    }
  }

  Future<List<Favicon>> fetchFavicons() async {
    http.Response ret = await this
        .httpClient
        .post('${this.baseURL}?api&favicons', body: {'api_key': apiKey});
    if (ret.statusCode != 200) {
      throw ("fetch favicons failed");
    } else {
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      List<Favicon> favicons =
          decoded["favicons"].map<Favicon>((v) => Favicon.fromJSON(v)).toList();
      List<Favicon> _unique = [];
      for (var i = 0; i < favicons.length; i++) {
        if (_unique.map((e) => e.id).toList().contains(favicons[i].id) ==
                false ||
            _unique.isEmpty) {
          _unique.add(favicons[i]);
        }
      }
      return _unique;
    }
  }
}
