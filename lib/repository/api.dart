part of repository;

class APIRepository {
  Future<Map<String, dynamic>> loadAPI() async {
    await storage.deleteAll();
    final _ret = await storage.read(key: 'api');
    return _ret != null ? json.decode(_ret) as Map<String, dynamic> : null;
  }

  Future<void> saveAPI({String title, String baseURL, String apiKey}) {
    return storage.write(
        key: 'api',
        value: jsonEncode(<String, dynamic>{
          'key': apiKey,
          'baseURL': baseURL,
          'title': title
        }));
  }
}
