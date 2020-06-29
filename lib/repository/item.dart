part of repository;

class ItemRepository extends Repository {
  final String apiKey;
  final String baseURL;

  ItemRepository({@required this.apiKey, @required this.baseURL})
      : assert(apiKey != null),
        assert(baseURL != null);

  Future<List<Item>> fetchItems() async {
    http.Response ret = await this.httpClient.post('$baseURL&items',
        body: {'api_key': apiKey});
    if (ret.statusCode != 200) {
      throw("fetch items failed");
    } else {
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      return decoded["items"].map<Item>((v) => Item.fromJSON(v)).toList();
    }
  }
}