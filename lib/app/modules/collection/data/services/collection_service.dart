import 'package:modular_di_app/app/modules/collection/domain/dtos/collection_dto.dart';
import 'package:result_dart/result_dart.dart';

import '../../../core/client_http/i_rest_client.dart';
import '../../../core/client_http/rest_client_request.dart';
import '../../../core/exceptions/exceptions.dart';
import '../../domain/entities/collection_entity.dart';
import 'adapters/collection_adapter.dart';

class CollectionService {
  final IRestClient _httpClient;

  CollectionService(this._httpClient);

  AsyncResult<List<CollectionEntity>> getCollections() async {
    try {
      final response =
          await _httpClient.get(RestClientRequest(path: '/collections'));

      final data = (response.data as List)
          .map((data) => CollectionAdapter.fromJson(data))
          .toList();

      return Success(data);
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  AsyncResult<CollectionEntity> getCollection(String id) async {
    try {
      final response = await _httpClient.get(
        RestClientRequest(path: '/collections/$id'),
      );

      return Success(CollectionAdapter.fromJson(response.data));
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  int count = 1;
  AsyncResult<Unit> addCollection(CollectionDto dto) async {
    try {
      int countStr = count++;
      dto.id = countStr.toString();

      await _httpClient
          .post(RestClientRequest(path: '/collections', data: dto.toJson()));

      return Success(unit);
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  AsyncResult<Unit> updateCollection(CollectionDto dto) async {
    try {
      await _httpClient.put(RestClientRequest(
          path: '/collections/${dto.id}', data: dto.toJson()));

      return Success(unit);
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }

  AsyncResult<Unit> deleteCollection(String id) async {
    try {
      await _httpClient.delete(RestClientRequest(path: '/collections/$id'));

      return Success(unit);
    } on AdapterException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(message: e.toString()));
    }
  }
}
