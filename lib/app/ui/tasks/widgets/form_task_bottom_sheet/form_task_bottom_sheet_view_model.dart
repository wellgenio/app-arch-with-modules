import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../modules/task/data/repositories/task_repository.dart';
import '../../../../modules/task/domain/dtos/task_dto.dart';
import '../../../../modules/task/domain/entities/task_entity.dart';
import '../../../../utils/command.dart';

class FormTaskBottomSheetViewModel extends ChangeNotifier {
  final ITaskRepository taskRepository;

  FormTaskBottomSheetViewModel(this.taskRepository) {
    addTaskCommand = Command1(taskRepository.addTask);
    updateTaskCommand = Command1(_updateTask);
  }

  late final Command1<Unit, TaskDto> addTaskCommand;

  late final Command1<Unit, TaskDto> updateTaskCommand;

  late final Command0<List<TaskEntity>> getTasksCommand;

  AsyncResult<Unit> _updateTask(TaskDto dto) {
    return taskRepository.updateTask(dto).onSuccess((_) {
    });
  }
}
