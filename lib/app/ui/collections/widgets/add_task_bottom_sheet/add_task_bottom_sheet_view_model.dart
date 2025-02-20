import 'package:flutter/cupertino.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/collection/data/repositories/collection_repository.dart';
import '../../../../modules/collection/domain/entities/collection_entity.dart';
import '../../../../modules/task/data/repositories/task_repository.dart';
import '../../../../modules/task/domain/entities/task_entity.dart';
import '../../../../utils/command.dart';

typedef AddTaskParam = ({CollectionEntity collection, TaskEntity task});

class AddTaskBottomSheetViewModel extends ChangeNotifier {
  final ICollectionRepository collectionRepository;
  final ITaskRepository taskRepository;

  AddTaskBottomSheetViewModel(this.collectionRepository, this.taskRepository) {
    getTasksCommand = Command0(_getTasks);
    addTaskOnCollectionCommand = Command1(_addTaskOnCollection);
  }

  List<TaskEntity> _tasks = const [];

  List<TaskEntity> _filteredTasks = const [];

  List<TaskEntity> get tasks => _filteredTasks.isNotEmpty //
      ? _filteredTasks
      : _tasks;

  late final Command0<List<TaskEntity>> getTasksCommand;

  late final Command1<Unit, AddTaskParam> addTaskOnCollectionCommand;

  AsyncResult<List<TaskEntity>> _getTasks() => //
      taskRepository.getTasks().onSuccess(_updateTasksOnScreen);

  AsyncResult<Unit> _addTaskOnCollection(AddTaskParam params) => //
      collectionRepository.addTask(params.collection, params.task.id);

  _updateTasksOnScreen(List<TaskEntity> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  search(String term) {
    if (term.isNotEmpty) {
      _filteredTasks = _tasks
          .where(
              (data) => data.title.toLowerCase().contains(term.toLowerCase()))
          .toList();
    } else {
      _filteredTasks = [];
    }
    notifyListeners();
  }
}
