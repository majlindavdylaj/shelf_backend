import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:shelf_backend/config/database/mysql.dart';

final env = DotEnv();

void runMigration() async {
  env.load();

  final db = await Database.connection;

  await db.query('''
    CREATE TABLE IF NOT EXISTS migrations (
      id INT PRIMARY KEY,
      name VARCHAR(255),
      run_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  ''');

  final applied = await db.query('SELECT id FROM migrations');
  final appliedIds = applied.map((e) => e['id']).toSet();

  final files = Directory('migrations').listSync().whereType<File>().toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final file in files) {
    final id = int.parse(file.uri.pathSegments.last.split('_').first);
    if (appliedIds.contains(id)) continue;

    final sql = await file.readAsString();

    final statements = sql
        .split(';')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty);

    for (final stmt in statements) {
      await db.query(stmt);
    }

    await db.query('INSERT INTO migrations (id, name) VALUES (?, ?)', [
      id,
      file.path,
    ]);

    print('✓ Migration ${file.path} applied');
  }
}
