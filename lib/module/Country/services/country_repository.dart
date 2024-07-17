import 'package:anchorage/module/Country/model/country_model.dart';
import 'package:dio/dio.dart';

import '../../../sql_data/api/sql_api.dart';

class CountryRepository{
  SqlApi api = SqlApi();



  Future<CountryModel> countryCreate(
      String countryName,
      String CountryCode) async {
    try {
      Response response =
      await api.sendRequest.post("countries", data:
      {
        "name" : countryName,
        "code" : CountryCode,
      });

      return CountryModel.fromJson(response.data);

    } catch (e) {
      throw e;
    }
  }


  Future<List<CountryModel>> getAllCountries({int limit = 10, int offset = 0}) async {
    try {
      Response response = await api.sendRequest.get("countries", queryParameters: {
        'limit': limit,
        'offset': offset,
      });
      List<CountryModel> countries = (response.data['data'] as List)
          .map((country) => CountryModel.fromJson(country))
          .toList();
      return countries;
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateCountry(int id, String countryName, String countryCode) async {
    try {
      await api.sendRequest.put("countries/$id", data: {
        "name": countryName,
        "code": countryCode,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteCountry(int id) async {
    try {
      await api.sendRequest.delete("countries/$id");
    } catch (e) {
      throw e;
    }
  }


}