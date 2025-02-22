import 'dart:async';

import 'package:modular_di_app/app/modules/task/domain/dtos/task_dto.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/events/optimistic_task_events.dart';
import '../services/task_service.dart';

abstract class ITaskRepository {
  Stream<List<TaskEntity>> observerListTask();

  Stream<TaskEntity> observerTask();

  Stream<T> observerOptimisticTask<T extends OptimisticTask>();

  AsyncResult<List<TaskEntity>> getTasks();

  AsyncResult<TaskEntity> getTask(String taskId);

  AsyncResult<Unit> addTask(TaskDto dto);

  AsyncResult<Unit> updateTask(TaskDto dto);

  AsyncResult<Unit> deleteTask(TaskEntity task);

  void notifyLastTaskList(List<TaskEntity> taskList);

  void notifyLatestTaskDisplayed(TaskEntity task);

  void notifyOptimisticState(OptimisticTask state);

  void refreshTaskList([_]);

  void refreshLatestTaskDisplayed(String? taskId);
}

class TaskRepository implements ITaskRepository {
  final TaskService _taskApi;

  late final StreamController<List<TaskEntity>> _streamTasks =
      StreamController.broadcast();

  late final StreamController<TaskEntity> _streamTask =
      StreamController.broadcast();

  late final StreamController<OptimisticTask> _streamOptimistic =
      StreamController.broadcast();

  TaskRepository(this._taskApi);

  @override
  Stream<List<TaskEntity>> observerListTask() => _streamTasks.stream;

  @override
  Stream<TaskEntity> observerTask() => _streamTask.stream;

  @override
  Stream<T> observerOptimisticTask<T extends OptimisticTask>() =>
      _streamOptimistic.stream.cast<T>();

  @override
  AsyncResult<List<TaskEntity>> getTasks() async {
    return _taskApi //
        .getTasks()
        .onSuccess(notifyLastTaskList);
  }

  String? _cachedLatestTaskId;

  @override
  AsyncResult<TaskEntity> getTask(String taskId) async {
    _cachedLatestTaskId = taskId;

    return _taskApi //
        .getTask(taskId)
        .onSuccess(notifyLatestTaskDisplayed);
  }

  @override
  AsyncResult<Unit> addTask(TaskDto dto) async {
    // Optimistic state
    notifyOptimisticState(DoOptimisticAddTask(dto));

    return _taskApi //
        .addTask(dto)
        .onSuccess(refreshTaskList)
        .onFailure((_) => notifyOptimisticState(UndoOptimisticAddTask()));
  }

  @override
  AsyncResult<Unit> deleteTask(TaskEntity task) async {
    // Optimistic state
    notifyOptimisticState(DoOptimisticDeleteTask(task));

    return _taskApi //
        .deleteTask(task.id)
        .onSuccess(refreshTaskList)
        .onFailure(
          (_) => notifyOptimisticState(UndoOptimisticDeleteTask()),
        );
  }

  @override
  AsyncResult<Unit> updateTask(TaskDto dto) async {
    // Optimistic state
    notifyOptimisticState(DoOptimisticUpdateTask(dto));

    return _taskApi.updateTask(dto).onSuccess((_) {
      // Refresh
      refreshTaskList();
      refreshLatestTaskDisplayed(dto.id);
      // Optimistic state
      notifyOptimisticState(DoneOptimisticUpdateTask());
    }).onFailure(
      (_) => notifyOptimisticState(UndoOptimisticUpdateTask()),
    );
  }

  @override
  void notifyLastTaskList(List<TaskEntity> taskList) =>
      _streamTasks.add(taskList);

  @override
  void notifyLatestTaskDisplayed(TaskEntity task) => _streamTask.add(task);

  @override
  void notifyOptimisticState(OptimisticTask state) =>
      _streamOptimistic.add(state);

  @override
  void refreshTaskList([_]) => getTasks();

  @override
  void refreshLatestTaskDisplayed(String? taskId) async {
    if (_cachedLatestTaskId == null || taskId == null) return;

    if (_cachedLatestTaskId == taskId) {
      getTask(_cachedLatestTaskId!);
    }
  }
}
