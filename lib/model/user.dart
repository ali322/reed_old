part of model;

class User {
  final int id;
  final String username;
  final bool isAdmin;
  final String lastLoginAt;

  User({required this.id,required this.username,required this.isAdmin,required this.lastLoginAt});

  User.fromJSON(Map json)
      : this.id = json['id'],
        this.username = json['username'],
        this.isAdmin = json['is_admin'],
        this.lastLoginAt = json['last_login_at'];
}
