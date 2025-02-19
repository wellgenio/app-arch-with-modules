import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../modules/auth/data/repositories/auth_repository.dart';
import '../../modules/auth/domain/entities/user_entity.dart';
import '../router.dart';

class AuthGuard extends RouteObserver<ModalRoute<dynamic>> {
  final GlobalKey<NavigatorState> navigatorKey;
  final BuildContext context;

  AuthGuard(
    this.context, {
    required this.navigatorKey,
  });

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    context.read<IAuthRepository>().observerUser().listen((user) {
      if (user is NotLoggedUserEntity) {
        navigatorKey.currentState?.pushReplacementNamed(RoutePaths.login.path);
      }
    });
  }
}
