import 'package:flutter/material.dart';
import 'package:modular_di_app/app/config/modules.dart';
import 'package:provider/provider.dart';

import 'app/app_widget.dart';

bool isProduction = true;

Future<void> main() async {
  assert(() {
    isProduction = false;
    return true;
  }());

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: providers, child: const AppWidget()));
}
