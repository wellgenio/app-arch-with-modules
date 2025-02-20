import 'dart:async';

import 'package:result_dart/result_dart.dart';

import '../../domain/dtos/collection_dto.dart';
import '../../domain/entities/collection_entity.dart';
import '../services/collection_service.dart';

abstract class ICollectionRepository {
  Stream<List<CollectionEntity>> observerListCollection();

  Stream<CollectionEntity> observerCollection();

  AsyncResult<List<CollectionEntity>> getCollections();

  AsyncResult<CollectionEntity> getCollection(String collectionId);

  AsyncResult<Unit> addCollection(CollectionDto dto);

  AsyncResult<Unit> updateCollection(CollectionDto dto);

  AsyncResult<Unit> deleteCollection(CollectionEntity collection);

  AsyncResult<Unit> addTask(CollectionEntity collection, String taskId);
}

class CollectionRepository implements ICollectionRepository {
  final CollectionService collectionService;

  CollectionRepository(this.collectionService);

  String? _cachedCollectionId;

  late final StreamController<List<CollectionEntity>> _streamCollections =
      StreamController.broadcast();

  late final StreamController<CollectionEntity> _streamCollection =
      StreamController.broadcast();

  @override
  Stream<List<CollectionEntity>> observerListCollection() =>
      _streamCollections.stream;

  @override
  Stream<CollectionEntity> observerCollection() => _streamCollection.stream;

  @override
  AsyncResult<List<CollectionEntity>> getCollections() async {
    return collectionService.getCollections().onSuccess(_streamCollections.add);
  }

  @override
  AsyncResult<Unit> addCollection(CollectionDto dto) async {
    return collectionService
        .addCollection(dto)
        .onSuccess((_) => getCollections());
  }

  @override
  AsyncResult<Unit> deleteCollection(CollectionEntity collection) async {
    return collectionService
        .deleteCollection(collection.id)
        .onSuccess((_) => getCollections());
  }

  @override
  AsyncResult<Unit> updateCollection(CollectionDto dto) async {
    return collectionService.updateCollection(dto).onSuccess((_) {
      if (_cachedCollectionId != null) {
        getCollection(_cachedCollectionId!);
      }
      getCollections();
    });
  }

  @override
  AsyncResult<CollectionEntity> getCollection(String collectionId) async {
    _cachedCollectionId = collectionId;
    return collectionService
        .getCollection(collectionId)
        .onSuccess(_streamCollection.add);
  }

  @override
  AsyncResult<Unit> addTask(CollectionEntity collection, String taskId) {
    final dto = CollectionDto(
      id: collection.id,
      title: collection.title,
      tasks: [...collection.tasks, taskId],
    );
    return collectionService.updateCollection(dto).onSuccess((_) {
      if (_cachedCollectionId != null && collection.id == _cachedCollectionId) {
        getCollection(_cachedCollectionId!);
      }
      getCollections();
    });
  }
}
