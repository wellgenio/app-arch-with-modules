import 'package:flutter/material.dart';
import 'package:modular_di_app/app/modules/task/data/repositories/task_repository.dart';
import 'package:modular_di_app/app/modules/task/domain/entities/task_entity.dart';
import 'package:result_dart/result_dart.dart';

import '../../../modules/collection/data/repositories/collection_repository.dart';
import '../../../modules/collection/domain/entities/collection_entity.dart';
import '../../../utils/command.dart';

class CollectionDetailsPageViewModel extends ChangeNotifier {
  final ICollectionRepository collectionRepository;
  final ITaskRepository taskRepository;

  CollectionDetailsPageViewModel(
      this.collectionRepository, this.taskRepository) {
    getCollectionCommand = Command1(_getCollection);
  }

  CollectionEntity _collection = CollectionEntity.empty();

  CollectionEntity get collection => _collection;

  List<TaskEntity> _tasks = const [];

  List<TaskEntity> get tasks => _tasks;

  late final Command1<CollectionEntity, int> getCollectionCommand;

  AsyncResult<CollectionEntity> _getCollection(int collectionId) async {
    final [
      resultTasks as ResultDart<List<TaskEntity>, Exception>,
      resultCollection as ResultDart<CollectionEntity, Exception>,
    ] = await Future.wait([
      taskRepository.getTasks(),
      collectionRepository.getCollection(collectionId),
    ]);

    if (resultTasks.isError()) {
      return Failure(resultTasks.exceptionOrNull()!);
    }

    if (resultCollection.isError()) {
      return Failure(resultCollection.exceptionOrNull()!);
    }

    final tasks = resultTasks.getOrNull();
    final collection = resultCollection.getOrNull();

    if (tasks == null || collection == null) {
      return Failure(Exception('Not found'));
    }

    _tasks = tasks.where((data) => collection.tasks.contains(data.id)).toList();

    updateCollectionOnScreen(collection);
    updateListTaskOnScreen();
    return Success(collection);
  }

  updateCollectionOnScreen(CollectionEntity collection) {
    _collection = collection;
    notifyListeners();
  }

  updateListTaskOnScreen([_]) => collectionRepository.getCollections();
}
