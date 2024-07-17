import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anchorage/module/City/services/city_repository.dart';
import 'package:anchorage/module/Country/services/country_repository.dart';
import 'package:anchorage/module/State/services/state_repository.dart';
import 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(CityStateInitial());

  final CityRepository cityRepository = CityRepository();
  final CountryRepository countryRepository = CountryRepository();
  final StateRepository stateRepository = StateRepository();

  Future<void> cityCreate(int countryId, int stateId, String cityName, String cityCode) async {
    emit(CityStateLoading());
    try {
      final city = await cityRepository.cityCreate(countryId, stateId, cityName, cityCode);
      emit(CityStateSuccess(city));
    } catch (e) {
      emit(CityStateFailure('Failed to create city'));
    }
  }

  Future<void> fetchAllCountries() async {
    emit(CityStateLoading());
    try {
      final countries = await countryRepository.getAllCountries();
      emit(CountryStateFetchSuccess(countries));
    } catch (e) {
      emit(CityStateFailure('Failed to fetch countries'));
    }
  }

  Future<void> fetchAllStatesByCountryId(int countryId) async {
    emit(CityStateLoading());
    try {
      final states = await stateRepository.getAllStatesByCountryId(countryId);
      emit(StateStateFetchSuccess(states));
    } catch (e) {
      emit(CityStateFailure("Failed to fetch states"));
    }
  }

  Future<void> fetchAllCities() async {
    emit(CityStateLoading());
    try {
      final cities = await cityRepository.getAllCities();
      emit(CityStateFetchSuccess(cities));
    } catch (e) {
      emit(CityStateFailure('Failed to fetch cities'));
    }
  }

  Future<void> fetchAllCitiesByStateId(int stateId) async {
    emit(CityStateLoading());
    try {
      final cities = await cityRepository.getAllCitiesByStateId(stateId);
      emit(CityStateFetchSuccess(cities));
    } catch (e) {
      emit(CityStateFailure("Failed to fetch cities"));
    }
  }



  Future<void> deleteCities(int id) async {
    emit(CityStateLoading());
    try {
      await cityRepository.deleteCities(id);
      fetchAllCities(); // Refresh the list after deletion
    } catch (e) {
      emit(CityStateFailure('Failed to delete City'));
    }
  }

  Future<void> updateCities(int id, int countryId, int stateId, String cityName, String cityCode) async {
    emit(CityStateLoading());
    try {
      await cityRepository.updateCities(id,countryId, stateId, cityName, cityCode);
      fetchAllCities(); // Refresh the list after update
    } catch (e) {
      emit(CityStateFailure('Failed to update city'));
    }
  }



}
