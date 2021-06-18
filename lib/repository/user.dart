part of repository;

class UserRepository {
  final String apiKey;
  final String baseURL;

  UserRepository({required this.apiKey, required this.baseURL});
  
  Future<User> fetchMe() async {
    http.Response ret = await APIClient(apiKey).get(Uri.parse('$baseURL/me'));
    if (ret.statusCode != 200) {
      throw ("fetch me failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      return User.fromJSON(decoded);
    }
  }
}
