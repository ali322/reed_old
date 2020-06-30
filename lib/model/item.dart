part of model;

class Item {
  final int id;
  final String title;
  final String author;
  final String url;
  final String content;
  final int createdAt;
  final bool isRead;
  final bool isSaved;
  final int feedID;

  Item(
      {this.id,
      this.title,
      this.author,
      this.url,
      this.content,
      this.createdAt,
      this.isRead,
      this.isSaved,
      this.feedID});

  Item.fromJSON(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.author = json['author'],
        this.url = json['url'],
        this.content = json['html'],
        this.createdAt = json['created_on_time'],
        this.isRead = json['is_read'] == 1,
        this.isSaved = json['is_saved'] == 1,
        this.feedID = json['feed_id'];
}
