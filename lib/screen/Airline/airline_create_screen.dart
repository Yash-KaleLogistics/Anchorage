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

class AirlineCreateScreen extends StatefulWidget {
  const AirlineCreateScreen({super.key});

  @override
  State<AirlineCreateScreen> createState() => _AirlineCreateScreenState();
}

class _AirlineCreateScreenState extends State<AirlineCreateScreen> {
  TextEditingController airlineNameController = TextEditingController();
  TextEditingController airlineFLocationController = TextEditingController();
  TextEditingController airlineDLocationController = TextEditingController();
  TextEditingController loadCapacityController = TextEditingController();
  TextEditingController pricePerUnitController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController ratingController = TextEditingController();
  bool _isChecked = false;
  var unitResult = "KG";
  DateTime? _fromDate;
  DateTime? _toDate;

  static List<String> dayList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<String> selectedDays = [];

  @override
  void dispose() {
    super.dispose();
    airlineNameController.dispose();
    airlineFLocationController.dispose();
    airlineDLocationController.dispose();
    loadCapacityController.dispose();
    pricePerUnitController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    ratingController.dispose();
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
        _toDate = null; // Reset To Date when From Date changes
        fromDateController.text = DateFormat('dd-MM-yyyy').format(_fromDate!);
        toDateController.clear();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    if (_fromDate == null) {
      // Ensure the user selects the From Date first
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? _fromDate!.add(Duration(days: 1)),
      firstDate: _fromDate!.add(Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
        toDateController.text = DateFormat('dd-MM-yyyy').format(_toDate!);
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
        title: Text("Add new airline",
            style: GoogleFonts.poppins(
              textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
            )),
      ),
      body: BlocConsumer<AirlineAddCubit, AirlineAddState>(
        listener: (BuildContext context, AirlineAddState state) {
          if (state is AirlineAddSuccess) {
            airlineNameController.clear();
            airlineFLocationController.clear();
            airlineDLocationController.clear();
            loadCapacityController.clear();
            pricePerUnitController.clear();
            fromDateController.clear();
            toDateController.clear();
            ratingController.clear();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.successFailModel.message),
            ));
          } else if (state is AirlineAddFailure) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
            ));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                SizedBox(
                  height: Dimensions.space10,
                ),
                CustomeTextWOBorder(
                  hasIcon: true,
                  cursorColor: Colors.black,
                  fontColor: Colors.black,
                  controller: airlineNameController,
                  onChanged: (value) {},
                  hintText: "Airline Name",
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
                            controller: airlineFLocationController,
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
                            hasIcon: true,
                            prefixIconcolor: Colors.black45,
                            hintTextcolor: Colors.black45,
                          ),
                          SizedBox(height: 10,),
                          CustomeTextWOBorder(
                            fontColor: Colors.black,
                            cursorColor: Colors.black,
                            onChanged: (value) {},
                            controller: airlineDLocationController,
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
                            hasIcon: true,
                            prefixIconcolor: Colors.black45,
                            hintTextcolor: Colors.black45,
                          )
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(
                  height: Dimensions.space20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select Unit",
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
                          SizedBox(width: 10,),
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
                        fontColor: Colors.black,
                        cursorColor: Colors.black,
                        onChanged: (value) {},
                        controller: loadCapacityController,
                        hintText: "Enter load capacity",
                        isShowSuffixIcon: false,
                        isPassword: false,
                        prefixicon: Icons.cloud_download_sharp,
                        textInputType: TextInputType.phone,
                        inputAction: TextInputAction.next,
                        circularCorner: 20,
                        fillColor: Colors.grey.shade50,
                        verticalPadding: 15,
                        fontSize: 16,
                        prefixIconcolor: Colors.black45,
                        hintTextcolor: Colors.black45,
                      ),
                      SizedBox(
                        height: Dimensions.space10,
                      ),
                      CustomeTextWOBorder(
                        fontColor: Colors.black,
                        cursorColor: Colors.black,
                        onChanged: (value) {},
                        controller: pricePerUnitController,
                        hintText: "Price per 1 ${unitResult} :- (100)",
                        isShowSuffixIcon: false,
                        isPassword: false,
                        prefixicon: Icons.upload_rounded,
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
                    border: Border.all(color: Colors.black, width: 0.1),
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
                        hasIcon: true,
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
                        verticalPadding: 10,
                        fontSize: 16,
                        prefixIconcolor: Colors.black45,
                        hintTextcolor: Colors.black45,
                        readOnly: true,
                      ),
                      SizedBox(
                        height: Dimensions.space10,
                      ),
                      CustomeTextWOBorder(
                        fontColor: Colors.black,
                        hasIcon: true,
                        onPress: () => _selectToDate(context),
                        onChanged: (value) {},
                        controller: toDateController,
                        hintText: _toDate == null
                            ? 'Select To Date'
                            : DateFormat('dd-MM-yyyy').format(_toDate!),
                        isShowSuffixIcon: false,
                        isPassword: false,
                        prefixicon: Icons.date_range_rounded,
                        textInputType: TextInputType.phone,
                        inputAction: TextInputAction.next,
                        circularCorner: 20,
                        fillColor: Colors.grey.shade50,
                        verticalPadding: 10,
                        fontSize: 16,
                        prefixIconcolor: Colors.black45,
                        hintTextcolor: Colors.black45,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimensions.space20,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Day selection",
                        style: GoogleFonts.poppins(
                          textStyle: boldDefault.copyWith(
                              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: Dimensions.space10,
                      ),
                      Wrap(
                        spacing: 10.0,
                        children: dayList.map((day) {
                          return ChoiceChip(
                            label: Text(day),
                            backgroundColor: Colors.grey.shade50,
                            // Unselected background color
                            selectedColor: Colors.grey.shade300,
                            // Selected background color
                            /* labelStyle: TextStyle(
                              fontWeight: selectedDays.contains(day)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selectedDays.contains(day)
                                  ? Colors.black
                                  : Colors.black45,
                            ),*/

                            labelStyle: GoogleFonts.poppins(
                              textStyle: boldDefault.copyWith(
                                color: selectedDays.contains(day)
                                    ? Colors.black
                                    : Colors.black45,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),

                            selected: selectedDays.contains(day),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              // Corner radius
                              side: BorderSide(
                                color: selectedDays.contains(day)
                                    ? Colors.white
                                    : Colors.white, // Border color
                              ),
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedDays.add(day);
                                } else {
                                  selectedDays.remove(day);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      /* Text(
                        'Selected Days: ${selectedDays.join(', ')}',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),*/
                    ],
                  ),
                ),
                SizedBox(
                  height: Dimensions.space10,
                ),
                CustomeTextWOBorder(
                  hasIcon: true,
                  cursorColor: Colors.black,
                  fontColor: Colors.black,
                  onChanged: (value) {},
                  controller: ratingController,
                  hintText: "Rating",
                  isShowSuffixIcon: false,
                  isPassword: false,
                  prefixicon: Icons.star,
                  textInputType: TextInputType.phone,
                  inputAction: TextInputAction.next,
                  circularCorner: 10,
                  fillColor: Colors.grey.shade50,
                  verticalPadding: 20,
                  fontSize: 16,
                  prefixIconcolor: Colors.black45,
                  hintTextcolor: Colors.black45,
                ),
                SizedBox(
                  height: Dimensions.space10,
                ),
                Row(
                  children: [
                    Checkbox(
                      side: BorderSide(
                          width: 2, color: Colors.black45),
                      value: _isChecked,
                      onChanged: (value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                      checkColor: Colors.white,
                      activeColor: Colors.black,
                    ),
                    Text("Recommended",
                        style: GoogleFonts.poppins(
                          textStyle: boldExtraLarge.copyWith(
                              color: _isChecked
                                  ? Colors.black
                                  : Colors.black45,
                              fontSize: 16,fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
                SizedBox(
                  height: Dimensions.space25,
                ),
                RoundedButton(
                  color: Colors.blue,
                  cornerRadius: 20,
                  verticalPadding: 15,
                  textSize: 18,
                  text: "Add Booking",
                  press: () {
                    String airline_image =
                        "https://wallpaperaccess.com/full/254381.jpg";
                    String airline_id = Uuid().v4();
                    String airline_name = airlineNameController.text.toString();
                    String airline_f_location =
                        airlineFLocationController.text.toString();
                    String airline_d_location =
                        airlineDLocationController.text.toString();
                    String airline_kg_ton = unitResult;
                    double airline_capacity =
                        double.parse(loadCapacityController.text.toString());
                    String airline_capacity_price =
                        pricePerUnitController.text.toString();
                    String airline_from_date =
                        fromDateController.text.toString();
                    String airline_to_date = toDateController.text.toString();
                    double airline_rating =
                        double.parse(ratingController.text.toString());
                    List<String> airline_daySelection = selectedDays;
                    bool airline_recommended = _isChecked;

                    context.read<AirlineAddCubit>().airlineCreate(
                        airline_image,
                        airline_id,
                        airline_name,
                        airline_f_location,
                        airline_d_location,
                        airline_kg_ton,
                        airline_capacity,
                        airline_capacity_price,
                        airline_from_date,
                        airline_to_date,
                        airline_rating,
                        airline_daySelection,
                        airline_recommended);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
