import 'package:anchorage/module/Airport/page/airport_list_page.dart';
import 'package:anchorage/module/City/model/city_model.dart';
import 'package:anchorage/module/City/page/add_edit_city_page.dart';
import 'package:anchorage/module/City/services/logic/city_state.dart';
import 'package:anchorage/module/State/model/state_model.dart';
import 'package:anchorage/module/State/page/add_edit_state_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/style.dart';
import '../services/logic/city_cubit.dart';


class CityListPage extends StatefulWidget {

  StateModel? stateModel;

  CityListPage({super.key, this.stateModel});

  @override
  State<CityListPage> createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  late CityCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<CityCubit>();
    if(widget.stateModel != null){
      cubit.fetchAllCitiesByStateId(widget.stateModel!.id!);
    }else{
      cubit.fetchAllCities();
    }

  }

  void _deleteCountry(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete City'),
          content: Text('Are you sure you want to delete this city?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.deleteCities(id);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('${widget.stateModel!.stateName} Cities', style: GoogleFonts.poppins(
            textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
          )),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: IconButton(onPressed: () async {
                final result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AddEditCityPage(stateModel: widget.stateModel,),
                    fullscreenDialog: true,
                  ),
                );
                if (result == true) {
                  // If the result is true, it means a country was added successfully
                  if(widget.stateModel != null){
                    cubit.fetchAllCitiesByStateId(widget.stateModel!.id!);
                  }else{
                    cubit.fetchAllCities();
                  }
                }
              }, icon: Icon(Icons.add, color: Colors.black,)),
            )
          ],
        ),
        body: BlocBuilder<CityCubit, CityState>(
          builder: (context, state) {
            if (state is CityStateLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CityStateFetchSuccess) {
              return ListView.builder(
                itemCount: state.cities.length,
                itemBuilder: (context, index) {
                  CityModel cityModel = state.cities[index];
                  return Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => AirportListPage(cityModel: cityModel,),));
                      },
                      trailing: Container(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => AddEditCityPage(cityModel: cityModel,),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                  if (result == true) {
                                    // If the result is true, it means a country was added successfully
                                    if(widget.stateModel != null){
                                      cubit.fetchAllCitiesByStateId(widget.stateModel!.id!);
                                    }else{
                                      cubit.fetchAllCities();
                                    }
                                  }
                                },
                                child: Icon(Icons.edit)),
                            InkWell(
                                onTap: () => _deleteCountry(cityModel.id!),
                                child: Icon(Icons.delete))
                          ],
                        ),
                      ),
                      title: Text(cityModel.cityName ?? '', style: GoogleFonts.poppins(
                        textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                      )),
                      subtitle: Text(cityModel.cityCode ?? '', style: GoogleFonts.poppins(
                        textStyle: boldExtraLarge.copyWith(color: Colors.black54, fontWeight: FontWeight.w400),
                      )),
                    ),
                  );
                },
              );
            } else if (state is CityStateFailure) {
              return Center(child: Text(state.error));
            } else {
              return Center(child: Text('No states available.'));
            }
          },
        )
    );
  }
}
