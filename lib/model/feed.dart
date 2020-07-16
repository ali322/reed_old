part of model;

class Feed {
  final int id;
  final String title;
  final String url;
  final String siteURL;
  String icon;
  int unreadCount;
  final bool isSpark;
  final String updatedAt;
  final int categoryID;

  Feed(
      {this.id,
      this.title,
      this.url,
      this.categoryID,
      this.siteURL,
      this.isSpark,
      this.updatedAt});

  Feed.fromJSON(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.url = json['feed_url'],
        this.categoryID = json['category']['id'],
        this.isSpark = json['is_spark'] == 1,
        this.unreadCount = 0,
        this.siteURL = json['site_url'],
        this.updatedAt = fromNow(json['checked_at']);
}
