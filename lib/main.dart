import 'package:anchorage/module/Airport/services/logic/airport_cubit.dart';
import 'package:anchorage/module/State/services/logic/state_cubit.dart';
import 'package:anchorage/module/userAuth/login/sign_in_screen.dart';
import 'package:anchorage/module/userAuth/services/logic/login_cubit.dart';
import 'package:anchorage/splash_screen.dart';
import 'package:anchorage/sql_data/logic/airline_cubit/airline_create_cubit.dart';
import 'package:anchorage/sql_data/logic/airline_search_cubit/airline_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'home/home_page.dart';
import 'module/City/services/logic/city_cubit.dart';
import 'module/Country/services/logic/country_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AirlineAddCubit(),),
            BlocProvider(create: (context) => AirlineSearchCubit(),),
            BlocProvider(create: (context) => CountryCubit(),),
            BlocProvider(create: (context) => StateCubit(),),
            BlocProvider(create: (context) => CityCubit(),),
            BlocProvider(create: (context) => AirportCubit(),),
            BlocProvider(create: (context) => LoginCubit(),),
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: SplashScreen(),
          ),
        );
      }
    );
  }
}
