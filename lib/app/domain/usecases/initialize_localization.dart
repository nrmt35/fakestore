import 'package:dartz/dartz.dart';
import 'package:fakestore/app/core/errors/failure.dart';
import 'package:fakestore/app/core/usecases/usecase.dart';
import 'package:fakestore/gen/strings.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializeLocalizations implements UseCase<NoParams, NoParams> {
  InitializeLocalizations(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<Either<Failure, NoParams>> call(NoParams noParams) async {
    await LocaleSettings.setLocaleRaw('en_En');
    return const Right(NoParams());
  }
}
