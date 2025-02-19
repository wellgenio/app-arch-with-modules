import 'package:flutter/material.dart';

import '../../../modules/auth/data/repositories/auth_repository.dart';
import '../../../modules/auth/domain/dtos/credentials_dto.dart';
import '../../../modules/auth/domain/entities/user_entity.dart';
import '../../../utils/command.dart';

class LoginPageViewModel extends ChangeNotifier {
  final IAuthRepository authRepository;

  LoginPageViewModel(this.authRepository) {
    loginCommand = Command1(authRepository.login);
  }

  late final Command1<UserEntity, CredentialsDto> loginCommand;
}