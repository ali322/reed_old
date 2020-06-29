part of model;

class Favicon {
  final int id;
  final String data;

  Favicon({this.id, this.data});

  Favicon.fromJSON(Map json):
    this.id = json['id'],
    this.data = json['data'];
}
