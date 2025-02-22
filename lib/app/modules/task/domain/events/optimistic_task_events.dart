import '../dtos/task_dto.dart';
import '../entities/task_entity.dart';

abstract class OptimisticTask {}

/// Optimistic Add Task Event
sealed class OptimisticAddTask extends OptimisticTask {}

final class DoOptimisticAddTask extends OptimisticAddTask {
  final TaskDto data;

  DoOptimisticAddTask(this.data);
}

final class UndoOptimisticAddTask extends OptimisticAddTask {
  UndoOptimisticAddTask();
}

/// OOptimistic Delete Task Event
sealed class OptimisticDeleteTask extends OptimisticTask {}

final class DoOptimisticDeleteTask extends OptimisticDeleteTask {
  final TaskEntity data;

  DoOptimisticDeleteTask(this.data);
}

final class UndoOptimisticDeleteTask extends OptimisticDeleteTask {
  UndoOptimisticDeleteTask();
}

/// Optimistic Add Task Event
sealed class OptimisticUpdateTask extends OptimisticTask {}

final class DoOptimisticUpdateTask extends OptimisticUpdateTask {
  final TaskDto data;

  DoOptimisticUpdateTask(this.data);
}

final class DoneOptimisticUpdateTask extends OptimisticUpdateTask {
  DoneOptimisticUpdateTask();
}

final class UndoOptimisticUpdateTask extends OptimisticUpdateTask {
  UndoOptimisticUpdateTask();
}
