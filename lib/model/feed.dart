part of model;

class Feed {
  final int id;
  final String title;
  final String url;
  final String siteURL;
  final int iconID;
  final bool isSpark;
  final String updatedAt;
  final int categoryID;

  Feed(
      {this.id,
      this.title,
      this.url,
      this.iconID,
      this.categoryID,
      this.siteURL,
      this.isSpark,
      this.updatedAt});

  Feed.fromJSON(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.url = json['feed_url'],
        this.iconID = json['icon'] == null? null: json['icon']['icon_id'],
        this.categoryID = json['category']['id'],
        this.isSpark = json['is_spark'] == 1,
        this.siteURL = json['site_url'],
        this.updatedAt = fromNow(json['checked_at']);
}
