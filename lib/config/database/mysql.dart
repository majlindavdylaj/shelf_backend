import 'package:mysql1/mysql1.dart';

import 'migrations.dart';

class Database {
  static MySqlConnection? _conn;

  static Future<MySqlConnection> get connection async {
    final pass = env['DB_PASS'];
    final password = (pass == null || pass == '') ? null : pass;

    _conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: env['DB_HOST'] ?? '127.0.0.1',
        port: int.parse(env['DB_PORT'] ?? '3306'),
        user: env['DB_USER'],
        password: password,
        db: env['DB_NAME'],
      ),
    );
    return _conn!;
  }
}
