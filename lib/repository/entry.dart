part of repository;

enum EntryStatus { UnReaded, Starred, All }

class EntryRepository {
  final String apiKey;
  final String baseURL;

  EntryRepository({@required this.apiKey, @required this.baseURL})
      : assert(apiKey != null),
        assert(baseURL != null);

  Future<Map<String, dynamic>> fetchEntries(
      {Feed feed,
      int lastRefreshedAt,
      int limit,
      String search,
      String direction = 'desc',
      EntryStatus status = EntryStatus.All}) async {
    String _url =
        '$baseURL/entries?order=published_at&limit=$limit&direction=$direction&after=$lastRefreshedAt';
    if (feed != null) {
      _url =
          '$baseURL/feeds/${feed.id}/entries?order=published_at&limit=$limit&direction=$direction&after=$lastRefreshedAt';
    }
    if (status == EntryStatus.UnReaded) {
      _url += '&status=unread';
    }
    if (status == EntryStatus.Starred) {
      _url += '&starred=true';
    }
    if (search != null) {
      _url += '&search=$search';
    }
    http.Response ret = await APIClient(apiKey).get(_url);
    if (ret.statusCode != 200) {
      throw ("fetch entries failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      List<Entry> _entries =
          decoded["entries"].map<Entry>((v) => Entry.fromJSON(v)).toList();
      return <String, dynamic>{'total': decoded['total'], 'rows': _entries};
    }
  }

  Future<Entry> fetchEntry({int id}) async {
    http.Response ret = await APIClient(apiKey).get('$baseURL/entries/$id');
    if (ret.statusCode != 200) {
      throw ("fetch entry failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      return Entry.fromJSON(decoded);
    }
  }

  Future<void> changeEntriesStatus(List<int> ids, String status) async {
    final ret = await APIClient(apiKey).put('$baseURL/entries',
        headers: {"Content-Type": "application/json;charset=utf-8"},
        body:
            jsonEncode(<String, dynamic>{'entry_ids': ids, 'status': status}));
    if (ret.statusCode != 204) {
      throw ("change entries failed");
    }
  }
}
