import 'dart:async';
import 'dart:developer';

import 'package:modular_di_app/app/modules/task/domain/dtos/task_dto.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/entities/task_entity.dart';
import '../services/task_service.dart';

abstract class ITaskRepository {
  AsyncResult<List<TaskEntity>> getTasks();

  AsyncResult<TaskEntity> getTask(int taskId);

  AsyncResult<Unit> addTask(TaskDto dto);

  AsyncResult<Unit> updateTask(TaskDto dto);

  AsyncResult<Unit> deleteTask(TaskEntity task);

  Stream<List<TaskEntity>> observerTasks();
}

class TaskRepository implements ITaskRepository {
  final TaskService tasksService;
  final bool isCacheEnabled;
  final bool isErrorEnabled;

  TaskRepository.cached(this.tasksService)
      : isCacheEnabled = true,
        isErrorEnabled = false;

  TaskRepository.noCache(this.tasksService)
      : isCacheEnabled = false,
        isErrorEnabled = false;

  TaskRepository.error(this.tasksService)
      : isCacheEnabled = true,
        isErrorEnabled = true;

  List<TaskEntity>? _cachedTasks = [
    TaskEntity(id: 1, title: 'Teste 1'),
    TaskEntity(id: 2, title: 'Teste 2'),
  ];

  late final StreamController<List<TaskEntity>> _streamCtrl =
      StreamController.broadcast();

  @override
  AsyncResult<List<TaskEntity>> getTasks() async {
    if (isCacheEnabled && _cachedTasks != null) {
      if (isErrorEnabled) {
        throw 'You have already fetched the profile';
      }
      log('$TaskRepository: returning cached tasks');
      _streamCtrl.add(_cachedTasks!);
      return Success(_cachedTasks!);
    }

    final tasks = await tasksService.getTasks();
    if (isCacheEnabled) {
      _cachedTasks = tasks.getOrNull();
      _streamCtrl.add(_cachedTasks!);
    }

    return tasks;
  }

  int currentId = 3;

  @override
  AsyncResult<Unit> addTask(TaskDto dto) async {
    _cachedTasks?.add(TaskEntity(id: currentId++, title: dto.title));
    return Success(unit);
  }

  @override
  AsyncResult<Unit> deleteTask(TaskEntity task) async {
    _cachedTasks?.removeWhere((data) => data.id == task.id);
    return Success(unit);
  }

  @override
  AsyncResult<Unit> updateTask(TaskDto dto) async {
    _cachedTasks?.removeWhere((data) => data.id == dto.id);
    _cachedTasks?.add(TaskEntity(id: dto.id!, title: dto.title));
    return Success(unit);
  }

  @override
  Stream<List<TaskEntity>> observerTasks() => _streamCtrl.stream;

  @override
  AsyncResult<TaskEntity> getTask(int taskId) async {
    if (_cachedTasks == null) return Failure(Exception('not found task'));

    final task = _cachedTasks!.firstWhere((data) => data.id == taskId);

    return Success(task);
  }
}
