import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modules/collection/data/repositories/collection_repository.dart';
import 'modules/task/data/repositories/task_repository.dart';
import 'ui/collections/collections_page_view_model.dart';
import 'ui/collections/details/collection_details_page.dart';
import 'ui/collections/details/collection_details_page_view_model.dart';
import 'ui/tasks/details/task_details_page.dart';
import 'ui/tasks/details/task_details_page_view_model.dart';
import 'ui/home_page.dart';
import 'ui/tasks/tasks_page_view_model.dart';

part 'app_widget_routes.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Modular App',
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePaths.home.path,
      routes: AppRouter.returnRouter(true),
    );
  }
}
