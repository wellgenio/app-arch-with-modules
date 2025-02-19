import 'package:result_dart/result_dart.dart';

import '../../../core/core_module.dart';
import '../../domain/entities/collection_entity.dart';

class CollectionService {
  final HttpClient httpClient;

  const CollectionService(this.httpClient);

  AsyncResult<List<CollectionEntity>> getCollections() async => Success([]);
}
