import 'package:modular_di_app/app/modules/core/exceptions/exceptions.dart';

import '../../../domain/entities/collection_entity.dart';

class CollectionAdapter {
  static CollectionEntity fromJson(Map<String, dynamic> data) {
    try {
      return CollectionEntity(
        id: data['id'],
        title: data['title'] as String,
        tasks: (data['tasks'] as List).map((data) => (data as String)).toList(),
      );
    } catch (e) {
      throw AdapterException(message: e.toString());
    }
  }
}
