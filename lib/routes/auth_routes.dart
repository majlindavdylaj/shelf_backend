import 'package:shelf/shelf.dart';
import 'package:shelf_backend/config/di/inject.dart';
import 'package:shelf_backend/services/auth_service.dart';
import 'package:shelf_router/shelf_router.dart';

class AuthRoutes {
  final authService = getIt<AuthService>();

  Router get router {
    final Router router = Router();

    router.post('/login', (Request request) async {
      return authService.login(request);
    });

    router.post('/register', (Request request) async {
      return authService.register(request);
    });

    router.get('/refresh-token', (Request request) async {
      return authService.refreshToken(request);
    });

    return router;
  }
}
