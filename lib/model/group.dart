part of model;

class Group {
  final int id;
  final String title;
  List<int> feeds;

  Group({this.id, this.title, this.feeds});

  Group.fromJSON(Map json)
      : this.id = json['id'],
        this.title = json['title'],
        this.feeds = [];

  static groupFeeds(List vals, int id) {
    final _val = vals.singleWhere((val) => val['group_id'] == id);
    return _val['feed_ids'].split(',').map<int>((v) => int.parse(v)).toList();
  }
}
