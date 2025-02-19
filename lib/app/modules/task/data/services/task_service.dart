import 'package:result_dart/result_dart.dart';

import '../../../core/core_module.dart';
import '../../domain/entities/task_entity.dart';

class TaskService {
  final HttpClient httpClient;

  const TaskService(this.httpClient);

  AsyncResult<List<TaskEntity>> getTasks() async => Success([]);
}
