import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'data/repositories/task_repository.dart';
import 'data/services/task_service.dart';

List<SingleChildWidget> get taskModuleProviders {
  return [
    Provider(
      create: (context) => TaskService(context.read()),
    ),
    Provider(
      create: (context) => TaskRepository(context.read<TaskService>()) as ITaskRepository,
    ),
  ];
}
