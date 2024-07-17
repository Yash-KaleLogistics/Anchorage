


import 'package:anchorage/module/Airport/model/airport_model.dart';
import 'package:anchorage/module/Airport/page/add_edit_airport_page.dart';
import 'package:anchorage/module/City/model/city_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/style.dart';
import '../services/logic/airport_cubit.dart';
import '../services/logic/airport_state.dart';

class AirportListPage extends StatefulWidget {

  CityModel? cityModel;

  AirportListPage({super.key, this.cityModel});

  @override
  State<AirportListPage> createState() => _AirportListPageState();
}

class _AirportListPageState extends State<AirportListPage> {
  late AirportCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<AirportCubit>();
    if(widget.cityModel != null){
      cubit.fetchAirportsByCityId(widget.cityModel!.id!);
    }else{
      cubit.fetchAllAirports();
    }

  }

  void _deleteCountry(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Airport'),
          content: Text('Are you sure you want to delete this airport?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.deleteAirports(id);
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
          title: Text('${widget.cityModel!.cityName} Airport', style: GoogleFonts.poppins(
            textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
          )),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: IconButton(onPressed: () async {
                final result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AddEditAirportPage(cityModel: widget.cityModel,),
                    fullscreenDialog: true,
                  ),
                );
                if (result == true) {
                  // If the result is true, it means a country was added successfully
                  if(widget.cityModel != null){
                    cubit.fetchAirportsByCityId(widget.cityModel!.id!);
                  }else{
                    cubit.fetchAllAirports();
                  }
                }
              }, icon: Icon(Icons.add, color: Colors.black,)),
            )
          ],
        ),
        body: BlocBuilder<AirportCubit, AirportState>(
          builder: (context, state) {
            if (state is AirportStateLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AirportStateFetchSuccess) {
              return ListView.builder(
                itemCount: state.airportList.length,
                itemBuilder: (context, index) {
                  AirportModel airportModel = state.airportList[index];
                  return Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.all(8),
                    child: ListTile(
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
                                      builder: (context) => AddEditAirportPage(airportModel: airportModel,),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                  if (result == true) {
                                    // If the result is true, it means a country was added successfully
                                    if(widget.cityModel != null){
                                      cubit.fetchAirportsByCityId(widget.cityModel!.id!);
                                    }else{
                                      cubit.fetchAllAirports();
                                    }
                                  }
                                },
                                child: Icon(Icons.edit)),
                            InkWell(
                                onTap: () => _deleteCountry(airportModel.id!),
                                child: Icon(Icons.delete))
                          ],
                        ),
                      ),
                      title: Text(airportModel.airportName ?? '', style: GoogleFonts.poppins(
                        textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                      )),
                      subtitle: Text(airportModel.airportCode ?? '', style: GoogleFonts.poppins(
                        textStyle: boldExtraLarge.copyWith(color: Colors.black54, fontWeight: FontWeight.w400),
                      )),
                    ),
                  );
                },
              );
            } else if (state is CityStateFailure) {
              return Center(child: Text(state.error));
            } else {
              return Center(child: Text('No airport available.'));
            }
          },
        )
    );
  }
}
