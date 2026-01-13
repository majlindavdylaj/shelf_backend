import 'package:mysql1/mysql1.dart';

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromRow(ResultRow row) {
    return User(id: row['id'], name: row['name'], email: row['email']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}
