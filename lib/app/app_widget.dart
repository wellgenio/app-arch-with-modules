import 'package:flutter/material.dart';
import 'routing/guards/auth_guard.dart';
import 'routing/router.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Complex TODO',
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePaths.login.path,
      routes: AppRouter.returnRouter(),
      navigatorObservers: [
        AuthGuard(context, navigatorKey: navigatorKey),
      ],
    );
  }
}

