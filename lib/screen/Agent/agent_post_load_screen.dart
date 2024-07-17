import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/dimensions.dart';
import '../../core/style.dart';
import '../../sql_data/logic/airline_cubit/airline_create_cubit.dart';
import '../../sql_data/logic/airline_cubit/airline_create_state.dart';
import '../../widget/custome_text_wo_border.dart';
import '../../widget/rounded_button.dart';
import 'airline_search_with_load.dart';

class AgentPostLoadScreen extends StatefulWidget {
  const AgentPostLoadScreen({super.key});

  @override
  State<AgentPostLoadScreen> createState() => _AgentPostLoadScreenState();
}

class _AgentPostLoadScreenState extends State<AgentPostLoadScreen> {
  TextEditingController agentNameController = TextEditingController();
  TextEditingController agentFLocationController = TextEditingController();
  TextEditingController agentDLocationController = TextEditingController();
  TextEditingController loadCapacityController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();

  var unitResult = "KG";
  DateTime? _fromDate;



  List<String> selectedDays = [];

  @override
  void dispose() {
    super.dispose();
    agentNameController.dispose();
    agentFLocationController.dispose();
    agentDLocationController.dispose();
    loadCapacityController.dispose();
    fromDateController.dispose();

  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
        fromDateController.text = DateFormat('dd-MM-yyyy').format(_fromDate!);
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Add Agent Post Load",
            style: GoogleFonts.poppins(
              textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
              height: Dimensions.space10,
            ),
            CustomeTextWOBorder(
              cursorColor: Colors.black,
              fontColor: Colors.black,
              controller: agentNameController,
              onChanged: (value) {},
              hintText: "Agent Name",
              isShowSuffixIcon: false,
              isPassword: false,
              prefixicon: Icons.person_2_outlined,
              textInputType: TextInputType.text,
              inputAction: TextInputAction.next,
              circularCorner: 20,
              fillColor: Colors.grey.shade50,
              verticalPadding: 20,
              fontSize: 16,
              prefixIconcolor: Colors.black45,
              hintTextcolor: Colors.black45,
            ),
            SizedBox(
              height: Dimensions.space20,
            ),

            Row(
              children: [
                Column(
                  children: [
                    Icon(Icons.adjust_rounded, color: Colors.green,),
                    Dash(
                        direction: Axis.vertical,
                        length: 40,
                        dashLength: 8,
                        dashColor: Colors.grey),
                    Icon(Icons.location_on_rounded, color: Colors.redAccent,)
                  ],
                ),

                SizedBox(width: 10,),

                Expanded(
                  child: Column(
                    children: [
                      CustomeTextWOBorder(
                        fontColor: Colors.black,
                        cursorColor: Colors.black,
                        controller: agentFLocationController,
                        onChanged: (value) {},
                        hintText: "From",
                        isShowSuffixIcon: false,
                        isPassword: false,
                        prefixicon: Icons.flight_takeoff_rounded,
                        textInputType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        circularCorner: 20,
                        fillColor: Colors.grey.shade50,
                        verticalPadding: 15,
                        fontSize: 16,
                        prefixIconcolor: Colors.black45,
                        hintTextcolor: Colors.black45,
                      ),
                      SizedBox(height: 10,),
                      CustomeTextWOBorder(
                        fontColor: Colors.black,
                        cursorColor: Colors.black,
                        onChanged: (value) {},
                        controller: agentDLocationController,
                        hintText: "To",
                        isShowSuffixIcon: false,
                        isPassword: false,
                        prefixicon: Icons.flight_land_rounded,
                        textInputType: TextInputType.text,
                        inputAction: TextInputAction.next,
                        circularCorner: 20,
                        fillColor: Colors.grey.shade50,
                        verticalPadding: 15,
                        fontSize: 16,
                        prefixIconcolor: Colors.black45,
                        hintTextcolor: Colors.black45,
                      )
                    ],
                  ),
                )
              ],
            ),


           /* Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("load location",
                      style: GoogleFonts.poppins(
                        textStyle: boldDefault.copyWith(
                            color: Colors.white, fontSize: 16),
                      )),
                  SizedBox(
                    height: Dimensions.space10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomeTextWOBorder(
                          controller: agentFLocationController,
                          onChanged: (value) {},
                          hintText: "From",
                          isShowSuffixIcon: false,
                          isPassword: false,
                          prefixicon: Icons.flight_takeoff_rounded,
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          circularCorner: 20,
                          fillColor: Colors.white12,
                          verticalPadding: 15,
                          fontSize: 16,
                          prefixIconcolor: Colors.white60,
                          hintTextcolor: Colors.white60,
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.space10,
                      ),
                      Icon(
                        Icons.directions_bike_rounded,
                        color: Colors.white70,
                      ),
                      SizedBox(
                        width: Dimensions.space10,
                      ),
                      Expanded(
                        child: CustomeTextWOBorder(
                          onChanged: (value) {},
                          controller: agentDLocationController,
                          hintText: "To",
                          isShowSuffixIcon: false,
                          isPassword: false,
                          prefixicon: Icons.flight_land_rounded,
                          textInputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          circularCorner: 20,
                          fillColor: Colors.white12,
                          verticalPadding: 15,
                          fontSize: 16,
                          prefixIconcolor: Colors.white60,
                          hintTextcolor: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),*/
            SizedBox(
              height: Dimensions.space20,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.2),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Material Quantity",
                      style: GoogleFonts.poppins(
                        textStyle: boldDefault.copyWith(
                            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                      )),
                  SizedBox(
                    height: Dimensions.space10,
                  ),
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
                            value: 'KG',
                            toggleable: true,
                            groupValue: unitResult,
                            onChanged: (value) {
                              setState(() {
                                unitResult = value!;
                              });
                            },
                          ),
                          Text(
                            'KG',
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
                            value: '(LBS) Ton',
                            toggleable: true,
                            groupValue: unitResult,
                            onChanged: (value) {
                              setState(() {
                                unitResult = value!;
                              });
                            },
                          ),
                          Text(
                            '(LBS) Ton',
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
                    height: Dimensions.space5,
                  ),
                  CustomeTextWOBorder(
                    cursorColor: Colors.black,
                    fontColor: Colors.black,
                    onChanged: (value) {},
                    controller: loadCapacityController,
                    hintText: "Eg : 12",
                    isShowSuffixIcon: false,
                    isPassword: false,
                    prefixicon: Icons.cloud_download_sharp,
                    hasIcon: false,
                    textInputType: TextInputType.phone,
                    inputAction: TextInputAction.next,
                    circularCorner: 20,
                    fillColor: Colors.grey.shade50,
                    verticalPadding: 15,
                    fontSize: 16,
                    prefixIconcolor: Colors.black45,
                    hintTextcolor: Colors.black45,
                  ),


                ],
              ),
            ),
            SizedBox(
              height: Dimensions.space20,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.2),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date selection",
                    style: GoogleFonts.poppins(
                      textStyle: boldDefault.copyWith(
                          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.space10,
                  ),
                  CustomeTextWOBorder(
                    fontColor: Colors.black,
                    cursorColor: Colors.black,
                    onPress: () => _selectFromDate(context),
                    onChanged: (value) {},
                    controller: fromDateController,
                    hintText: _fromDate == null
                        ? 'Select From Date'
                        : DateFormat('dd-MM-yyyy').format(_fromDate!),
                    isShowSuffixIcon: false,
                    isPassword: false,
                    prefixicon: Icons.date_range_rounded,
                    textInputType: TextInputType.phone,
                    inputAction: TextInputAction.next,
                    circularCorner: 20,
                    fillColor: Colors.grey.shade50,
                    verticalPadding: 15,
                    fontSize: 16,
                    hasIcon: true,
                    prefixIconcolor: Colors.black45,
                    hintTextcolor: Colors.black45,
                    readOnly: true,
                  ),


                ],
              ),
            ),


            SizedBox(
              height: Dimensions.space25,
            ),
            RoundedButton(
              color: Colors.blue,
              cornerRadius: 20,
              verticalPadding: 15,
              textSize: 18,
              text: "Create Load",
              press: () {
                Navigator.push(context, CupertinoPageRoute(builder: (context) => AirlineSearchWithLoad(agentName: agentNameController.text.toString(), airline_f_location: agentFLocationController.text, airline_d_location: agentDLocationController.text,airline_kg_ton: unitResult, airline_capacity: double.parse(loadCapacityController.text.toString()),airline_from_date: fromDateController.text.toString())));
              },
            ),
          ],
        ),
      ),
    );
  }
}
