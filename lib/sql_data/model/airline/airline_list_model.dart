// To parse this JSON data, do
//
//     final airLineListModel = airLineListModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<AirLineListModel> airLineListModelFromJson(String str) => List<AirLineListModel>.from(json.decode(str).map((x) => AirLineListModel.fromJson(x)));

String airLineListModelToJson(List<AirLineListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AirLineListModel {
  String airlineId;
  String airlineName;
  String airlineFLocation;
  String airlineDLocation;
  String airlineKgTon;
  int airlineCapacity;
  String airlineCapacityPrice;
  String airlineImage;
  double airlineRating;
  bool airlineRecommended;
  String airlineFromDate;
  String airlineToDate;
  List<String> airlineDaySelection;

  AirLineListModel({
    required this.airlineId,
    required this.airlineName,
    required this.airlineFLocation,
    required this.airlineDLocation,
    required this.airlineKgTon,
    required this.airlineCapacity,
    required this.airlineCapacityPrice,
    required this.airlineImage,
    required this.airlineRating,
    required this.airlineRecommended,
    required this.airlineFromDate,
    required this.airlineToDate,
    required this.airlineDaySelection,
  });

  factory AirLineListModel.fromJson(Map<String, dynamic> json) => AirLineListModel(
    airlineId: json["airline_id"],
    airlineName: json["airline_name"],
    airlineFLocation: json["airline_f_location"],
    airlineDLocation: json["airline_d_location"],
    airlineKgTon: json["airline_kg_ton"],
    airlineCapacity: json["airline_capacity"],
    airlineCapacityPrice: json["airline_capacity_price"],
    airlineImage: json["airline_image"],
    airlineRating: json["airline_rating"]?.toDouble(),
    airlineRecommended: json["airline_recommended"],
    airlineFromDate: json["airline_from_date"],
    airlineToDate: json["airline_to_date"],
    airlineDaySelection: List<String>.from(json["airline_daySelection"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "airline_id": airlineId,
    "airline_name": airlineName,
    "airline_f_location": airlineFLocation,
    "airline_d_location": airlineDLocation,
    "airline_kg_ton": airlineKgTon,
    "airline_capacity": airlineCapacity,
    "airline_capacity_price": airlineCapacityPrice,
    "airline_image": airlineImage,
    "airline_rating": airlineRating,
    "airline_recommended": airlineRecommended,
    "airline_from_date": airlineFromDate,
    "airline_to_date": airlineToDate,
    "airline_daySelection": List<dynamic>.from(airlineDaySelection.map((x) => x)),
  };
}
