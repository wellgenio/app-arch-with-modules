import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../modules/task/data/repositories/task_repository.dart';
import '../../../modules/task/domain/dtos/task_dto.dart';
import '../../../modules/task/domain/entities/task_entity.dart';
import '../../../modules/collection/data/repositories/collection_repository.dart';
import '../../../modules/collection/domain/entities/collection_entity.dart';
import '../../../utils/command.dart';

typedef CheckedParams = ({
  int collectionId,
  TaskEntity task,
  bool value,
});

enum TypeFilter { all, doValue, completed }

class CollectionDetailsPageViewModel extends ChangeNotifier {
  final ICollectionRepository collectionRepository;
  final ITaskRepository taskRepository;

  CollectionDetailsPageViewModel(
      this.collectionRepository, this.taskRepository) {
    getCollectionCommand = Command1(_getCollection);
    checkedCommand = Command1(_onChecked);
  }

  CollectionEntity _collection = CollectionEntity.empty();

  CollectionEntity get collection => _collection;

  TypeFilter _filter = TypeFilter.all;

  List<TaskEntity> _tasks = [];

  List<TaskEntity> _filteredTasks = const [];

  List<TaskEntity> get tasks => _filter != TypeFilter.all //
      ? _filteredTasks
      : _tasks;

  bool get hasTasks => _tasks.isNotEmpty;

  late final Command1<CollectionEntity, int> getCollectionCommand;

  late final Command1<Unit, CheckedParams> checkedCommand;

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

    _updateCollectionOnScreen(collection);
    _updateListTaskOnScreen();
    return Success(collection);
  }

  AsyncResult<Unit> _onChecked(CheckedParams params) {
    final dto = TaskDto(
      id: params.task.id,
      title: params.task.title,
      value: params.value,
    );
    return taskRepository
        .updateTask(dto)
        .flatMap((_) => _getCollection(params.collectionId))
        .onSuccess(_checkFilter)
        .pure(unit);
  }

  onAll() {
    _filter = TypeFilter.all;
    _filteredTasks = [];
    notifyListeners();
  }

  onDo() {
    _filter = TypeFilter.doValue;
    _filteredTasks = _tasks.where((data) => data.value == false).toList();
    notifyListeners();
  }

  onCompleted() {
    _filter = TypeFilter.completed;
    _filteredTasks = _tasks.where((data) => data.value == true).toList();
    notifyListeners();
  }

  _checkFilter([_]) => switch (_filter) {
    TypeFilter.doValue => onDo(),
    TypeFilter.completed => onCompleted(),
    _ => null,
  };

  _updateCollectionOnScreen(CollectionEntity collection) {
    _collection = collection;
    notifyListeners();
  }

  _updateListTaskOnScreen([_]) => collectionRepository.getCollections();
}
