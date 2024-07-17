import 'package:anchorage/module/userAuth/services/user_auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_services.dart';
import 'login_state.dart';


class LoginCubit extends Cubit<LoginState>{
  LoginCubit() : super( LoginInitial() );

  UserAuthRepository userAuthRepository = UserAuthRepository();
  final AuthService authService = AuthService();

  Future<void> login(String email, String userType, String password) async {
    emit(LoginLoading());
    try {
      final userData = await userAuthRepository.login(email, userType, password);

      emit(LoginSuccess(userData));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> checkTokenAndLogoutIfNeeded() async {
    if (!await authService.isTokenValid()) {
      await authService.logout();
      emit(LoginFailure('Token expired, please log in again.'));
    }
  }
}