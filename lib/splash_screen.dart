import 'package:anchorage/home/home_page.dart';
import 'package:anchorage/module/userAuth/login/sign_in_screen.dart';
import 'package:anchorage/screen/Agent/agent_post_load_screen.dart';
import 'package:flutter/material.dart';

import 'module/agent/page/agent_main_page.dart';
import 'module/airline/page/airline_main_page.dart';
import 'module/userAuth/services/auth_services.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkTokenStatus();
  }

  Future<void> _checkTokenStatus() async {
    if (await _authService.isTokenValid()) {
      // Token is valid, navigate to home screen
      final user = await _authService.getUserData();
      if(user!.user!.userType!.contains("Agent")){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AgentMainPage()),
        );
      }else if(user.user!.userType!.contains("Airline")){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AirlineMainPage()),
        );
      }
    } else {
      // Token is invalid or expired, navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
