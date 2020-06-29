part of repository;

final storage = new FlutterSecureStorage();

class APIRepository extends Repository {
  Future<Map<String, String>> loadAPI() async {
    final _ret = await storage.read(key: 'api');
    return _ret != null ? json.decode(_ret) : null;
  }

  Future<bool> fetchAPI(String baseURL, String apiKey) async {
    http.Response ret =
        await this.httpClient.post('$baseURL', body: {'api_key': apiKey});
    if (ret.statusCode != 200) {
      return false;
    } else {
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      if (decoded['auth'] == 1) {
        await storage.write(
            key: 'api',
            value: json
                .encode(<String, String>{"key": apiKey, "baseURL": baseURL}));
      }
      return decoded['auth'] == 1;
    }
  }
}
