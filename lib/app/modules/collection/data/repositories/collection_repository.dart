import 'dart:async';
import 'dart:developer';

import 'package:modular_di_app/app/modules/collection/domain/dtos/collection_dto.dart';
import 'package:modular_di_app/app/modules/task/domain/entities/task_entity.dart';
import 'package:result_dart/result_dart.dart';
import '../../domain/entities/collection_entity.dart';
import '../services/collection_service.dart';

abstract class ICollectionRepository {
  AsyncResult<List<CollectionEntity>> getCollections();

  AsyncResult<CollectionEntity> getCollection(int collectionId);

  AsyncResult<Unit> addCollection(CollectionDto dto);

  AsyncResult<Unit> updateCollection(CollectionDto dto);

  AsyncResult<Unit> deleteCollection(CollectionEntity collection);

  Stream<List<CollectionEntity>> observerCollections();

  AsyncResult<Unit> addTask(int collectionId, int taskId);
}

class CollectionRepository implements ICollectionRepository {
  final CollectionService collectionService;
  final bool isCacheEnabled;
  final bool isErrorEnabled;

  CollectionRepository.cached(this.collectionService)
      : isCacheEnabled = true,
        isErrorEnabled = false;

  CollectionRepository.noCache(this.collectionService)
      : isCacheEnabled = false,
        isErrorEnabled = false;

  CollectionRepository.error(this.collectionService)
      : isCacheEnabled = true,
        isErrorEnabled = true;

  List<CollectionEntity>? _cachedCollections = [
    CollectionEntity(id: 1, title: 'Collection 1', tasks: []),
    CollectionEntity(id: 2, title: 'Collection 2', tasks: []),
    CollectionEntity(id: 3, title: 'Collection 3', tasks: []),
  ];

  late final StreamController<List<CollectionEntity>> _streamCtrl =
      StreamController.broadcast();

  @override
  AsyncResult<List<CollectionEntity>> getCollections() async {
    if (isCacheEnabled && _cachedCollections != null) {
      if (isErrorEnabled) {
        throw 'You have already fetched the profile';
      }
      log('$CollectionRepository: returning cached collections');
      _streamCtrl.add(_cachedCollections!);
      return Success(_cachedCollections!);
    }

    final collection = await collectionService.getCollections();
    if (isCacheEnabled) {
      _cachedCollections = collection.getOrNull();
    }
    _streamCtrl.add(_cachedCollections!);
    return collection;
  }

  int currentId = 4;

  @override
  AsyncResult<Unit> addCollection(CollectionDto dto) async {
    _cachedCollections?.add(CollectionEntity(
      id: currentId++,
      title: dto.title,
      tasks: [],
    ));
    return Success(unit);
  }

  @override
  AsyncResult<Unit> deleteCollection(CollectionEntity collection) async {
    _cachedCollections?.removeWhere((data) => data.id == collection.id);
    return Success(unit);
  }

  @override
  AsyncResult<Unit> updateCollection(CollectionDto dto) async {
    _cachedCollections?.removeWhere((data) => data.id == dto.id);
    _cachedCollections?.add(CollectionEntity(
      id: dto.id,
      title: dto.title,
      tasks: dto.tasks,
    ));

    _cachedCollections = _cachedCollections?.map((data) {
      if (data.id == dto.id) {
        return CollectionEntity(id: dto.id, title: dto.title, tasks: dto.tasks);
      }
      return data;
    }).toList();
    return Success(unit);
  }

  @override
  Stream<List<CollectionEntity>> observerCollections() => _streamCtrl.stream;

  @override
  AsyncResult<CollectionEntity> getCollection(int collectionId) async {
    if (_cachedCollections == null) return Failure(Exception('not found task'));

    final collection =
        _cachedCollections!.firstWhere((data) => data.id == collectionId);

    return Success(collection);
  }

  @override
  AsyncResult<Unit> addTask(int collectionId, int taskId) async {
    _cachedCollections = _cachedCollections?.map((data) {
      if (data.id == collectionId) {
        return CollectionEntity(
          id: data.id,
          title: data.title,
          tasks: [...data.tasks, taskId],
        );
      }
      return data;
    }).toList();
    return Success(unit);
  }
}
