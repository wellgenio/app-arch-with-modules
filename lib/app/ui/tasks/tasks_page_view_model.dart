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

enum TypeFilter { all, doValue, completed }

class TasksPageViewModel extends ChangeNotifier {
  final ITaskRepository taskRepository;

  TasksPageViewModel(this.taskRepository) {
    getTasksCommand = Command0(_getTasks);
    checkedCommand = Command1(_onChecked);

    taskRepository.observerTasks().listen(_updateScreen);
  }

  TypeFilter _filter = TypeFilter.all;

  List<TaskEntity> _tasks = [];

  List<TaskEntity> _filteredTasks = const [];

  List<TaskEntity> get tasks => _filter != TypeFilter.all //
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
    return taskRepository
        .updateTask(dto)
        .flatMap((_) => _getTasks())
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

  _updateScreen(List<TaskEntity> value) {
    _tasks = value;
    notifyListeners();
  }
}
