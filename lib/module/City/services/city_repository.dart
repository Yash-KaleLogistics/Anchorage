import 'package:anchorage/module/State/model/state_model.dart';
import 'package:dio/dio.dart';

import '../../../sql_data/api/sql_api.dart';
import '../model/city_model.dart';

class CityRepository{

  SqlApi api = SqlApi();


  Future<CityModel> cityCreate(
      int countryId,
      int stateId,
      String cityName,
      String cityCode) async {
    try {
      Response response =
      await api.sendRequest.post("cities", data:
      {
        "countryId" : countryId,
        "stateId" : stateId,
        "cityName" : cityName,
        "cityCode" : cityCode,
      });

      CityModel cityModel = CityModel.fromJson(response.data);
      return cityModel;
    } catch (e) {
      throw e;
    }
  }

  Future<List<CityModel>> getAllCities() async {
    try {
      Response response = await api.sendRequest.get("cities");
      List<CityModel> cities = (response.data as List)
          .map((states) => CityModel.fromJson(states))
          .toList();
      return cities;
    } catch (e) {
      throw e;
    }
  }

  Future<List<CityModel>> getAllCitiesByStateId(int stateId) async {
    try {
      Response response = await api.sendRequest.get("cities/byStates/$stateId");
      List<CityModel> cities = (response.data as List)
          .map((states) => CityModel.fromJson(states))
          .toList();

      return cities;
    } catch (e) {
      throw e;
    }
  }



  Future<void> updateCities(int id, int countryId, int stateId, String cityName, String cityCode) async {
    try {
      await api.sendRequest.put("cities/$id", data: {
        "countryId" : countryId,
        "stateId" : stateId,
        "cityName" : cityName,
        "cityCode" : cityCode,
      });
    } catch (e) {
      throw e;
    }
  }


  Future<void> deleteCities(int id) async {
    try {
      await api.sendRequest.delete("cities/$id");
    } catch (e) {
      throw e;
    }
  }


}