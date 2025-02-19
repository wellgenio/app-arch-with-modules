import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../modules/auth/data/repositories/auth_repository.dart';
import '../../../utils/command.dart';

class LogoutButtonViewModel extends ChangeNotifier {
  final IAuthRepository authRepository;

  LogoutButtonViewModel(this.authRepository) {
    logoutCommand = Command0(authRepository.logout);
  }

  late final Command0<Unit> logoutCommand;
}
