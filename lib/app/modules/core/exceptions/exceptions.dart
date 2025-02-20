abstract class BaseException implements Exception {
  const BaseException({
    required this.message,
    this.data,
    this.statusCode,
    this.stackTracing,
  });

  final dynamic data;
  final String message;
  final int? statusCode;
  final dynamic stackTracing;
}

class AdapterException extends BaseException {
  AdapterException({required super.message});
}

class StorageException extends BaseException {
  StorageException({required super.message});
}

class UnknownException extends BaseException {
  UnknownException({required super.message});
}
