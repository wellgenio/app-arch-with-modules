import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'data/repositories/collection_repository.dart';
import 'data/services/collection_service.dart';
import 'domain/usecases/get_tasks_by_collection.dart';

List<SingleChildWidget> get collectionModuleProviders {
  return [
    Provider(
      create: (context) => CollectionService(context.read()),
    ),
    Provider(
      create: (context) =>
          CollectionRepository(context.read()) as ICollectionRepository,
    ),
    Provider(
      create: (context) => GetTasksByCollection(context.read()),
    ),
  ];
}
