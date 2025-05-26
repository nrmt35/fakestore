import 'package:fakestore/app/core/extensions/extensions.dart';

class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure(
    super.message,
  );
}

class LinkFailure extends Failure {
  const LinkFailure() : super('Request not executed');
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class UnknownFailure extends Failure {
  UnknownFailure(Exception exception) : super(exception.getMessage);
}

class PhoneAlreadyInUse extends Failure {
  PhoneAlreadyInUse(Exception exception) : super(exception.getMessage);
}

/// Auth failures
class NoLocalTokenFailure extends Failure {
  const NoLocalTokenFailure() : super('No token in settings failure');
}

class ResponseWithoutTokenFailure extends Failure {
  const ResponseWithoutTokenFailure() : super('Server response not contains token');
}

/// Settings failures
class NoSettingsFailure extends Failure {
  const NoSettingsFailure() : super('Cache not contains settings failure');
}
