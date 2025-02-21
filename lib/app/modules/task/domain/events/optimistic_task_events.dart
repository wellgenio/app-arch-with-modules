import '../dtos/task_dto.dart';
import '../entities/task_entity.dart';

abstract class OptimisticTaskEvent {}

/// Optimistic Add Task Event
sealed class OptimisticAddTaskEvent extends OptimisticTaskEvent {}

final class OptimisticAddTaskLoadingEvent extends OptimisticAddTaskEvent {
  final TaskDto data;

  OptimisticAddTaskLoadingEvent(this.data);
}

final class OptimisticAddTaskErrorEvent extends OptimisticAddTaskEvent {
  OptimisticAddTaskErrorEvent();
}

/// OOptimistic Delete Task Event
sealed class OptimisticDeleteTaskEvent extends OptimisticTaskEvent {}

final class OptimisticDeleteTaskLoadingEvent extends OptimisticDeleteTaskEvent {
  final TaskEntity data;

  OptimisticDeleteTaskLoadingEvent(this.data);
}

final class OptimisticDeleteTaskErrorEvent extends OptimisticDeleteTaskEvent {
  OptimisticDeleteTaskErrorEvent();
}

/// Optimistic Add Task Event
sealed class OptimisticUpdateTaskEvent extends OptimisticTaskEvent {}

final class OptimisticUpdateTaskLoadingEvent extends OptimisticDeleteTaskEvent {
  final TaskDto data;

  OptimisticUpdateTaskLoadingEvent(this.data);
}

final class OptimisticUpdateTaskCompletedEvent extends OptimisticDeleteTaskEvent {
  OptimisticUpdateTaskCompletedEvent();
}

final class OptimisticUpdateTaskErrorEvent extends OptimisticDeleteTaskEvent {
  OptimisticUpdateTaskErrorEvent();
}
