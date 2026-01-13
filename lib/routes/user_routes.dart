import 'package:shelf/shelf.dart';
import 'package:shelf_backend/config/di/inject.dart';
import 'package:shelf_backend/services/user_service.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRoutes {
  final userService = getIt<UserService>();

  Router get router {
    final Router router = Router();

    router.get('/me', (Request request) async {
      return userService.me(request);
    });

    return router;
  }
}
