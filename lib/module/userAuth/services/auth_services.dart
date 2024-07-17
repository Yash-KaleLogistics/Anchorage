import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_data_model.dart';

class AuthService {

  Future<void> saveUserData(UserDataModel userDataModel) async {
    final prefs = await SharedPreferences.getInstance();
    final token = userDataModel.token;
    final userData = jsonEncode(userDataModel.toJson());

    await prefs.setString('token', token ?? '');
    await prefs.setString('user', userData);
  }

  Future<UserDataModel?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user');

    if (userDataString != null) {
      final userDataJson = jsonDecode(userDataString);
      return UserDataModel.fromJson(userDataJson);
    }

    return null;
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return false;
    }

    return !JwtDecoder.isExpired(token);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
