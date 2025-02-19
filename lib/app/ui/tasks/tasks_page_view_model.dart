import 'package:flutter/cupertino.dart';
import 'package:modular_di_app/app/modules/task/domain/dtos/task_dto.dart';
import 'package:result_dart/result_dart.dart';

import '../../modules/task/domain/entities/task_entity.dart';
import '../../modules/task/data/repositories/task_repository.dart';
import '../../utils/command.dart';

typedef CheckedParams = ({
  TaskEntity task,
  bool value,
});

class TasksPageViewModel extends ChangeNotifier {
  final ITaskRepository taskRepository;

  TasksPageViewModel(this.taskRepository) {
    getTasksCommand = Command0(_getTasks);
    checkedCommand = Command1(_onChecked);

    taskRepository.observerTasks().listen(_updateScreen);
  }

  bool _hasFilter = false;

  List<TaskEntity> _tasks = [];

  List<TaskEntity> _filteredTasks = const [];

  List<TaskEntity> get tasks => _hasFilter //
      ? _filteredTasks
      : _tasks;

  late final Command0<List<TaskEntity>> getTasksCommand;

  late final Command1<Unit, CheckedParams> checkedCommand;

  AsyncResult<List<TaskEntity>> _getTasks() => //
      taskRepository.getTasks().onSuccess(_updateScreen);

  AsyncResult<Unit> _onChecked(CheckedParams params) {
    final dto = TaskDto(
      id: params.task.id,
      title: params.task.title,
      value: params.value,
    );
    return taskRepository.updateTask(dto).onSuccess((_) => _getTasks());
  }

  onAll() {
    _hasFilter = false;
    _filteredTasks = [];
    notifyListeners();
  }

  onDo() {
    _hasFilter = true;
    _filteredTasks = _tasks.where((data) => data.value == false).toList();
    notifyListeners();
  }

  onCompleted() {
    _hasFilter = true;
    _filteredTasks = _tasks.where((data) => data.value == true).toList();
    notifyListeners();
  }

  _updateScreen(List<TaskEntity> value) {
    _tasks = value;
    notifyListeners();
  }
}
