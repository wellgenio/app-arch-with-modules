import 'dart:async';

import 'package:modular_di_app/app/modules/task/domain/dtos/task_dto.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/task_entity.dart';
import '../../domain/events/optimistic_task_events.dart';
import '../services/task_service.dart';

abstract class ITaskRepository {
  Stream<List<TaskEntity>> observerListTask();

  Stream<TaskEntity> observerTask();

  Stream<T> observerOptimisticTask<T extends OptimisticTaskEvent>();

  AsyncResult<List<TaskEntity>> getTasks();

  AsyncResult<TaskEntity> getTask(String taskId);

  AsyncResult<Unit> addTask(TaskDto dto);

  AsyncResult<Unit> updateTask(TaskDto dto);

  AsyncResult<Unit> deleteTask(TaskEntity task);
}

class TaskRepository implements ITaskRepository {
  final TaskService _tasksService;

  late final StreamController<List<TaskEntity>> _streamTasks =
      StreamController.broadcast();

  late final StreamController<TaskEntity> _streamTask =
      StreamController.broadcast();

  String? _cachedTaskId;

  TaskRepository(this._tasksService);

  @override
  Stream<List<TaskEntity>> observerListTask() => _streamTasks.stream;

  @override
  Stream<TaskEntity> observerTask() => _streamTask.stream;

  @override
  AsyncResult<List<TaskEntity>> getTasks() async {
    return _tasksService.getTasks().onSuccess(_streamTasks.add);
  }

  @override
  AsyncResult<TaskEntity> getTask(String taskId) async {
    _cachedTaskId = taskId;
    return _tasksService.getTask(taskId).onSuccess(_streamTask.add);
  }

  late final StreamController<OptimisticTaskEvent> _streamOptimistic =
      StreamController.broadcast();

  @override
  Stream<T> observerOptimisticTask<T extends OptimisticTaskEvent>() =>
      _streamOptimistic.stream.cast<T>();

  @override
  AsyncResult<Unit> addTask(TaskDto dto) async {
    // Optimistic state
    _streamOptimistic.add(OptimisticAddTaskEvent(data: dto));

    return _tasksService //
        .addTask(dto)
        .onSuccess((_) => getTasks()) // Refresh List
        .onFailure((_) =>
            _streamOptimistic.add(OptimisticAddTaskEvent(hasError: true)));
  }

  @override
  AsyncResult<Unit> deleteTask(TaskEntity task) async {
    // Optimistic state
    _streamOptimistic.add(OptimisticDeleteTaskEvent(data: task));

    return _tasksService
        .deleteTask(task.id)
        .onSuccess((_) => getTasks()) // Refresh List
        .onFailure(
          (_) => // Optimistic state
              _streamOptimistic.add(OptimisticDeleteTaskEvent(hasError: true)),
        );
  }

  @override
  AsyncResult<Unit> updateTask(TaskDto dto) async {
    _streamOptimistic.add(OptimisticUpdateTaskEvent(data: dto));

    return _tasksService.updateTask(dto).onSuccess((_) {
      if (_cachedTaskId != null) {
        getTask(_cachedTaskId!);
      }
      getTasks();
      _streamOptimistic.add(OptimisticUpdatedTaskEvent());
    }).onFailure(
      (_) => _streamOptimistic.add(OptimisticUpdateTaskEvent(hasError: true)),
    );
  }
}
