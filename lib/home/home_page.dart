import 'package:anchorage/core/style.dart';
import 'package:anchorage/core/style.dart';
import 'package:anchorage/module/Airport/page/add_edit_airport_page.dart';
import 'package:anchorage/module/Airport/page/airport_list_page.dart';
import 'package:anchorage/module/City/page/add_edit_city_page.dart';
import 'package:anchorage/module/City/page/city_list_page.dart';
import 'package:anchorage/module/State/page/add_edit_state_page.dart';
import 'package:anchorage/module/State/page/state_list_page.dart';
import 'package:anchorage/module/agent/page/agent_main_page.dart';
import 'package:anchorage/module/airline/page/airline_main_page.dart';
import 'package:anchorage/screen/Agent/agent_post_load_screen.dart';
import 'package:anchorage/screen/Airline/airline_create_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../module/Country/page/add_edit_country_page.dart';
import '../module/Country/page/country_list_page.dart';
import '../module/userAuth/services/auth_services.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

  final AuthService _authService = AuthService();
  String? _userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final userName = await _authService.getUserData();
    setState(() {
      _userName = userName!.user!.name;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Select"),
      ),

      body: Center(
        child: Column(
          children: [

           /* _userName != null
                ? Text('Welcome, $_userName!', style: TextStyle(fontSize: 24))
                : CircularProgressIndicator(),*/
            
            
            GestureDetector(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => AirlineMainPage(),));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.orangeAccent),
                  child: Text("Airline", style: boldDefault.copyWith(fontSize: 20),)),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => AgentMainPage(),));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.orangeAccent),
                  child: Text("Agent",  style: boldDefault.copyWith(fontSize: 20))),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => CountryListPage(),));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.orangeAccent),
                  child: Text("Add Airport",  style: boldDefault.copyWith(fontSize: 20))),
            ),



          ],
        ),
      ),
    );
  }
}
