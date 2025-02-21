import 'dart:async';

import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../modules/collection/domain/usecases/get_tasks_by_collection.dart';
import '../../../modules/core/event_bus/event_bus.dart';
import '../../../modules/task/data/repositories/task_repository.dart';
import '../../../modules/task/domain/dtos/task_dto.dart';
import '../../../modules/task/domain/entities/task_entity.dart';
import '../../../modules/collection/data/repositories/collection_repository.dart';
import '../../../modules/collection/domain/entities/collection_entity.dart';
import '../../../modules/task/domain/events/optimistic_task_events.dart';
import '../../../utils/command.dart';

typedef CheckedParams = ({
  String collectionId,
  TaskEntity task,
  bool value,
});

enum TypeFilter { all, doValue, completed }

class CollectionDetailsPageViewModel extends ChangeNotifier {
  final ICollectionRepository collectionRepository;
  final ITaskRepository taskRepository;
  final GetTasksByCollection getTasksByCollection;

  final EventBus eventBus;

  CollectionDetailsPageViewModel(
    this.collectionRepository,
    this.taskRepository,
    this.getTasksByCollection,
    this.eventBus,
  ) {
    getCollectionCommand = Command1(_getCollection);
    checkedCommand = Command1(_onChecked);

    subscriptionCollection = collectionRepository
        .observerCollection()
        .listen(_updateCollectionOnScreen);

    subscriptionOptimisticTask =
        taskRepository.observerOptimisticTask().listen(_refreshCollection);
  }

  String? _cachedCollectionId;

  bool canRefresh = false;

  CollectionEntity _collection = CollectionEntity.empty();

  CollectionEntity get collection => _collection;

  TypeFilter _filter = TypeFilter.all;

  List<TaskEntity> _tasks = [];

  List<TaskEntity> _filteredTasks = const [];

  List<TaskEntity> get tasks => _filter != TypeFilter.all //
      ? _filteredTasks
      : _tasks;

  bool get hasTasks => _tasks.isNotEmpty;

  late final Command1<List<TaskEntity>, String> getCollectionCommand;

  late final Command1<Unit, CheckedParams> checkedCommand;

  late final StreamSubscription<CollectionEntity> subscriptionCollection;

  late final StreamSubscription<OptimisticTaskEvent> subscriptionOptimisticTask;

  AsyncResult<List<TaskEntity>> _getCollection(String collectionId) async {
    _cachedCollectionId = collectionId;

    return await collectionRepository
        .getCollection(collectionId)
        .onSuccess(_updateCollectionOnScreen)
        .flatMap(getTasksByCollection.call)
        .onSuccess(_updateListTaskByCollectionOnScreen);
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

  _updateListTaskByCollectionOnScreen(List<TaskEntity> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  _refreshCollection(OptimisticTaskEvent event) {
    if (event is! OptimisticUpdatedTaskEvent ||
        event is! OptimisticAddTaskEvent) {
      return;
    }

    if (_cachedCollectionId != null) {
      _getCollection(_cachedCollectionId!);
    }
  }

  @override
  void dispose() {
    print('SAIU Collection');
    subscriptionCollection.cancel();
    subscriptionOptimisticTask.cancel();
    super.dispose();
  }
}
