import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../modules/task/domain/entities/task_entity.dart';
import '../../../utils/command.dart';
import '../../../modules/task/data/repositories/task_repository.dart';

class TaskDetailsPageViewModel extends ChangeNotifier {
  final ITaskRepository taskRepository;

  TaskDetailsPageViewModel(this.taskRepository) {
    getTaskCommand = Command1(_getTask);
  }

  TaskEntity _task = TaskEntity.empty();

  TaskEntity get task => _task;

  late final Command1<TaskEntity, int> getTaskCommand;

  AsyncResult<TaskEntity> _getTask(int taskId) => taskRepository
      .getTask(taskId)
      .onSuccess(updateScreen)
      .onSuccess(updateListTask);

  updateScreen(TaskEntity task) {
    _task = task;
    notifyListeners();
  }

  updateListTask(_) => taskRepository.getTasks();
}
