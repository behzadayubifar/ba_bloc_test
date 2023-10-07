import 'package:ba_flutter_testing_block/models/models.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  // singleton pattern
  // const LoginApi._sharedInstatnce();
  // static const LoginApi _shared = LoginApi._sharedInstatnce();
  // factory LoginApi.instance() => _shared;
  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        Duration(seconds: 2),
        () => email == 'foo@bar.com' && password == 'fooBar',
      ).then(
        (isLoggedIn) => isLoggedIn ? LoginHandle.fooBar() : null,
      );
}
