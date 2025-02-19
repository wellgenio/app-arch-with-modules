import 'package:flutter/material.dart';
import 'package:modular_di_app/app/ui/auth/logout/logout_button_view_model.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  late final LogoutButtonViewModel viewModel =
      context.read<LogoutButtonViewModel>();

  @override
  Widget build(BuildContext context) {
    return MenuItemButton(
      onPressed: viewModel.logoutCommand.execute,
      child: Text('Sair'),
    );
  }
}
