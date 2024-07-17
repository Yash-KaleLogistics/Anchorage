import 'package:anchorage/module/Country/services/logic/country_cubit.dart';
import 'package:anchorage/module/Country/services/logic/country_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/dimensions.dart';
import '../../../core/style.dart';
import '../../../widget/custome_text_wo_border.dart';
import '../../../widget/rounded_button.dart';
import '../model/country_model.dart';

class AddEditCountryPage extends StatefulWidget {

  CountryModel? countryModel;

  AddEditCountryPage({super.key, this.countryModel});

  @override
  State<AddEditCountryPage> createState() => _AddEditCountryPageState();
}

class _AddEditCountryPageState extends State<AddEditCountryPage> {
  TextEditingController countryNameController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    if(widget.countryModel != null){
      countryNameController.text = widget.countryModel!.name!;
      countryCodeController.text = widget.countryModel!.code!;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text((widget.countryModel == null) ? "Add Country" : "Update Country",
            style: GoogleFonts.poppins(
            textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
      )),
      ),
      body: BlocConsumer<CountryCubit, CountryState>(
        listener: (BuildContext context, CountryState state) {
          if (state is CountryStateSuccess) {
            countryNameController.clear();
            countryCodeController.clear();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${state.countryModel.name} Add Successfully"),
            ));

            Navigator.pop(context);
          }else if(state is CountryStateFetchSuccess){
            countryNameController.clear();
            countryCodeController.clear();
            Navigator.pop(context);
          } else if (state is CountryStateFailure) {
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
                CustomeTextWOBorder(
                  hasIcon: true,
                  cursorColor: Colors.black,
                  fontColor: Colors.black,
                  controller: countryNameController,
                  onChanged: (value) {},
                  hintText: "Country Name",
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
                  controller: countryCodeController,
                  onChanged: (value) {},
                  hintText: "Country Code",
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
                  text: state is CountryStateLoading ? "Loading": (widget.countryModel == null) ? "Add Country" : "Update Country",
                  press: () {

                    String countryName = countryNameController.text.toString();
                    String countryCode = countryCodeController.text.toString();

                    if(widget.countryModel == null){
                      context.read<CountryCubit>().CountryCreate(
                          countryName,
                          countryCode);
                    }else{
                      context.read<CountryCubit>().updateCountry(
                        widget.countryModel!.id!,
                        countryName,
                        countryCode,
                      );
                    }
                  },
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
