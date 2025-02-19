import 'package:modular_di_app/app/modules/auth/data/repositories/auth_repository.dart';
import 'package:modular_di_app/app/modules/auth/data/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get authModuleProviders {
  return [
    Provider(
      create: (context) => AuthService(context.read()),
    ),
    Provider(
      create: (context) => AuthRepository(context.read()) as IAuthRepository,
    ),
  ];
}
