import '../dtos/task_dto.dart';
import '../entities/task_entity.dart';

sealed class OptimisticTaskEvent {}

final class OptimisticAddTaskEvent extends OptimisticTaskEvent {
  TaskDto? data;
  bool hasError;

  OptimisticAddTaskEvent({this.data, this.hasError = false});
}

final class OptimisticDeleteTaskEvent extends OptimisticTaskEvent {
  TaskEntity? data;
  bool hasError;

  OptimisticDeleteTaskEvent({this.data, this.hasError = false});
}

final class OptimisticUpdateTaskEvent extends OptimisticTaskEvent {
  TaskDto? data;
  bool hasError;

  OptimisticUpdateTaskEvent({this.data, this.hasError = false});
}

final class OptimisticUpdatedTaskEvent extends OptimisticTaskEvent {
  OptimisticUpdatedTaskEvent();
}
