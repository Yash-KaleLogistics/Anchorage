
import '../../model/user_data_model.dart';

class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserDataModel userDataModel;
  LoginSuccess(this.userDataModel);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}