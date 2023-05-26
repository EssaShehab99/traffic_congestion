import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import '/data/local/sharedpref_helper/preference_variable.dart';
import '/data/local/sharedpref_helper/preferences.dart';
import '/data/models/user.dart';
import '/data/network/data_response.dart';
import '/data/network/api/auth_api.dart';

class AuthRepository {
  final AuthApi _authApi;
  final _preferences = Preferences.instance;
  AuthRepository(this._authApi);

  Future<Result> register(User user) async {
    try {
      debugPrint(
          "==========AuthRepository->signUp->user:${user.toJson()} ==========");
      String? id = await _authApi.register(user.toJson());
      user.id=id;
      await _preferences.delete(PreferenceVariable.user);
      await _preferences.insert(
          PreferenceVariable.user, jsonEncode(user.toJson()));
      return Success(user);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Error('The email address is already in use by another account.');
      } else if (e.code == 'invalid-email') {
        return Error('The email address is invalid.');
      } else if (e.code == 'operation-not-allowed') {
        return Error('This operation is not allowed.');
      } else if (e.code == 'weak-password') {
        return Error('The password is too weak.');
      } else {
        return Error('An error occurred while registering the user.');
      }
    } catch (e) {
      return Error('An error occurred while registering the user.');
    }
  }
  Future<Result> login(String email, String password) async {
    try {
      final data = await _authApi.login(email, password);
      final user = User.fromJson(data);
      await _preferences.delete(PreferenceVariable.user);
      await _preferences.insert(
          PreferenceVariable.user, jsonEncode(user.toJson()));
      return Success(user);
    } on auth.FirebaseException catch (e) {
     return Error(e.message);
    } catch (e) {
      return Error('An error occurred while logging in');
    }
  }

  Future<Result> logout() async {
    try {
      await _authApi.logout();
      bool status = await _preferences.delete(PreferenceVariable.user);
      return Success(status);
    } catch (e) {
      return Error(e.toString());
    }
  }

  // Future<bool> changePassword(String email, String password) async {
  //   try {
  //     return await _authApi.changePassword(email, {"password": password});
  //   } catch (_) {
  //     return false;
  //   }
  // }
}
