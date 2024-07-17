

import 'package:dio/dio.dart';

import '../../../sql_data/api/sql_api.dart';
import '../model/airport_model.dart';

class AirportRepository{

  SqlApi api = SqlApi();


  Future<AirportModel> airportCreate(
      int countryId,
      int stateId,
      int cityId,
      String airportName,
      String airportCode) async {
    try {
      Response response = await api.sendRequest.post("airports", data:
      {
        "countryId" : countryId,
        "stateId" : stateId,
        "cityId" : cityId,
        "airportName" : airportName,
        "airportCode" : airportCode
      });

      AirportModel airportModel = AirportModel.fromJson(response.data);
      return airportModel;
    } catch (e) {
      throw e;
    }
  }

  Future<List<AirportModel>> getAllAirports() async {
    try {
      Response response = await api.sendRequest.get("airports");
      List<AirportModel> cities = (response.data as List)
          .map((states) => AirportModel.fromJson(states))
          .toList();
      return cities;
    } catch (e) {
      throw e;
    }
  }

  Future<List<AirportModel>> getAllAirportsByCityId(int cityId) async {
    try {
      Response response = await api.sendRequest.get("airports/byCities/${cityId}");
      List<AirportModel> cities = (response.data as List)
          .map((states) => AirportModel.fromJson(states))
          .toList();
      return cities;
    } catch (e) {
      throw e;
    }
  }


  Future<void> updateAirports(
      int id,
      int countryId,
      int stateId,
      int cityId,
      String airportName,
      String airportCode) async {
    try {
      await api.sendRequest.put("airports/$id", data: {
        "countryId" : countryId,
        "stateId" : stateId,
        "cityId" : cityId,
        "airportName" : airportName,
        "airportCode" : airportCode
      });
    } catch (e) {
      throw e;
    }
  }


  Future<void> deleteAirports(int id) async {
    try {
      await api.sendRequest.delete("airports/$id");
    } catch (e) {
      throw e;
    }
  }


}