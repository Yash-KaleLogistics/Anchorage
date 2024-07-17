

import 'package:anchorage/module/Airport/services/logic/airport_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../City/services/city_repository.dart';
import '../../../Country/services/country_repository.dart';
import '../../../State/services/state_repository.dart';
import '../airport_repository.dart';

class AirportCubit extends Cubit<AirportState> {
  AirportCubit() : super(AirportStateInitial());

  final AirportRepository airportRepository = AirportRepository();
  final CityRepository cityRepository = CityRepository();
  final CountryRepository countryRepository = CountryRepository();
  final StateRepository stateRepository = StateRepository();

  Future<void> airportCreate(int countryId, int stateId, int cityId, String airPortName, String airPortCode) async {
    emit(AirportStateLoading());
    try {
      final city = await airportRepository.airportCreate(countryId, stateId, cityId, airPortName, airPortCode);
      emit(AirportStateSuccess(city));
    } catch (e) {
      emit(AirportStateFailure('Failed to create airport'));
    }
  }

  Future<void> fetchAllCountries() async {
    emit(AirportStateLoading());
    try {
      final countries = await countryRepository.getAllCountries();
      emit(CountryStateFetchSuccess(countries));
    } catch (e) {
      emit(AirportStateFailure('Failed to fetch countries'));
    }
  }

  Future<void> fetchAllStatesByCountryId(int countryId) async {
    emit(AirportStateLoading());
    try {
      final states = await stateRepository.getAllStatesByCountryId(countryId);
      emit(StateStateFetchSuccess(states));
    } catch (e) {
      emit(AirportStateFailure("Failed to fetch states"));
    }
  }

  Future<void> fetchAllCitiesByStateId(int stateId) async {
    emit(AirportStateLoading());
    try {
      final cities = await cityRepository.getAllCitiesByStateId(stateId);
      emit(CityStateFetchSuccess(cities));
    } catch (e) {
      emit(CityStateFailure("Failed to fetch cities"));
    }
  }

  Future<void> fetchAllAirports() async {
    emit(AirportStateLoading());
    try {
      final airports = await airportRepository.getAllAirports();
      emit(AirportStateFetchSuccess(airports));
    } catch (e) {
      emit(AirportStateFailure('Failed to fetch airports'));
    }
  }

  Future<void> fetchAirportsByCityId(int cityId) async {
    emit(AirportStateLoading());
    try {
      final airports = await airportRepository.getAllAirportsByCityId(cityId);
      emit(AirportStateFetchSuccess(airports));
    } catch (e) {
      emit(AirportStateFailure('Failed to fetch airports'));
    }
  }



  Future<void> deleteAirports(int id) async {
    emit(AirportStateLoading());
    try {
      await airportRepository.deleteAirports(id);
      fetchAllAirports(); // Refresh the list after deletion
    } catch (e) {
      emit(AirportStateFailure('Failed to delete Airport'));
    }
  }

  Future<void> updateAirport(int id, int countryId, int stateId, int cityId, String airportName, String airportCode) async {
    emit(AirportStateLoading());
    try {
      await airportRepository.updateAirports(id,countryId, stateId, cityId, airportName, airportCode);
      fetchAllAirports(); // Refresh the list after update
    } catch (e) {
      emit(AirportStateFailure('Failed to update airport'));
    }
  }



}
