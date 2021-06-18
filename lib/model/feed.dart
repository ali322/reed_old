part of model;

class Feed {
  final int id;
  final String title;
  final String url;
  final String siteURL;
  String? icon;
  late int count;
  final bool isSpark;
  final String updatedAt;
  final int categoryID;

  Feed(
      {required this.id,
      required this.title,
      required this.url,
      required this.categoryID,
      required this.siteURL,
      required this.isSpark,
      required this.updatedAt});

  Feed.fromJSON(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.url = json['feed_url'],
        this.categoryID = json['category']['id'],
        this.isSpark = json['is_spark'] == 1,
        this.count = 0,
        this.siteURL = json['site_url'],
        this.updatedAt = fromNow(json['checked_at']);
}
