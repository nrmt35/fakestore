import 'package:fakestore/app/core/errors/failure.dart';

class TooFrequentRatingUpdatedFailure extends Failure {
  const TooFrequentRatingUpdatedFailure()
      : super('Rating updated too frequent');
}
