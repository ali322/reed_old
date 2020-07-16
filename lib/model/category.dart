part of model;

class Category {
  final int id;
  final String title;
  List<Feed> feeds;
  int unreadCount;

  Category({this.id, this.title, this.feeds});

  Category.fromJSON(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.feeds = [];

  copyWith({List<Feed> feeds}) {
    this.feeds = feeds;
  }
}
