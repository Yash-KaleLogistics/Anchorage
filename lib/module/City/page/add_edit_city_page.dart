import 'package:anchorage/module/City/model/city_model.dart';
import 'package:anchorage/module/City/services/logic/city_cubit.dart';
import 'package:anchorage/module/City/services/logic/city_state.dart';
import 'package:anchorage/module/Country/model/country_model.dart';
import 'package:anchorage/module/State/model/state_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/dimensions.dart';
import '../../../core/style.dart';
import '../../../widget/custome_text_wo_border.dart';
import '../../../widget/rounded_button.dart';

class AddEditCityPage extends StatefulWidget {
  final CityModel? cityModel;
  final StateModel? stateModel;

  AddEditCityPage({Key? key, this.cityModel, this.stateModel}) : super(key: key);

  @override
  _AddEditCityPageState createState() => _AddEditCityPageState();
}

class _AddEditCityPageState extends State<AddEditCityPage> {
  TextEditingController cityNameController = TextEditingController();
  TextEditingController cityCodeController = TextEditingController();
  int? selectedCountryId;
  int? selectedStateId;
  List<StateModel> states = [];
  List<CountryModel> countries = [];

  @override
  void initState() {
    super.initState();
    if (widget.cityModel != null) {
      cityNameController.text = widget.cityModel!.cityName ?? '';
      cityCodeController.text = widget.cityModel!.cityCode ?? '';
      selectedCountryId = widget.cityModel!.countryId;
      selectedStateId = widget.cityModel!.stateId;
    }else if(widget.stateModel != null){
      selectedCountryId = widget.stateModel!.countryId;
      selectedStateId = widget.stateModel!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CityCubit()..fetchAllCountries(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.cityModel == null ? "Add City" : "Update City",
            style: GoogleFonts.poppins(
              textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        body: BlocConsumer<CityCubit, CityState>(
          listener: (context, state) {
            if (state is CityStateSuccess) {
              cityNameController.clear();
              cityCodeController.clear();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${state.cityModel.cityName} added successfully"),
              ));
              Navigator.pop(context, true);
            } else if (state is CityStateFetchSuccess) {
              cityNameController.clear();
              cityCodeController.clear();
              Navigator.pop(context, true);
            } else if (state is CityStateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
              ));
            }else if(state is CountryStateFetchSuccess){
              countries = state.countries;
              if (widget.cityModel != null) {
                context.read<CityCubit>().fetchAllStatesByCountryId(selectedCountryId!);
              }else if(widget.stateModel != null){
                context.read<CityCubit>().fetchAllStatesByCountryId(selectedCountryId!);
              }

            } else if (state is StateStateFetchSuccess) {
              states = state.states;
            }
          },
          builder: (context, state) {




            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is CityStateLoading || state is CountryStateFetchSuccess || state is StateStateFetchSuccess || state is CityStateFailure)
                      _buildDropdown<CountryModel>(
                        context: context,
                        items: countries,
                        value: selectedCountryId,
                        hint: "Select Country",
                        onChanged: (int? value) {
                          setState(() {
                            selectedCountryId = value;
                            selectedStateId = null;
                            states = [];
                          });
                          context.read<CityCubit>().fetchAllStatesByCountryId(value!);
                        },
                      ),
                    SizedBox(height: Dimensions.space20),
                    if (state is CityStateLoading || state is StateStateFetchSuccess)
                      _buildDropdown<StateModel>(
                        context: context,
                        items: states,
                        value: selectedStateId,
                        hint: "Select State",
                        onChanged: (int? value) {
                          setState(() {
                            selectedStateId = value;
                          });
                        },
                      ),
                    if(state is CityStateFailure)
                      Text("${state.error}"),
                
                
                    SizedBox(height: Dimensions.space20),
                    CustomeTextWOBorder(
                      hasIcon: true,
                      cursorColor: Colors.black,
                      fontColor: Colors.black,
                      controller: cityNameController,
                      onChanged: (value) {},
                      hintText: "City Name",
                      isShowSuffixIcon: false,
                      isPassword: false,
                      prefixicon: Icons.location_city_outlined,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      circularCorner: 20,
                      fillColor: Colors.grey.shade50,
                      verticalPadding: 20,
                      fontSize: 16,
                      prefixIconcolor: Colors.black45,
                      hintTextcolor: Colors.black45
                    ),
                    SizedBox(height: Dimensions.space20),
                    CustomeTextWOBorder(
                      hasIcon: true,
                      cursorColor: Colors.black,
                      fontColor: Colors.black,
                      controller: cityCodeController,
                      onChanged: (value) {},
                      hintText: "City Code",
                      isShowSuffixIcon: false,
                      isPassword: false,
                      prefixicon: Icons.code_outlined,
                      textInputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      circularCorner: 20,
                      fillColor: Colors.grey.shade50,
                      verticalPadding: 20,
                      fontSize: 16,
                      prefixIconcolor: Colors.black45,
                      hintTextcolor: Colors.black45
                    ),
                    SizedBox(height: Dimensions.space25),
                    RoundedButton(
                      color: Colors.blue,
                      cornerRadius: 20,
                      verticalPadding: 15,
                      textSize: 18,
                      text: state is CityStateLoading ? "Loading" : (widget.cityModel == null ? "Add City" : "Update City"),
                      press: () {
                        String cityName = cityNameController.text.trim();
                        String cityCode = cityCodeController.text.trim();
                        if (widget.cityModel == null) {
                          context.read<CityCubit>().cityCreate(selectedCountryId!, selectedStateId!, cityName, cityCode);
                        } else {
                          // Update city logic here
                          context.read<CityCubit>().updateCities(
                            widget.cityModel!.id!,
                            selectedCountryId!,
                            selectedStateId!,
                            cityName,
                            cityCode,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required BuildContext context,
    required List<T> items,
    required int? value,
    required String hint,
    required void Function(int?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: DropdownButton<int>(
        value: value,
        hint: Text(hint),
        items: items.map((item) {
          if (item is CountryModel) {
            return DropdownMenuItem<int>(
              value: item.id,
              child: Text(item.name ?? ''),
            );
          } else if (item is StateModel) {
            return DropdownMenuItem<int>(
              value: item.id,
              child: Text(item.stateName ?? ''),
            );
          } else {
            return DropdownMenuItem<int>(value: null, child: Text('Unknown item'));
          }
        }).toList(),
        onChanged: onChanged,
        underline: SizedBox(),
        isExpanded: true,
        dropdownColor: Colors.white,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black45),
      ),
    );
  }
}
