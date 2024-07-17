import 'package:anchorage/sql_data/model/airline/airline_list_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/airline_repository.dart';
import 'airline_search_state.dart';

class AirlineSearchCubit extends Cubit<AirlineSearchState>{
  AirlineSearchCubit() : super( AirlineSearchInitial() );

  AirlineRepository airlineRepository = AirlineRepository();

  Future<void> airlineSearch(
  String airline_f_location,
  String airline_d_location,
  String airline_kg_ton,
  double airline_capacity,
  String airline_from_date,
  ) async {
    emit(AirlineSearchLoading());
    try {
      /*AirLineListModel airlineListModel = await airlineRepository.searchAirline(
        airline_f_location,
        airline_d_location,
        airline_kg_ton,
        airline_capacity,
        airline_from_date);*/

      //print("Airlinie_MESSAGE====== ${airlineListModel}");

     // emit(AirlineSearchSuccess(airlineListModel));
    } catch (e) {
      emit(AirlineSearchFailure('Fail'));
    }
  }
}