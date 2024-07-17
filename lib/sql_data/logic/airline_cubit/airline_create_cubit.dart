import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/airline_repository.dart';
import 'airline_create_state.dart';

class AirlineAddCubit extends Cubit<AirlineAddState>{
  AirlineAddCubit() : super( AirlineAddInitial() );

  AirlineRepository airlineRepository = AirlineRepository();

  Future<void> airlineCreate(
  String airline_image,
  String airline_id,
  String airline_name,
  String airline_f_location,
  String airline_d_location,
  String airline_kg_ton,
  double airline_capacity,
  String airline_capacity_price,
  String airline_from_date,
  String airline_to_date,
  double airline_rating,
  List<String> airline_daySelection,
  bool airline_recommended,) async {
    emit(AirlineAddLoading());
    try {
      final successFailModel = await airlineRepository.airlineCreate(
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
        airline_recommended,);

      print("Airlinie_MESSAGE====== ${successFailModel.message}");

      emit(AirlineAddSuccess(successFailModel));
    } catch (e) {
      emit(AirlineAddFailure('Fail'));
    }
  }
}