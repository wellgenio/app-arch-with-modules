class UserEntity {
  final String email;

  UserEntity({required this.email});

  factory UserEntity.empty() => UserEntity(email: '');

  factory UserEntity.logged({required String email}) = LoggedUserEntity;

  factory UserEntity.notLogged() => NotLoggedUserEntity(email: '');
}

class LoggedUserEntity extends UserEntity {
  LoggedUserEntity({required super.email});
}

class NotLoggedUserEntity extends UserEntity {
  NotLoggedUserEntity({required super.email});
}
