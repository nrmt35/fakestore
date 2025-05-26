import 'package:fakestore/app/core/errors/failure.dart';

class CustomerLogoutFailure extends Failure {
  const CustomerLogoutFailure() : super('failed to logout');
}
