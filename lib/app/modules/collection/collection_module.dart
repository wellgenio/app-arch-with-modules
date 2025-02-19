import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'data/repositories/collection_repository.dart';
import 'data/services/collection_service.dart';

List<SingleChildWidget> get collectionModuleProviders {
  return [
    Provider(
      create: (context) => CollectionService(context.read()),
    ),
    Provider(
      create: (context) =>
      CollectionRepository.cached(context.read()) as ICollectionRepository,
    ),
  ];
}