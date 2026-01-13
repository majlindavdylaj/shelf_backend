import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_backend/config/di/inject.dart';
import 'package:shelf_backend/models/user.dart';
import 'package:shelf_backend/repositories/refresh_token_repository.dart';
import 'package:shelf_backend/repositories/user_repository.dart';
import 'package:shelf_backend/utils/helper.dart';

class AuthService {
  final userRepository = getIt<UserRepository>();
  final refreshTokenRepository = getIt<RefreshTokenRepository>();

  Future<Response> login(Request request) async {
    final body = await getBody(request);
    final email = body['email'];
    String? password = body['password'];

    if (email == null || email.isEmpty) {
      return Response.forbidden(jsonEncode({"message": "Email is required"}));
    }

    if (password == null || password.isEmpty) {
      return Response.forbidden(
        jsonEncode({"message": "Password is required"}),
      );
    }

    password = hashPassword(body['password']);
    User? user = await userRepository.findByEmailPassword(email, password);

    if (user == null) {
      return Response.forbidden(jsonEncode({"message": "Invalid credentials"}));
    }

    final token = generateToken(user.id);
    final refreshToken = await refreshTokenRepository.createRefreshToken(
      user.id,
    );

    return Response.ok(
      jsonEncode({
        "token": token,
        "refresh_token": refreshToken,
        "user": user.toJson(),
      }),
    );
  }

  Future<Response> register(Request request) async {
    final body = await getBody(request);
    final name = body['name'];
    final email = body['email'];
    String? password = body['password'];

    if (name == null || name.isEmpty) {
      return Response.forbidden(jsonEncode({"message": "Name is required"}));
    }

    if (email == null || email.isEmpty) {
      return Response.forbidden(
        jsonEncode({"message": "Username is required"}),
      );
    }

    if (password == null || password.isEmpty) {
      return Response.forbidden(
        jsonEncode({"message": "Password is required"}),
      );
    }

    if (await userRepository.findByEmail(email) != null) {
      return Response.forbidden(
        jsonEncode({"message": "This email exists already"}),
      );
    }

    password = hashPassword(password);
    User newUser = User(id: 1, name: name, email: email);

    int? insertedId = await userRepository.createUser(newUser, password);
    User? user = insertedId != null
        ? await userRepository.findById(insertedId)
        : null;

    if (user == null) {
      return Response.internalServerError(
        body: jsonEncode({"message": "Could not create user"}),
      );
    }

    final token = generateToken(user.id);
    final refreshToken = await refreshTokenRepository.createRefreshToken(
      user.id,
    );

    return Response.ok(
      jsonEncode({
        "token": token,
        "refresh_token": refreshToken,
        "user": user.toJson(),
      }),
    );
  }

  Future<Response> refreshToken(Request request) async {
    final body = await getBody(request);
    String? refreshToken = body['refresh_token'];

    if (refreshToken == null || refreshToken.isEmpty) {
      return Response.forbidden(
        jsonEncode({"message": "Refresh token is required"}),
      );
    }

    int? userId = await refreshTokenRepository.checkRefreshToken(refreshToken);
    if (userId == null) {
      return Response.unauthorized(
        jsonEncode({"message": "Refresh token expired"}),
      );
    }

    bool deleted = await refreshTokenRepository.deleteRefreshToken(
      refreshToken,
    );
    if (!deleted) {
      return Response.internalServerError(
        body: jsonEncode({"message": "Something went wrong"}),
      );
    }

    final token = generateToken(userId);
    final newRefreshToken = await refreshTokenRepository.createRefreshToken(
      userId,
    );

    return Response.ok(
      jsonEncode({"token": token, "refresh_token": newRefreshToken}),
    );
  }
}
