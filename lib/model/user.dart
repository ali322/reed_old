part of model;

class User {
  final int id;
  final String username;
  final bool isAdmin;
  final String lastLoginAt;

  User({this.id, this.username, this.isAdmin, this.lastLoginAt});

  User.fromJSON(Map json)
      : this.id = json['id'],
        this.username = json['username'],
        this.isAdmin = json['is_admin'],
        this.lastLoginAt = json['last_login_at'];
}
