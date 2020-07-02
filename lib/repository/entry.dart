part of repository;

enum FeedType { UnReaded, Saved, All }

class EntryRepository {
  final String apiKey;
  final String baseURL;

  EntryRepository({@required this.apiKey, @required this.baseURL})
      : assert(apiKey != null),
        assert(baseURL != null);

  Future<Map<String, dynamic>> fetchEntries({Feed feed}) async {
    String _url = '$baseURL/entries?order=published_at&direction=desc';
    if (feed != null) {
      _url =
          '$baseURL/feeds/${feed.id}/entries?order=published_at&direction=desc';
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
}
