import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../config/database/migrations.dart';

String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

String generateToken(int userId) {
  final jwt = JWT({'uid': userId}, issuer: 'shelf-api');
  final token = jwt.sign(
    SecretKey(env['JWT_SECRET_KEY_TOKEN']!),
    expiresIn: Duration(seconds: int.parse(env['JWT_EXPIRES_IN']!)),
  );
  return token;
}

String generateRefreshToken() {
  final rand = Random.secure();
  final bytes = List<int>.generate(64, (_) => rand.nextInt(256));
  return base64UrlEncode(bytes);
}

Future<dynamic> getBody(Request request) async {
  String data = await request.readAsString();
  final body = jsonDecode(data.isEmpty ? '{}' : data);
  return body;
}
