import 'package:fakestore/app/core/errors/failure.dart';

class NoSuchUserFailure extends Failure {
  const NoSuchUserFailure() : super('No such user failure');
}

class UserAlreadyExistFailure extends Failure {
  const UserAlreadyExistFailure() : super('User already exist failure');
}

class WrongCodeFailure extends Failure {
  const WrongCodeFailure() : super('Wrong code failure');
}

class LoginBlockedFailure extends Failure {
  const LoginBlockedFailure(
    this.remained,
  ) : super('Login into application is blocked');

  final Duration remained;
}

class TokenRefreshFailure extends Failure {
  const TokenRefreshFailure() : super('Token refresh failure');
}
