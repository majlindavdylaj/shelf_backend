import 'package:get_it/get_it.dart';
import 'package:shelf_backend/repositories/refresh_token_repository.dart';
import 'package:shelf_backend/repositories/user_repository.dart';
import 'package:shelf_backend/services/auth_service.dart';
import 'package:shelf_backend/services/user_service.dart';

final GetIt getIt = GetIt.instance;

void initInjector() {
  //Repositories
  getIt.registerSingleton<UserRepository>(UserRepository());
  getIt.registerSingleton<RefreshTokenRepository>(RefreshTokenRepository());

  //Services
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<UserService>(UserService());
}
