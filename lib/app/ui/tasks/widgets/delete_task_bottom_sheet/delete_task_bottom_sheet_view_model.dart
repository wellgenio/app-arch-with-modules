import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/task/data/repositories/task_repository.dart';
import '../../../../modules/task/domain/entities/task_entity.dart';

import 'package:modular_di_app/app/utils/command.dart';

class DeleteTaskBottomSheetViewModel extends ChangeNotifier{
  final ITaskRepository taskRepository;

  DeleteTaskBottomSheetViewModel(this.taskRepository) {
    deleteTaskCommand = Command1(_deleteTask);
  }

  late final Command1<Unit, TaskEntity> deleteTaskCommand;

  AsyncResult<Unit> _deleteTask(TaskEntity entity) =>
      taskRepository.deleteTask(entity).onSuccess(updateListTask);

  updateListTask(_) => taskRepository.getTasks();
}
