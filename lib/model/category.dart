part of model;

class Category {
  final int id;
  final String title;
  late List<Feed> feeds;
  int? count;

  Category({required this.id,required this.title,required this.feeds});

  Category.fromJSON(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.feeds = [];

  copyWith({required List<Feed> feeds}) {
    this.feeds = feeds;
  }
}
