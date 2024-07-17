import 'dart:convert';
import 'dart:developer';


import 'package:anchorage/home/home_page.dart';
import 'package:anchorage/module/agent/page/agent_main_page.dart';
import 'package:anchorage/module/airline/page/airline_main_page.dart';
import 'package:anchorage/widget/custome_text_wo_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/dimensions.dart';
import '../../../core/my_color.dart';
import '../../../core/style.dart';
import '../../../widget/custom_divider.dart';
import '../../../widget/rounded_button.dart';
import '../model/user_data_model.dart';
import '../services/logic/login_cubit.dart';
import '../services/logic/login_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoggedIn = false;
  UserDataModel? _userModel;
  UserDataModel get userModel => _userModel!;

  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var userType = "Agent";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: Dimensions.space20),
        Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.space22,
          vertical: Dimensions.space15,
        ),
        child: Column(
          children: [
          Text(
          "Sign In",
          style: semiBoldMediumLarge.copyWith(fontSize: Dimensions.space25),
        ),
        const SizedBox(height: Dimensions.space10),
        // const SocialLoginSection(),
        const CustomDivider(
          space: Dimensions.space10,
        ),

        BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {

              if(state.userDataModel.user!.userType == "Agent"){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AgentMainPage()),
                );
                emailController.clear();
                passwordController.clear();
              }else if(state.userDataModel.user!.userType == "Airline"){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AirlineMainPage()),
                );
                emailController.clear();
                passwordController.clear();
              }

            } else if (state is LoginFailure) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
              ));
            }
          },
          builder: (context, state) {
            return Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              activeColor: Colors.black,
                              fillColor: MaterialStateProperty.resolveWith(
                                    (states) {
                                  if (states
                                      .contains(MaterialState.selected)) {
                                    return Colors.black;
                                  }
                                  return Colors.black45;
                                },
                              ),
                              value: 'Agent',
                              toggleable: true,
                              groupValue: userType,
                              onChanged: (value) {
                                setState(() {
                                  userType = value!;
                                });
                              },
                            ),
                            Text(
                              'Agent',
                              style: GoogleFonts.poppins(
                                textStyle: boldMediumLarge.copyWith(
                                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<String>(
                              activeColor: Colors.black,
                              fillColor: MaterialStateProperty.resolveWith(
                                    (states) {
                                  if (states
                                      .contains(MaterialState.selected)) {
                                    return Colors.black;
                                  }
                                  return Colors.black45;
                                },
                              ),
                              value: 'Airline',
                              toggleable: true,
                              groupValue: userType,
                              onChanged: (value) {
                                setState(() {
                                  userType = value!;
                                });
                              },
                            ),
                            Text(
                              'Airline',
                              style: GoogleFonts.poppins(
                                textStyle: boldMediumLarge.copyWith(
                                    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dimensions.space20,
                    ),
                    CustomeTextWOBorder(
                      cursorColor: Colors.black,
                      fontColor: Colors.black,
                      controller: emailController,
                      onChanged: (value) {},
                      hintText: "Email",
                      isShowSuffixIcon: false,
                      isPassword: false,
                      hasIcon: true,
                      prefixicon: Icons.person_2_outlined,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      circularCorner: 20,
                      fillColor: Colors.grey.shade50,
                      verticalPadding: 20,
                      fontSize: 16,
                      prefixIconcolor: Colors.black45,
                      hintTextcolor: Colors.black45,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill out this field";
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(height: Dimensions.space20),
                    CustomeTextWOBorder(
                      cursorColor: Colors.black,
                      fontColor: Colors.black,
                      controller: passwordController,
                      onChanged: (value) {},
                      hintText: "Password",
                      isShowSuffixIcon: true,
                      isPassword: true,
                      hasIcon: true,
                      prefixicon: Icons.person_2_outlined,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      circularCorner: 20,
                      fillColor: Colors.grey.shade50,
                      verticalPadding: 20,
                      fontSize: 16,
                      prefixIconcolor: Colors.black45,
                      hintTextcolor: Colors.black45,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please fill out this field";
                        } else {
                          return null;
                        }
                      },
                    ),


                    const SizedBox(height: Dimensions.space25),
                    RoundedButton(
                        color: MyColor.leaderBoardContainer,
                        text: state is LoginLoading ? 'Loading...' : 'Sign In',
                        press: () {

                          Navigator.push(context, CupertinoPageRoute(builder: (context) => HomePageScreen(),));

                          /*if (formKey.currentState!.validate()) {
                            context.read<LoginCubit>().login(
                              emailController.text,
                              userType,
                              passwordController.text
                            );
                          }*/
                        }),

                  ],
                ));
          },
        )
        ],
              ),
            )],
            ),
      )
    ,
    );
  }

}
