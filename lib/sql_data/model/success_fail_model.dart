
import 'dart:convert';

SuccessFailModel successFailModelFromJson(String str) => SuccessFailModel.fromJson(json.decode(str));

String successFailModelToJson(SuccessFailModel data) => json.encode(data.toJson());

class SuccessFailModel {
  String message;

  SuccessFailModel({
    required this.message,
  });

  factory SuccessFailModel.fromJson(Map<String, dynamic> json) => SuccessFailModel(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
