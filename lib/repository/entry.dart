part of repository;

class EntryRepository {
  final String apiKey;
  final String baseURL;

  EntryRepository({required this.apiKey, required this.baseURL});

  Future<Map<String, dynamic>> fetchEntries(
      {Feed? feed,
      required int offset,
      required int limit,
      String? search,
      String direction = 'asc',
      EntryStatus status = EntryStatus.All}) async {
    String _url =
        '$baseURL/entries?order=published_at&direction=$direction&offset=$offset&limit=$limit';
    if (feed != null) {
      _url =
          '$baseURL/feeds/${feed.id}/entries?order=published_at&direction=$direction&offset=$offset&limit=$limit';
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
    print(_url);
    http.Response ret = await APIClient(apiKey).get(Uri.parse(_url));
    if (ret.statusCode != 200) {
      throw ("fetch entries failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      print("====>entries ${decoded['entries']}");
      List<Entry> _entries =
          decoded["entries"].map<Entry>((v) => Entry.fromJSON(v)).toList();
      return <String, dynamic>{'total': decoded['total'], 'rows': _entries};
    }
  }

  Future<Entry> fetchEntry({required int id}) async {
    http.Response ret = await APIClient(apiKey).get(Uri.parse('$baseURL/entries/$id'));
    print("===> $baseURL  $id");
    if (ret.statusCode != 200) {
      throw ("fetch entry failed");
    } else {
      ret.headers['content-type'] = 'application/json;charset=utf-8';
      var decoded = json.decode(ret.body) as Map<String, dynamic>;
      return Entry.fromJSON(decoded);
    }
  }

  Future<void> changeEntriesStatus(List<int> ids, EntryStatus status) async {
    final ret = await APIClient(apiKey).put(Uri.parse('$baseURL/entries'),
        headers: {"Content-Type": "application/json;charset=utf-8"},
        body: jsonEncode(<String, dynamic>{
          'entry_ids': ids,
          'status': status.asString().toLowerCase()
        }));
    if (ret.statusCode != 204) {
      throw ("change entries failed");
    }
  }
}
