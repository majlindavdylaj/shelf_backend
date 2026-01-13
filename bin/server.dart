import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_backend/config/database/migrations.dart';
import 'package:shelf_backend/config/di/inject.dart';
import 'package:shelf_backend/middlewares/auth_middleware.dart';
import 'package:shelf_backend/routes/auth_routes.dart';
import 'package:shelf_backend/routes/user_routes.dart';
import 'package:shelf_router/shelf_router.dart';

void main(List<String> args) async {
  initInjector();
  runMigration();

  final router = Router();
  router.mount('/auth/', AuthRoutes().router.call);
  router.mount(
    '/users/',
    Pipeline()
        .addMiddleware(authMiddleware())
        .addHandler(UserRoutes().router.call),
  );

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call);

  final port = int.parse(env['PORT'] ?? '8080');
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  print('Server listening on port ${server.port}');
}
