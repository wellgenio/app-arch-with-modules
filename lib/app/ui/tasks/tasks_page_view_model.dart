import 'package:flutter/cupertino.dart';
import 'package:result_dart/result_dart.dart';

import '../../modules/task/domain/entities/task_entity.dart';
import '../../modules/task/data/repositories/task_repository.dart';
import '../../utils/command.dart';

class TasksPageViewModel extends ChangeNotifier {
  final ITaskRepository taskRepository;

  TasksPageViewModel(this.taskRepository) {
    getTasksCommand = Command0(_getTasks);

    taskRepository.observerTasks().listen(updateScreen);
  }

  List<TaskEntity> _tasks = [];

  List<TaskEntity> _filteredTasks = const [];

  List<TaskEntity> get tasks => _filteredTasks.isNotEmpty //
      ? _filteredTasks
      : _tasks;

  late final Command0<List<TaskEntity>> getTasksCommand;

  AsyncResult<List<TaskEntity>> _getTasks() => //
      taskRepository.getTasks().onSuccess(updateScreen);

  updateScreen(List<TaskEntity> value) {
    _tasks = value;
    notifyListeners();
  }

  onAll() {
    _filteredTasks = [];
    notifyListeners();
  }

  onDo() {
    _filteredTasks = _tasks.where((data) => data.value == false).toList();
    notifyListeners();
  }

  onCompleted() {
    _filteredTasks = _tasks.where((data) => data.value == true).toList();
    notifyListeners();
  }
}
