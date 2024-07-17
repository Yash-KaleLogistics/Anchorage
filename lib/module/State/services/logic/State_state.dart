import 'package:anchorage/module/Country/model/country_model.dart';
import 'package:anchorage/module/State/model/state_model.dart';

class StateState {}

class StateStateInitial extends StateState {}

class StateStateLoading extends StateState {}

class StateStateSuccess extends StateState {
  final StateModel stateModel;
  StateStateSuccess(this.stateModel);
}

class StateStateFetchSuccess extends StateState {
  final List<StateModel> states;
  StateStateFetchSuccess(this.states);
}
class CountryStateFetchSuccess extends StateState {
  final List<CountryModel> countries;
  CountryStateFetchSuccess(this.countries);
}

class StateStateFailure extends StateState {
  final String error;
  StateStateFailure(this.error);
}