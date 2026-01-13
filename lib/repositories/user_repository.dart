import 'package:shelf_backend/config/database/mysql.dart';
import 'package:shelf_backend/models/user.dart';

class UserRepository {
  Future<User?> findByEmailPassword(String email, String password) async {
    final db = await Database.connection;
    final result = await db.query(
      'SELECT * FROM users WHERE email = ? AND password = ?',
      [email, password],
    );
    return result.isEmpty ? null : User.fromRow(result.first);
  }

  Future<int?> createUser(User user, String password) async {
    final db = await Database.connection;
    try {
      final result = await db.query(
        'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
        [user.name, user.email, password],
      );
      return result.insertId;
    } catch (e) {
      return null;
    }
  }

  Future<User?> findByEmail(String email) async {
    final db = await Database.connection;
    final result = await db.query('SELECT * FROM users WHERE email = ?', [
      email,
    ]);
    return result.isEmpty ? null : User.fromRow(result.first);
  }

  Future<User?> findById(int id) async {
    final db = await Database.connection;
    final result = await db.query('SELECT * FROM users WHERE id = ?', [id]);
    return result.isEmpty ? null : User.fromRow(result.first);
  }
}
