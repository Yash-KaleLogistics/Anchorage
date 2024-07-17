import 'package:anchorage/module/userAuth/login/sign_in_screen.dart';
import 'package:anchorage/screen/Agent/agent_post_load_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../../../core/images.dart';
import '../../../core/my_color.dart';
import '../../userAuth/services/auth_services.dart';

class AgentMainPage extends StatefulWidget {
  const AgentMainPage({super.key});

  @override
  State<AgentMainPage> createState() => _AgentMainPageState();
}

class _AgentMainPageState extends State<AgentMainPage> {
  int selected = 0;
  final controller = PageController();

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          width: double.infinity,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Text("Welcome Agent ")),
        actions: [
          IconButton(onPressed: () {
            _authService.logout();
            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => SignInScreen(),), (route) => false,);
          }, icon: Icon(Icons.login_rounded))
        ],
      ),
      backgroundColor: Colors.white,
      extendBody: true,
      body: SafeArea(
        child: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: const [
            Center(child: Text('Home')),
            Center(child: Text('Status')),
            Center(child: Text('Flights')),
            Center(child: Text('Profile')),
          ],
        ),
      ),
      bottomNavigationBar: StylishBottomBar(

        option: DotBarOptions(
          dotStyle: DotStyle.circle,
          gradient: const LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.pink,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              CupertinoIcons.home,
            ),

            selectedIcon: const Icon(CupertinoIcons.home),
            selectedColor: Colors.black87,
            unSelectedColor: Colors.black45,
            title: const Text('Home'),
            badge: const Text('9+'),
            showBadge: true,
            badgeColor: Colors.green,
            badgePadding: const EdgeInsets.only(left: 4, right: 4),
          ),
          BottomBarItem(
            icon: const Icon(Icons.notifications_active_rounded),
            selectedIcon: const Icon(Icons.notifications_active_rounded),
            selectedColor: Colors.black87,
            unSelectedColor: Colors.black45,
            // unSelectedColor: Colors.purple,
            // backgroundColor: Colors.orange,
            title: const Text('Status'),
          ),
          BottomBarItem(
              icon: const Icon(
                Icons.flight_takeoff_outlined,
              ),
              selectedIcon: const Icon(
                Icons.flight_takeoff_rounded,
              ),
              selectedColor: Colors.black87,
              unSelectedColor: Colors.black45,
              title: const Text('Flights')),
          BottomBarItem(
              icon: const Icon(
                Icons.person_outline,
              ),
              selectedIcon: const Icon(
                Icons.person,
              ),
              selectedColor: Colors.black87,
              unSelectedColor: Colors.black45,
              title: const Text('Profile')),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.end,
        currentIndex: selected,
        notchStyle: NotchStyle.square,

        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) => AgentPostLoadScreen(),));
        },
        backgroundColor: Colors.white,
        child: Icon(
          CupertinoIcons.add,
          color: Colors.red,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
