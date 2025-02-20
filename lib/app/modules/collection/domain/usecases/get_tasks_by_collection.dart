import 'package:result_dart/result_dart.dart';

import '../../../task/data/repositories/task_repository.dart';
import '../../../task/domain/entities/task_entity.dart';
import '../entities/collection_entity.dart';

class GetTasksByCollection {
  final ITaskRepository taskRepository;

  GetTasksByCollection(this.taskRepository);

  AsyncResult<List<TaskEntity>> call(CollectionEntity collection) async => //
      taskRepository.getTasks().map((tasks) => //
          tasks.where(checkTaskContainsInCollection(collection)).toList());

  checkTaskContainsInCollection(CollectionEntity collection) =>
      (TaskEntity task) => collection.tasks.contains(task.id);
}
