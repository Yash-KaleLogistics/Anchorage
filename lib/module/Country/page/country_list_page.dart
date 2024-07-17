import 'package:anchorage/module/Country/page/add_edit_country_page.dart';
import 'package:anchorage/module/State/page/state_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/style.dart';
import '../model/country_model.dart';
import '../services/logic/country_cubit.dart';
import '../services/logic/country_state.dart';

class CountryListPage extends StatefulWidget {
  const CountryListPage({super.key});

  @override
  State<CountryListPage> createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  late CountryCubit cubit;

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _limit = 10;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    cubit = context.read<CountryCubit>();
    cubit.fetchAllCountries(limit: _limit, offset: _currentPage * _limit);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      cubit.fetchAllCountries(limit: _limit, offset: _currentPage * _limit).then((_) {
        setState(() {
          _isLoadingMore = false;
        });
      });
    }
  }

  void _deleteCountry(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Country'),
          content: Text('Are you sure you want to delete this country?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                cubit.deleteCountry(id);
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('All Countries', style: GoogleFonts.poppins(
         textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
      )),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: IconButton(onPressed: () async {
            final result = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => AddEditCountryPage(countryModel : null,),
                fullscreenDialog: true,
              ),
            );
            if (result == true) {
              // If the result is true, it means a country was added successfully
              cubit.fetchAllCountries(limit: _limit, offset: 0);
            }
          }, icon: Icon(Icons.add, color: Colors.black,)),
        )
      ],
      ),
      body: BlocBuilder<CountryCubit, CountryState>(
        builder: (context, state) {
          if (state is CountryStateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CountryStateFetchSuccess) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.countries.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                CountryModel country = state.countries[index];
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => StateListPage(countryModel: country,),));
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
                                    builder: (context) => AddEditCountryPage(countryModel: country,),
                                    fullscreenDialog: true,
                                  ),
                                );
                                if (result == true) {
                                  // If the result is true, it means a country was added successfully
                                  cubit.fetchAllCountries(limit: _limit, offset: 0);
                                }
                              },
                              child: Icon(Icons.edit)),
                          InkWell(
                              onTap: () => _deleteCountry(country.id!),
                              child: Icon(Icons.delete))
                        ],
                      ),
                    ),
                    title: Text(country.name ?? '', style: GoogleFonts.poppins(
                      textStyle: boldExtraLarge.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                    )),
                    subtitle: Text(country.code ?? '', style: GoogleFonts.poppins(
                      textStyle: boldExtraLarge.copyWith(color: Colors.black54, fontWeight: FontWeight.w400),
                    )),
                  ),
                );
              },
            );
          } else if (state is CountryStateFailure) {
            return Center(child: Text(state.error));
          } else {
            return Center(child: Text('No countries available.'));
          }
        },
      )
    );
  }
}
