import 'dart:async';

import 'package:modular_di_app/app/modules/task/domain/dtos/task_dto.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/task_entity.dart';
import '../services/task_service.dart';

abstract class ITaskRepository {
  Stream<List<TaskEntity>> observerListTask();

  Stream<TaskEntity> observerTask();

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
    return _tasksService.getTask(taskId)
        .onSuccess(_streamTask.add);
  }

  @override
  AsyncResult<Unit> addTask(TaskDto dto) async {
    return _tasksService.addTask(dto).onSuccess((_) => getTasks());
  }

  @override
  AsyncResult<Unit> deleteTask(TaskEntity task) async {
    return _tasksService.deleteTask(task.id).onSuccess((_) => getTasks());
  }

  @override
  AsyncResult<Unit> updateTask(TaskDto dto) async {
    return _tasksService.updateTask(dto).onSuccess((_) {
      if (_cachedTaskId != null) {
        getTask(_cachedTaskId!);
      }
      getTasks();
    });
  }
}
