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
        .post('$baseURL&groups', body: {'api_key': apiKey});
    if (ret.statusCode != 200) {
      throw ("fetch groups failed");
    } else {
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      return decoded["groups"].map<Group>((v) => Group.fromJSON(v)).toList();
    }
  }

  Future<List<Feed>> fetchFeeds() async {
    http.Response ret = await this
        .httpClient
        .post('${this.baseURL}&feeds', body: {'api_key': apiKey});
    if (ret.statusCode != 200) {
      throw ("fetch feeds failed");
    } else {
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      return decoded["feeds"].map<Feed>((v) => Feed.fromJSON(v)).toList();
    }
  }

  Future<List<Favicon>> fetchFavicons() async {
    http.Response ret = await this
        .httpClient
        .post('${this.baseURL}&favicons', body: {'api_key': apiKey});
    if (ret.statusCode != 200) {
      throw ("fetch favicons failed");
    } else {
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      return decoded["favicons"]
          .map<Favicon>((v) => Favicon.fromJSON(v))
          .toList();
    }
  }
}
