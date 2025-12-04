class User {
  final int id;
  final String fullName;
  final String email;
  final String avatar;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'avatar': avatar
    };
  }
}
