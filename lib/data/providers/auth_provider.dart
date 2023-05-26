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
  Future<Result> register(User user) async {
    Result result = await _authRepository.register(user);
    if (result is Success) {
      _user = result.value as User?;
    }
    return result;
  }

  Future<Result> login(String email, String password) async {
    Result result = await _authRepository.login(email, password);
    if (result is Success) {
      _user = result.value;
    }
    return result;
  }

  Future<void> logout() async {
   await _authRepository.logout();
  }
  void setUser(User? user) {
    _user = user;
  }

}
