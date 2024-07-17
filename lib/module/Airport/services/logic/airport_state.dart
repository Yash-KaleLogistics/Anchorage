import 'package:anchorage/module/Airport/model/airport_model.dart';
import 'package:anchorage/module/City/model/city_model.dart';
import 'package:anchorage/module/Country/model/country_model.dart';
import 'package:anchorage/module/State/model/state_model.dart';

class AirportState {}

class AirportStateInitial extends AirportState {}

class AirportStateLoading extends AirportState {}

class AirportStateSuccess extends AirportState {
  final AirportModel airportModel;
  AirportStateSuccess(this.airportModel);
}

class AirportStateFetchSuccess extends AirportState {
  final List<AirportModel> airportList;
  AirportStateFetchSuccess(this.airportList);
}
class CountryStateFetchSuccess extends AirportState {
  final List<CountryModel> countries;
  CountryStateFetchSuccess(this.countries);
}

class StateStateFetchSuccess extends AirportState {
  final List<StateModel> states;
  StateStateFetchSuccess(this.states);
}

class CityStateFetchSuccess extends AirportState {
  final List<CityModel> cities;
  CityStateFetchSuccess(this.cities);
}

class CityStateFailure extends AirportState {
  final String error;
  CityStateFailure(this.error);
}


class AirportStateFailure extends AirportState {
  final String error;
  AirportStateFailure(this.error);
}