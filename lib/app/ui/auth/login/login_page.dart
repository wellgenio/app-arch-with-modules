import 'package:flutter/material.dart';
import 'package:modular_di_app/app/app_widget.dart';
import 'package:modular_di_app/app/modules/auth/domain/dtos/credentials_dto.dart';
import 'package:modular_di_app/app/ui/auth/login/login_page_view_model.dart';
import 'package:modular_di_app/app/ui/shared/widgets/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final LoginPageViewModel viewModel = context.read<LoginPageViewModel>();
  late AnimationController ctrl;
  late Animation<double> anime;

  final formKey = GlobalKey<FormState>();
  final dto = isProduction ? CredentialsDto.empty() : CredentialsDto.testUser();

  @override
  void initState() {
    super.initState();

    viewModel.loginCommand.addListener(listener);

    ctrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    anime = Tween<double>(
      begin: -700,
      end: 0,
    ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeInOutBack));
    ctrl.forward();
  }

  listener() {
    if (viewModel.loginCommand.completed) {
      Navigator.of(context).pushReplacementNamed(RoutePaths.home.path);
    }
  }

  @override
  dispose() {
    viewModel.loginCommand.addListener(listener);
    super.dispose();
  }

  onSubmit() {
    if (formKey.currentState!.validate()) {
      viewModel.loginCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: ctrl,
          builder: (context, _) {
            return Transform.translate(
              offset: Offset(0, anime.value),
              child: Container(
                width: MediaQuery.sizeOf(context).width * 0.75,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    spacing: 24.0,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 12.0,
                        children: [
                          Text('Complex'),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text(
                              'TODO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: dto.email,
                        onChanged: dto.setEmail,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        initialValue: dto.password,
                        onChanged: dto.setPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: PrimaryButton(
                          onPressed: onSubmit,
                          child: Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
