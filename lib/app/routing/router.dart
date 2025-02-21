import 'package:flutter/material.dart';
import 'package:modular_di_app/app/modules/collection/domain/usecases/get_tasks_by_collection.dart';
import 'package:provider/provider.dart';

import '../modules/auth/data/repositories/auth_repository.dart';
import '../modules/collection/data/repositories/collection_repository.dart';
import '../modules/task/data/repositories/task_repository.dart';
import '../ui/auth/login/login_page.dart';
import '../ui/auth/login/login_page_view_model.dart';
import '../ui/collections/collections_page_view_model.dart';
import '../ui/collections/details/collection_details_page.dart';
import '../ui/collections/details/collection_details_page_view_model.dart';
import '../ui/home_page.dart';
import '../ui/tasks/details/task_details_page.dart';
import '../ui/tasks/details/task_details_page_view_model.dart';
import '../ui/tasks/tasks_page_view_model.dart';

part 'routes.dart';

typedef Routes = Map<String, Widget Function(BuildContext)>;

class RoutePath {
  final String path;
  final String name;

  const RoutePath({required this.path, required this.name});
}

class AppRouter {
  static Routes returnRouter() => {
        RoutePaths.home.path: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => TasksPageViewModel(
                    context.read<ITaskRepository>(),
                  ),
                ),
                ChangeNotifierProvider(
                  create: (context) => CollectionsPageViewModel(
                    context.read<ICollectionRepository>(),
                  ),
                ),
              ],
              child: HomePage(),
            ),
        RoutePaths.taskDetails.path: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String;

          return ChangeNotifierProvider(
            create: (_) => TaskDetailsPageViewModel(
              context.read<ITaskRepository>(),
            ),
            child: TaskDetailsPage(
              argument: TaskDetailsArgument(
                taskId: args,
              ),
            ),
          );
        },
        RoutePaths.collectionDetails.path: (context) {
          final args = ModalRoute.of(context)?.settings.arguments as String;

          return ChangeNotifierProvider(
            create: (_) => CollectionDetailsPageViewModel(
              context.read<ICollectionRepository>(),
              context.read<ITaskRepository>(),
              context.read<GetTasksByCollection>(),
            ),
            child: CollectionDetailsPage(
              argument: CollectionDetailsArgument(
                collectionId: args,
              ),
            ),
          );
        },
        RoutePaths.login.path: (context) => ChangeNotifierProvider(
              create: (_) => LoginPageViewModel(
                context.read<IAuthRepository>(),
              ),
              child: LoginPage(),
            ),
      };
}
