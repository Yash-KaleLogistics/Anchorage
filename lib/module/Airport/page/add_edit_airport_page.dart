

import 'package:anchorage/module/Airport/services/logic/airport_cubit.dart';
import 'package:anchorage/module/Airport/services/logic/airport_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/dimensions.dart';
import '../../../core/style.dart';
import '../../../widget/custome_text_wo_border.dart';
import '../../../widget/rounded_button.dart';
import '../../City/model/city_model.dart';
import '../../Country/model/country_model.dart';
import '../../State/model/state_model.dart';
import '../model/airport_model.dart';

class AddEditAirportPage extends StatefulWidget {
  final AirportModel? airportModel;
  CityModel? cityModel;

  AddEditAirportPage({Key? key, this.airportModel, this.cityModel}) : super(key: key);

  @override
  _AddEditAirportPageState createState() => _AddEditAirportPageState();
}

class _AddEditAirportPageState extends State<AddEditAirportPage> {
  TextEditingController airportNameController = TextEditingController();
  TextEditingController airportCodeController = TextEditingController();
  int? selectedCountryId;
  int? selectedStateId;
  int? selectedCityId;
  List<StateModel> states = [];
  List<CountryModel> countries = [];
  List<CityModel> cities = [];

  @override
  void initState() {
    super.initState();
    if (widget.airportModel != null) {
      airportNameController.text = widget.airportModel!.airportName ?? '';
      airportCodeController.text = widget.airportModel!.airportCode ?? '';
      selectedCountryId = widget.airportModel!.countryId;
      selectedStateId = widget.airportModel!.stateId;
      selectedCityId = widget.airportModel!.cityId;
    }else if(widget.cityModel != null){
      selectedCountryId = widget.cityModel!.countryId;
      selectedStateId = widget.cityModel!.stateId;
      selectedCityId = widget.cityModel!.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AirportCubit()..fetchAllCountries(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            widget.airportModel == null ? "Add Airport" : "Update Airport",
            style: GoogleFonts.poppins(
              textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        body: BlocConsumer<AirportCubit, AirportState>(
          listener: (context, state) {
            if (state is AirportStateSuccess) {
              airportNameController.clear();
              airportCodeController.clear();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("${state.airportModel.airportName} added successfully"),
              ));
              Navigator.pop(context, true);
            } else if (state is AirportStateFetchSuccess) {
              airportNameController.clear();
              airportCodeController.clear();
              Navigator.pop(context, true);
            } else if (state is AirportStateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
              ));
            }else if(state is CountryStateFetchSuccess){
              countries = state.countries;
              if (widget.airportModel != null) {
                context.read<AirportCubit>().fetchAllStatesByCountryId(selectedCountryId!);
              }else if(widget.cityModel != null){
                context.read<AirportCubit>().fetchAllStatesByCountryId(selectedCountryId!);
              }
            } else if (state is StateStateFetchSuccess) {
              states = state.states;
              if (widget.airportModel != null) {
                context.read<AirportCubit>().fetchAllCitiesByStateId(selectedStateId!);
              }else if(widget.cityModel != null){
                context.read<AirportCubit>().fetchAllCitiesByStateId(selectedStateId!);
              }
            }else if (state is CityStateFetchSuccess) {
              cities = state.cities;
            }
          },
          builder: (context, state) {

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (state is AirportStateLoading || state is CountryStateFetchSuccess || state is StateStateFetchSuccess || state is CityStateFetchSuccess ||state is AirportStateFailure || state is CityStateFailure)
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
                          context.read<AirportCubit>().fetchAllStatesByCountryId(value!);
                        },
                      ),
                    SizedBox(height: Dimensions.space20),
                    if (state is AirportStateLoading || state is StateStateFetchSuccess || state is CityStateFetchSuccess || state is CityStateFailure)
                      _buildDropdown<StateModel>(
                        context: context,
                        items: states,
                        value: selectedStateId,
                        hint: "Select State",
                        onChanged: (int? value) {
                          setState(() {
                            selectedStateId = value;
                            selectedCityId = null;
                            cities = [];
                          });
                          context.read<AirportCubit>().fetchAllCitiesByStateId(value!);
                        },
                      ),
                    if(state is AirportStateFailure)
                      Text("${state.error}"),

                    SizedBox(height: Dimensions.space20),
                    if (state is CityStateFetchSuccess)
                      _buildDropdown<CityModel>(
                        context: context,
                        items: cities,
                        value: selectedCityId,
                        hint: "Select City",
                        onChanged: (int? value) {
                          setState(() {
                            selectedCityId = value;
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
                        controller: airportNameController,
                        onChanged: (value) {},
                        hintText: "Airport Name",
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
                        controller: airportCodeController,
                        onChanged: (value) {},
                        hintText: "Airport Code",
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
                      text: state is AirportStateLoading ? "Loading" : (widget.airportModel == null ? "Add Airport" : "Update Airport"),
                      press: () {
                        String airportName = airportNameController.text.trim();
                        String airportCode = airportCodeController.text.trim();
                        if (widget.airportModel == null) {
                          context.read<AirportCubit>().airportCreate(selectedCountryId!, selectedStateId!, selectedCityId!, airportName, airportCode);
                        } else {
                          // Update city logic here
                          context.read<AirportCubit>().updateAirport(
                            widget.airportModel!.id!,
                            selectedCountryId!,
                            selectedStateId!,
                            selectedCityId!,
                            airportName,
                            airportCode,
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
          } else if (item is CityModel) {
            return DropdownMenuItem<int>(
              value: item.id,
              child: Text(item.cityName ?? ''),
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
