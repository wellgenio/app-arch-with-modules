part of 'app_widget.dart';

typedef Routes = Map<String, Widget Function(BuildContext)>;

class RoutePath {
  final String path;
  final String name;

  const RoutePath({required this.path, required this.name});
}

class RoutePaths {
  static const RoutePath home = RoutePath(
    name: 'home',
    path: '/home',
  );

  static const RoutePath collectionDetails = RoutePath(
    name: 'collection',
    path: '/collection',
  );

  static const RoutePath taskDetails = RoutePath(
    name: 'task',
    path: '/task',
  );
}

class AppRouter {
  static Routes returnRouter(bool isAuth) {
    Routes routes = {
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
        final args = ModalRoute.of(context)?.settings.arguments as int;

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
        final args = ModalRoute.of(context)?.settings.arguments as int;

        return ChangeNotifierProvider(
          create: (_) => CollectionDetailsPageViewModel(
            context.read<ICollectionRepository>(),
            context.read<ITaskRepository>(),
          ),
          child: CollectionDetailsPage(
            argument: CollectionDetailsArgument(
              taskId: args,
            ),
          ),
        );
      }
    };

    return routes;
  }
}
