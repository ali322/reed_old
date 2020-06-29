part of model;

class Feed {
  final int id;
  final String title;
  final String url;
  final String siteURL;
  final int faviconID;
  final bool isSpark;
  final String updatedAt;
  String favicon = '';

  Feed(
      {this.id,
      this.title,
      this.url,
      this.faviconID,
      this.siteURL,
      this.isSpark,
      this.updatedAt});

  Feed.fromJSON(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.url = json['url'],
        this.faviconID = json['favicon_id'],
        this.isSpark = json['is_spark'],
        this.siteURL = json['site_url'],
        this.updatedAt = fromNow(json['last_updated_on_time']);
}
