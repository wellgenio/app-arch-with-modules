import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../global_events/updated_task_event.dart';
import '../../../../modules/core/event_bus/event_bus.dart';
import '../../../../modules/task/data/repositories/task_repository.dart';
import '../../../../modules/task/domain/dtos/task_dto.dart';
import '../../../../modules/task/domain/entities/task_entity.dart';
import '../../../../utils/command.dart';

class FormTaskBottomSheetViewModel extends ChangeNotifier {
  final ITaskRepository taskRepository;
  final EventBus eventBus;

  FormTaskBottomSheetViewModel(this.taskRepository, this.eventBus) {
    addTaskCommand = Command1(taskRepository.addTask);
    updateTaskCommand = Command1(_updateTask);
  }

  late final Command1<Unit, TaskDto> addTaskCommand;

  late final Command1<Unit, TaskDto> updateTaskCommand;

  late final Command0<List<TaskEntity>> getTasksCommand;

  AsyncResult<Unit> _updateTask(TaskDto dto) {
    return taskRepository.updateTask(dto).onSuccess((_) {
      eventBus.emit(UpdatedTaskEvent(dto.id!));
    });
  }
}
