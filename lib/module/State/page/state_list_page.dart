import 'package:anchorage/module/City/page/city_list_page.dart';
import 'package:anchorage/module/Country/model/country_model.dart';
import 'package:anchorage/module/State/model/state_model.dart';
import 'package:anchorage/module/State/page/add_edit_state_page.dart';
import 'package:anchorage/module/State/services/logic/State_state.dart';
import 'package:anchorage/module/State/services/logic/state_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/style.dart';


class StateListPage extends StatefulWidget {
  CountryModel? countryModel;
  StateListPage({super.key, this.countryModel});

  @override
  State<StateListPage> createState() => _StateListPageState();
}

class _StateListPageState extends State<StateListPage> {
  late StateCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<StateCubit>();
    if(widget.countryModel == null) {
      cubit.fetchAllStates();
    }else{
      cubit.fetchAllStatesByCountryId(widget.countryModel!.id!);
    }

  }

  void _deleteCountry(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete State'),
          content: Text('Are you sure you want to delete this state?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.deleteStates(id);
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
          title: Text('${widget.countryModel!.name} States', style: GoogleFonts.poppins(
            textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
          )),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: IconButton(onPressed: () async {
                final result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => AddEditStatePage(countryModel: widget.countryModel,),
                    fullscreenDialog: true,
                  ),
                );
                if (result == true) {
                  // If the result is true, it means a country was added successfully
                  if(widget.countryModel == null) {
                    cubit.fetchAllStates();
                  }else{
                    cubit.fetchAllStatesByCountryId(widget.countryModel!.id!);
                  }
                }
              }, icon: Icon(Icons.add, color: Colors.black,)),
            )
          ],
        ),
        body: BlocBuilder<StateCubit, StateState>(
          builder: (context, state) {
            if (state is StateStateLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is StateStateFetchSuccess) {
              return ListView.builder(
                itemCount: state.states.length,
                itemBuilder: (context, index) {
                  StateModel statesModel = state.states[index];
                  return Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.all(8),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (context) => CityListPage(stateModel: statesModel,),));
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
                                      builder: (context) => AddEditStatePage(stateModel: statesModel,),
                                      fullscreenDialog: true,
                                    ),
                                  );
                                  if (result == true) {
                                    // If the result is true, it means a country was added successfully
                                    if(widget.countryModel == null) {
                                      cubit.fetchAllStates();
                                    }else{
                                      cubit.fetchAllStatesByCountryId(widget.countryModel!.id!);
                                    }
                                  }
                                },
                                child: Icon(Icons.edit)),
                            InkWell(
                                onTap: () => _deleteCountry(statesModel.id!),
                                child: Icon(Icons.delete))
                          ],
                        ),
                      ),
                      title: Text(statesModel.stateName ?? '', style: GoogleFonts.poppins(
                        textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                      )),
                      subtitle: Text(statesModel.stateCode ?? '', style: GoogleFonts.poppins(
                        textStyle: boldExtraLarge.copyWith(color: Colors.black54, fontWeight: FontWeight.w400),
                      )),
                    ),
                  );
                },
              );
            } else if (state is StateStateFailure) {
              return Center(child: Text(state.error));
            } else {
              return Center(child: Text('No states available.'));
            }
          },
        )
    );
  }
}
