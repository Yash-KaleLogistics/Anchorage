import 'package:anchorage/module/State/model/state_model.dart';
import 'package:dio/dio.dart';

import '../../../sql_data/api/sql_api.dart';

class StateRepository{

  SqlApi api = SqlApi();


  Future<StateModel> stateCreate(
      int countryId,
      String stateName,
      String stateCode) async {
    try {
      Response response =
      await api.sendRequest.post("states", data:
      {
        "countryId" : countryId,
        "stateName" : stateName,
        "stateCode" : stateCode,
      });

      StateModel stateModel = StateModel.fromJson(response.data);
      return stateModel;
    } catch (e) {
      throw e;
    }
  }

  Future<List<StateModel>> getAllStates() async {
    try {
      Response response = await api.sendRequest.get("states");
      List<StateModel> states = (response.data as List)
          .map((states) => StateModel.fromJson(states))
          .toList();
      return states;
    } catch (e) {
      throw e;
    }
  }

  Future<List<StateModel>> getAllStatesByCountryId(int countryId) async {
    try {
      Response response = await api.sendRequest.get("states/byCountry/$countryId");
      List<StateModel> states = (response.data as List)
          .map((states) => StateModel.fromJson(states))
          .toList();

      return states;
    } catch (e) {
      throw e;
    }
  }




  Future<void> updateStates(int id, int countryId, String stateName, String stateCode) async {
    try {
      await api.sendRequest.put("states/$id", data: {
        "countryId" : countryId,
        "stateName": stateName,
        "stateCode": stateCode,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteStates(int id) async {
    try {
      await api.sendRequest.delete("states/$id");
    } catch (e) {
      throw e;
    }
  }

}