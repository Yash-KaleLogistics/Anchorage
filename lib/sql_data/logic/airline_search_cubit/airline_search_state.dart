
import '../../model/airline/airline_list_model.dart';

class AirlineSearchState {}

class AirlineSearchInitial extends AirlineSearchState {}

class AirlineSearchLoading extends AirlineSearchState {}

class AirlineSearchSuccess extends AirlineSearchState {
  final AirLineListModel airLineListModel;
  AirlineSearchSuccess(this.airLineListModel);
}

class AirlineSearchFailure extends AirlineSearchState {
  final String error;
  AirlineSearchFailure(this.error);
}