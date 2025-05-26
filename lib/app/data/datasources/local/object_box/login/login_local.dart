import 'package:fakestore/app/data/models/auth/login_response/login_response.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class LoginLocal {
  LoginLocal({
    required this.token,
    this.id = 0,
  });

  factory LoginLocal.fromModel(LoginResponse entity) => LoginLocal(
        token: entity.token,
      );

  LoginResponse toModel() => LoginResponse(
        token: token,
      );

  int id;

  String token;
}
