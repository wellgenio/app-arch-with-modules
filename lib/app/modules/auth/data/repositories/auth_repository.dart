import 'dart:async';

import 'package:result_dart/result_dart.dart';

import '../../domain/dtos/credentials_dto.dart';
import '../../domain/entities/user_entity.dart';
import '../services/auth_service.dart';

abstract class IAuthRepository {
  AsyncResult<UserEntity> login(CredentialsDto dto);

  AsyncResult<Unit> logout();

  Stream<UserEntity> observerUser();
}

class AuthRepository implements IAuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  late final StreamController<UserEntity> _streamCtrl =
      StreamController.broadcast();

  @override
  AsyncResult<UserEntity> login(CredentialsDto dto) async {
    final userLogged = UserEntity.logged(email: dto.email);
    _streamCtrl.add(userLogged);
    return Success(userLogged);
  }

  @override
  AsyncResult<Unit> logout() async {
    final userNotLogged = UserEntity.notLogged();
    _streamCtrl.add(userNotLogged);
    return Success(unit);
  }

  @override
  Stream<UserEntity> observerUser() => _streamCtrl.stream;
}
