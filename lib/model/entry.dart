part of model;

enum EntryStatus { UnReaded, Starred, All, Read }

Map<String, EntryStatus> _vals() {
  Map<String, EntryStatus> _vals = {};
  EntryStatus.values.forEach((e) {
    final _key = e.toString().replaceAll("EntryStatus.", "");
    _vals[_key] = e;
  });
  return _vals;
}

EntryStatus entryStatusfromString(String val) {
  return _vals()[val];
}

extension EntryStatusExt on EntryStatus {
  String asString() {
    return _vals().keys.toList()[this.index];
  }
}

class Entry {
  final int id;
  final String title;
  final String author;
  final String url;
  final String content;
  final String publishedAt;
  EntryStatus status;
  final bool isStarred;
  final int feedID;
  final Feed feed;

  Entry(
      {this.id,
      this.title,
      this.author,
      this.url,
      this.content,
      this.publishedAt,
      this.status,
      this.isStarred,
      this.feed,
      this.feedID});

  Entry.fromJSON(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.author = json['author'],
        this.url = json['url'],
        this.content = json['content'],
        this.publishedAt = json['published_at'],
        this.status = entryStatusfromString(json['status']),
        this.isStarred = json['starred'],
        this.feed = Feed.fromJSON(json['feed']),
        this.feedID = json['feed']['id'];
}
