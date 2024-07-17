import 'package:anchorage/module/Country/model/country_model.dart';
import 'package:anchorage/module/State/model/state_model.dart';
import 'package:anchorage/module/State/services/logic/State_state.dart';
import 'package:anchorage/module/State/services/logic/state_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/dimensions.dart';
import '../../../core/style.dart';
import '../../../widget/custome_text_wo_border.dart';
import '../../../widget/rounded_button.dart';


class AddEditStatePage extends StatefulWidget {

  CountryModel? countryModel;
  StateModel? stateModel;

  AddEditStatePage({super.key, this.stateModel, this.countryModel});

  @override
  State<AddEditStatePage> createState() => _AddEditStatePageState();
}

class _AddEditStatePageState extends State<AddEditStatePage> {
  TextEditingController stateNameController = TextEditingController();
  TextEditingController stateCodeController = TextEditingController();
  int? selectedCountryId;

  @override
  void initState() {
    super.initState();
    if (widget.stateModel != null) {
      stateNameController.text = widget.stateModel!.stateName!;
      stateCodeController.text = widget.stateModel!.stateCode!;
      selectedCountryId = widget.stateModel!.countryId; // Assume StateModel has a countryId field
    }else if(widget.countryModel != null){
      selectedCountryId = widget.countryModel!.id;
    }
  //  context.read<StateCubit>().fetchAllCountries();
  }


  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) =>  StateCubit()..fetchAllCountries(),
      child:  Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text((widget.stateModel == null) ? "Add State" : "Update State",
              style: GoogleFonts.poppins(
                textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
              )),
        ),
        body: BlocConsumer<StateCubit, StateState>(
            listener: (BuildContext context, StateState state) {
              if (state is StateStateSuccess) {
                stateNameController.clear();
                stateCodeController.clear();

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${state.stateModel.stateName} Add Successfully"),
                ));

                Navigator.pop(context, true);
              }else if(state is StateStateFetchSuccess){
                stateNameController.clear();
                stateCodeController.clear();
                Navigator.pop(context, true);
              } else if (state is StateStateFailure) {
                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                ));
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    if (state is CountryStateFetchSuccess)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: DropdownButton<int>(
                          value: selectedCountryId,
                          hint: Text("Select Country"),
                          items: state.countries.map((CountryModel country) {
                            return DropdownMenuItem<int>(
                              value: country.id,
                              child: Text(country.name ?? ''),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            setState(() {
                              selectedCountryId = value;
                            });
                          },
                          underline: SizedBox(), // Removes the default underline
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
                        ),
                      ),

                    SizedBox(height: 10,),

                    CustomeTextWOBorder(
                      hasIcon: true,
                      cursorColor: Colors.black,
                      fontColor: Colors.black,
                      controller: stateNameController,
                      onChanged: (value) {},
                      hintText: "State Name",
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
                    CustomeTextWOBorder(
                      hasIcon: true,
                      cursorColor: Colors.black,
                      fontColor: Colors.black,
                      controller: stateCodeController,
                      onChanged: (value) {},
                      hintText: "State Code",
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
                      height: Dimensions.space25,
                    ),
                    RoundedButton(
                      color: Colors.blue,
                      cornerRadius: 20,
                      verticalPadding: 15,
                      textSize: 18,
                      text: state is StateStateLoading ? "Loading": (widget.stateModel == null) ? "Add State" : "Update State",
                      press: () {

                        String stateName = stateNameController.text.toString();
                        String stateCode = stateCodeController.text.toString();

                        if(widget.stateModel == null){
                          context.read<StateCubit>().stateCreate(
                              selectedCountryId!,
                              stateName,
                              stateCode);
                        }else{
                          context.read<StateCubit>().updateStates(
                              widget.stateModel!.id!,
                              selectedCountryId!,
                              stateName,
                              stateCode,
                            );
                        }
                      },
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
