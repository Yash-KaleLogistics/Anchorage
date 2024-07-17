import 'package:anchorage/sql_data/model/airline/airline_list_model.dart';
import 'package:dio/dio.dart';

import '../api/sql_api.dart';
import '../model/success_fail_model.dart';

class AirlineRepository {
  SqlApi api = SqlApi();

  Stream<List<AirLineListModel>> fetchAirlineListDataStream() async* {
    while (true) {
      final response =
          await api.sendRequest.get("airline/airline_booking_list/");
      if (response.statusCode == 200) {
        List<dynamic> postMaps = response.data;
        yield postMaps
            .map((postMap) => AirLineListModel.fromJson(postMap))
            .toList();
      } else {
        throw Exception('Failed to fetch data');
      }
      await Future.delayed(
          Duration(seconds: 10)); // Fetch data every 10 seconds
    }
  }

  Stream<List<AirLineListModel>> searchAirlineListDataStream(String airline_f_location,
      String airline_d_location,
      String airline_kg_ton,
      double airline_capacity,
      String airline_from_date) async* {
    while (true) {
      final response =
      await api.sendRequest.post("airlines/search", data:
      {
        "f_location" : "${airline_f_location}",
        "d_location" : "${airline_d_location}",
        "kg_ton" : "${airline_kg_ton}",
        "capacity" : airline_capacity,
        "post_date" : "${airline_from_date}"
      });
      if (response.statusCode == 200) {
        List<dynamic> postMaps = response.data;
        yield postMaps
            .map((postMap) => AirLineListModel.fromJson(postMap))
            .toList();
      } else {
        throw Exception('Failed to fetch data');
      }
      await Future.delayed(
          Duration(seconds: 10)); // Fetch data every 10 seconds
    }
  }





  Future<SuccessFailModel> airlineCreate(
      String airline_image,
      String airline_id,
      String airline_name,
      String airline_f_location,
      String airline_d_location,
      String airline_kg_ton,
      double airline_capacity,
      String airline_capacity_price,
      String airline_from_date,
      String airline_to_date,
      double airline_rating,
      List<String> airline_daySelection,
      bool airline_recommended) async {
    try {
      /*print(
          "CHECK_BOOKING_SCREEN==== ${hotelName} == ${cityName} == ${priceForNight} == ${rating} == ${recomanded} == ${dateTime}");
*/
      Response response =
          await api.sendRequest.post("airlines", data:
          {
            "airline_id" : airline_id,
            "airline_name" : airline_name,
            "airline_f_location" : airline_f_location,
            "airline_d_location" : airline_d_location,
            "airline_kg_ton" : airline_kg_ton,
            "airline_capacity" : airline_capacity,
            "airline_capacity_price" : airline_capacity_price,
            "airline_image" : airline_image,
            "airline_rating" : airline_rating,
            "airline_recommended" : airline_recommended,
            "airline_from_date" : airline_from_date,
            "airline_to_date" : airline_to_date,
            "airline_daySelection" : airline_daySelection
          });

      SuccessFailModel successFailModel =
          SuccessFailModel.fromJson(response.data);
      return successFailModel;
    } catch (e) {
      throw e;
    }
  }
}
