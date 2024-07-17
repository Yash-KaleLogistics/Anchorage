import 'package:anchorage/module/City/model/city_model.dart';
import 'package:anchorage/module/Country/model/country_model.dart';
import 'package:anchorage/module/State/model/state_model.dart';

class CityState {}

class CityStateInitial extends CityState {}

class CityStateLoading extends CityState {}

class CityStateSuccess extends CityState {
  final CityModel cityModel;
  CityStateSuccess(this.cityModel);
}

class CityStateFetchSuccess extends CityState {
  final List<CityModel> cities;
  CityStateFetchSuccess(this.cities);
}
class CountryStateFetchSuccess extends CityState {
  final List<CountryModel> countries;
  CountryStateFetchSuccess(this.countries);
}

class StateStateFetchSuccess extends CityState {
  final List<StateModel> states;
  StateStateFetchSuccess(this.states);
}

class CityStateFailure extends CityState {
  final String error;
  CityStateFailure(this.error);
}