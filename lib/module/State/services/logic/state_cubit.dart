
import 'package:anchorage/module/Country/services/country_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state_repository.dart';
import 'State_state.dart';


class StateCubit extends Cubit<StateState>{
  StateCubit() : super( StateStateInitial() );

  StateRepository stateRepository = StateRepository();
  CountryRepository countryRepository = CountryRepository();

  Future<void> stateCreate(
      int countryId,
      String stateName,
      String stateCode) async {
    emit(StateStateLoading());
    try {
      await stateRepository.stateCreate(
          countryId,
          stateName,
          stateCode);

   //   emit(StateStateSuccess(countryModel));

      fetchAllStates();

    } catch (e) {
      emit(StateStateFailure('Fail'));
    }
  }

  Future<void> fetchAllCountries() async {
    emit(StateStateLoading());
    try {
      final countries = await countryRepository.getAllCountries();
      emit(CountryStateFetchSuccess(countries));
    } catch (e) {
      emit(StateStateFailure('Failed to fetch countries'));
    }
  }


  Future<void> fetchAllStates() async {
    emit(StateStateLoading());
    try {
      final states = await stateRepository.getAllStates();
      emit(StateStateFetchSuccess(states));
    } catch (e) {
      emit(StateStateFailure('Failed to fetch states'));
    }
  }

  Future<void> fetchAllStatesByCountryId(int countryId) async {
    emit(StateStateLoading());
    try {
      final states = await stateRepository.getAllStatesByCountryId(countryId);
      emit(StateStateFetchSuccess(states));
    } catch (e) {
      emit(StateStateFailure("Failed to fetch states"));
    }
  }

  Future<void> updateStates(int id, int countryId, String stateName, String stateCode) async {
    emit(StateStateLoading());
    try {
      await stateRepository.updateStates(id,countryId, stateName, stateCode);
      fetchAllStates(); // Refresh the list after update
    } catch (e) {
      emit(StateStateFailure('Failed to update State'));
    }
  }

  Future<void> deleteStates(int id) async {
    emit(StateStateLoading());
    try {
      await stateRepository.deleteStates(id);
      fetchAllStates(); // Refresh the list after deletion
    } catch (e) {
      emit(StateStateFailure('Failed to delete State'));
    }
  }


}