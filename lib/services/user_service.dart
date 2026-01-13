import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_backend/config/di/inject.dart';
import 'package:shelf_backend/models/user.dart';
import 'package:shelf_backend/repositories/user_repository.dart';

class UserService {
  final UserRepository userRepository = getIt<UserRepository>();

  Future<Response> me(Request request) async {
    User? user = await userRepository.findById(
      request.context['userId'] as int,
    );
    return Response.ok(jsonEncode({"user": user?.toJson()}));
  }
}
