import 'package:shelf_backend/config/database/migrations.dart';
import 'package:shelf_backend/config/database/mysql.dart';
import 'package:shelf_backend/utils/helper.dart';

class RefreshTokenRepository {
  Future<String?> createRefreshToken(int userId) async {
    final db = await Database.connection;
    try {
      final String refreshToken = generateRefreshToken();
      await db.query(
        'INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (?, ?, DATE_ADD(NOW(), INTERVAL ${env['REFRESH_TOKEN_EXPIRES_AT']} SECOND))',
        [userId, refreshToken],
      );
      return refreshToken;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<int?> checkRefreshToken(String refreshToken) async {
    final db = await Database.connection;
    final result = await db.query(
      'SELECT user_id FROM refresh_tokens WHERE token = ? AND expires_at > NOW()',
      [refreshToken],
    );
    return result.isEmpty ? null : result.first['user_id'];
  }

  Future<bool> deleteRefreshToken(String refreshToken) async {
    final db = await Database.connection;
    try {
      await db.query('DELETE FROM refresh_tokens WHERE token = ?', [
        refreshToken,
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }
}
