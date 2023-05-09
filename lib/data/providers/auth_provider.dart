import 'package:flutter/material.dart';
import '/data/network/data_response.dart';
import '/data/models/user.dart';
import '/data/di/service_locator.dart';
import '/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final _authRepository = getIt.get<AuthRepository>();
  User? _user;
  User? get user => _user;
  String? verificationId;
  Future<Result> register() async {
    if(_user==null)return Error();
    Result result = await _authRepository.register(_user!);
    if (result is Success) {
      _user = result.value as User?;
    }
    return result;
  }

  Future<Result> login(String email, String password) async {
    Result result = await _authRepository.login(email, password);
    if (result is Success) {
      _user = result.value as User?;
    }
    return result;
  }

  void setUser(User? user) {
    _user = user;
  }

}
