part of repository;

class APIRepository {
  Future<Map<String, dynamic>?> loadAPI() async {
    // await storage.deleteAll();
    final _ret = await storage.read(key: 'api');
    return _ret != null ? json.decode(_ret) as Map<String, dynamic> : null;
  }

  Future<void> saveAPI({required String title,required String baseURL,required String apiKey}) {
    return storage.write(
        key: 'api',
        value: jsonEncode(<String, dynamic>{
          'key': apiKey,
          'baseURL': baseURL,
          'title': title
        }));
  }

  Future<void> deleteAPI() async {
    return storage.delete(key: 'api');
  }
}
