part of repository;

final storage = new FlutterSecureStorage();

class APIRepository {
  Future<Map<String, dynamic>> loadAPIKey() async {
    // await storage.deleteAll();
    final _ret = await storage.read(key: 'api');
    return _ret != null ? json.decode(_ret) as Map<String, dynamic> : null;
  }

  Future<void> saveAPIKey(String apiKey, String baseURL) {
    return storage.write(
        key: 'api',
        value:
            jsonEncode(<String, dynamic>{'key': apiKey, 'baseURL': baseURL}));
  }
}
