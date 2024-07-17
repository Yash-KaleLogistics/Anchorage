import 'package:anchorage/module/Country/model/country_model.dart';

class CountryState {}

class CountryStateInitial extends CountryState {}

class CountryStateLoading extends CountryState {}

class CountryStateSuccess extends CountryState {
  final CountryModel countryModel;
  CountryStateSuccess(this.countryModel);
}

class CountryStateFetchSuccess extends CountryState {
  final List<CountryModel> countries;
  CountryStateFetchSuccess(this.countries);
}

class CountryStateFailure extends CountryState {
  final String error;
  CountryStateFailure(this.error);
}