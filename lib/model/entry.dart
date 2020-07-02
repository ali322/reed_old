part of model;

class Entry {
  final int id;
  final String title;
  final String author;
  final String url;
  final String content;
  final String publishedAt;
  final bool isRead;
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
      this.isRead,
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
        this.isRead = json['status'] == 'read',
        this.isStarred = json['starred'],
        this.feed = Feed.fromJSON(json['feed']),
        this.feedID = json['feed']['id'];
}
