
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../sql_data/api/sql_api.dart';
import '../model/user_data_model.dart';
import 'auth_services.dart';

class UserAuthRepository{
  SqlApi api = SqlApi();
  final AuthService authService = AuthService();

  Future<String> userSignUp(Map<String, dynamic> data) async {
    try {
      Response response = await api.sendRequest.post("auth/signup", data: data);
      return response.statusMessage.toString();
    } catch(ex) {
      throw ex.toString();
    }
  }

  Future<UserDataModel> login(String email, String userType, String password) async {
    try {
      Response response = await api.sendRequest.post("/login", data: {
        'email': email,
        'userType': userType,
        'password': password
      });

      if (response.statusCode == 200) {
        UserDataModel userDataModel = UserDataModel.fromJson(response.data);
        await authService.saveUserData(userDataModel);
        return userDataModel;
      } else {
        // Handle non-200 response
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: response.data['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      if (e is DioError) {
        throw e.response?.data['message'] ?? 'Failed to login';
      } else {
        throw 'An unexpected error occurred';
      }
    }
  }

  Future<String> forgotpassword(Map<String, dynamic> data) async {
    try {
      Response response = await api.sendRequest.put("auth/forgot-password", data: data);
      return response.statusMessage.toString();
    } catch(ex) {
      throw ex.toString();
    }
  }


/*  Future<EmailSendModel> emailSend(String senderName, String senderEmail, String textPassword, int forgot) async {
    try {
      Response response = await api.sendRequest.post("/send-email",  data: {'name' : senderName, 'to': senderEmail, 'text': textPassword, 'forgot' : forgot});
      EmailSendModel emailSendModel = EmailSendModel.fromJson(response.data);
      return emailSendModel;
    } catch (e) {
      throw e;
    }
  }*/

}