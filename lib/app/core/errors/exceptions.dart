import 'package:logger/logger.dart';

const BLOCKED_ERROR_KEY = 'Blocked';

class UnknownException implements Exception {
  const UnknownException();
}

class SimpleServerException<T> implements Exception {
  const SimpleServerException({required this.message});

  final String message;

  @override
  String toString() => '[${T.toString()}] $message';
}

class CacheException<T> implements Exception {
  const CacheException({required this.message, this.error});

  final String message;

  final dynamic error;

  @override
  String toString() => '[${T.toString()}] $message';
}

class DataNotFoundException<T> extends CacheException<T> {
  const DataNotFoundException({
    super.message = 'Data was not found into local storage.',
    super.error,
  });
}

class GetDataException<T> extends CacheException<T> {
  const GetDataException({
    super.message = 'Cannot get Data from local storage.',
    super.error,
  });
}

class PutDataException<T> extends CacheException<T> {
  const PutDataException({
    super.message = 'Cannot put Data into local storage.',
    super.error,
  });
}

class DeleteDataException<T> extends CacheException<T> {
  const DeleteDataException({
    super.message = 'Cannot delete Data from local storage.',
    super.error,
  });
}

class ServerDataNotFoundException<T> extends SimpleServerException<T> {
  const ServerDataNotFoundException({
    super.message = 'Data was not found into remote storage.',
  });
}

class GetReviewsLocalException implements Exception {
  const GetReviewsLocalException({
    this.message = 'Cannot get reviews locally',
  });

  final String? message;

  @override
  String toString() => '[MESSAGE]: ${message!}';
}

void showLogHiveEntriesNotFound(String boxName) => Logger().d(
      'Cannot get entries from hive [$boxName] box',
    );

class ErrorStatusCodeException implements Exception {
  const ErrorStatusCodeException({this.statusCode, this.statusMessage});

  final int? statusCode;
  final String? statusMessage;

  @override
  String toString() {
    if (statusCode != null && statusMessage != null) {
      return '[MESSAGE]: $statusMessage [STATUS CODE]: $statusCode';
    } else {
      return '[MESSAGE]: $statusMessage [STATUS CODE]: $statusCode';
    }
  }
}

class ExitUserException implements Exception {
  const ExitUserException({
    this.message = 'Cannot exit',
  });

  final String? message;

  @override
  String toString() => '[MESSAGE]: ${message!}';
}

class GetUserSettingsRemoteException implements Exception {
  GetUserSettingsRemoteException({
    this.statusCode,
    this.statusMessage = "error while getting user settings from remote datasource",
  });

  final int? statusCode;
  final String? statusMessage;

  @override
  String toString() {
    if (statusCode != null && statusMessage != null) {
      return '[MESSAGE]: $statusMessage [STATUS CODE]: $statusCode';
    } else {
      return '[MESSAGE]: $statusMessage [STATUS CODE]: $statusCode';
    }
  }
}

class TokenRefreshException implements Exception {
  TokenRefreshException({
    this.statusCode,
    this.statusMessage = "error while token refresh",
  });

  final int? statusCode;
  final String? statusMessage;

  @override
  String toString() => '[MESSAGE]: $statusMessage [STATUS CODE]: $statusCode';
}

class EventDataParseException implements Exception {
  EventDataParseException({
    required this.eventName,
    required this.data,
  });

  final String eventName;
  final dynamic data;

  @override
  String toString() => 'Error when parsing data from event (event: $eventName, data: $data)';
}

class CannotConnectToEchoException implements Exception {
  const CannotConnectToEchoException();

  @override
  String toString() => 'Local settings do not contain enough data to connect to echo';
}

class RegionNotAllowedException implements Exception {
  const RegionNotAllowedException();

  @override
  String toString() => 'Chosen region is not allowed';
}

class ProfileBlockedException implements Exception {
  const ProfileBlockedException();
}
