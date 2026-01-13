import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_backend/config/database/migrations.dart';

Middleware authMiddleware() {
  return (innerHandler) {
    return (request) async {
      final header = request.headers['authorization'];
      if (header == null || !header.startsWith('Bearer ')) {
        return Response.unauthorized(jsonEncode({"message": "Unauthorized"}));
      }

      try {
        final token = header.substring(7);
        final jwt = JWT.verify(token, SecretKey(env['JWT_SECRET_KEY_TOKEN']!));
        return innerHandler(
          request.change(context: {'userId': jwt.payload['uid']}),
        );
      } catch (e) {
        return Response.unauthorized(jsonEncode({"message": "Unauthorized"}));
      }
    };
  };
}
