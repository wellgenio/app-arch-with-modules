import 'dart:developer';

import 'package:modular_di_app/app/modules/core/client_http/client_http.dart';
import 'package:modular_di_app/app/modules/task/data/services/adapters/task_adapter.dart';
import 'package:modular_di_app/app/modules/task/domain/dtos/task_dto.dart';
import 'package:result_dart/result_dart.dart';

import '../../../core/exceptions/exceptions.dart';
import '../../domain/entities/task_entity.dart';

class TaskService {
  final IRestClient _httpClient;

  TaskService(this._httpClient);

  AsyncResult<List<TaskEntity>> getTasks() async {
    try {
      final response = await _httpClient.get(RestClientRequest(path: '/tasks'));

      final data = (response.data as List)
          .map((data) => TaskAdapter.fromJson(data))
          .toList();

      return Success(data);
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  AsyncResult<TaskEntity> getTask(String id) async {
    try {
      final response = await _httpClient.get(
        RestClientRequest(path: '/tasks/$id'),
      );

      return Success(TaskAdapter.fromJson(response.data));
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  int count = 3;
  AsyncResult<Unit> addTask(TaskDto dto) async {
    try {
      int countStr = count++;
      dto.id = countStr.toString();

      await _httpClient
          .post(RestClientRequest(path: '/tasks', data: dto.toJson()));

      return Success(unit);
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  AsyncResult<Unit> updateTask(TaskDto dto) async {
    try {
      await _httpClient
          .put(RestClientRequest(path: '/tasks/${dto.id}', data: dto.toJson()));

      return Success(unit);
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  AsyncResult<Unit> deleteTask(String id) async {
    try {
      await _httpClient.delete(RestClientRequest(path: '/tasks/$id'));

      return Success(unit);
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }
}
