import 'package:anchorage/module/Country/services/country_repository.dart';
import 'package:anchorage/module/Country/services/logic/country_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CountryCubit extends Cubit<CountryState>{
  CountryCubit() : super( CountryStateInitial() );

  CountryRepository countryRepository = CountryRepository();

  Future<void> CountryCreate(
      String countryName,
      String contryCode) async {
    emit(CountryStateLoading());
    try {
     await countryRepository.countryCreate(
        countryName,
        contryCode);

      fetchAllCountries();
    } catch (e) {
      emit(CountryStateFailure('Fail to create'));
    }
  }

  Future<void> fetchAllCountries({int limit = 10, int offset = 0}) async {
    emit(CountryStateLoading());
    try {
      final countries = await countryRepository.getAllCountries(limit: limit, offset: offset);
      emit(CountryStateFetchSuccess(countries));
    } catch (e) {
      emit(CountryStateFailure('Failed to fetch countries'));
    }
  }

  Future<void> updateCountry(int id, String countryName, String countryCode) async {
    emit(CountryStateLoading());
    try {
      await countryRepository.updateCountry(id, countryName, countryCode);
      fetchAllCountries(); // Refresh the list after update
    } catch (e) {
      emit(CountryStateFailure('Failed to update country'));
    }
  }

  Future<void> deleteCountry(int id) async {
    emit(CountryStateLoading());
    try {
      await countryRepository.deleteCountry(id);
      fetchAllCountries(); // Refresh the list after deletion
    } catch (e) {
      emit(CountryStateFailure('Failed to delete country'));
    }
  }

}