import 'package:flutter/material.dart';
import 'package:modular_di_app/app/config/modules.dart';
import 'package:provider/provider.dart';

import 'app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: providers, child: const AppWidget()));
}
