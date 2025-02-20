import 'package:modular_di_app/app/modules/task/domain/entities/task_entity.dart';

import '../../../../core/exceptions/exceptions.dart';

class TaskAdapter {
  static TaskEntity fromJson(Map<String, dynamic> data) {
    try {
      return TaskEntity(
        id: data['id'],
        title: data['title'] as String,
        value: data['value'] as bool,
      );
    } catch (e) {
      throw AdapterException(message: e.toString());
    }
  }
}
