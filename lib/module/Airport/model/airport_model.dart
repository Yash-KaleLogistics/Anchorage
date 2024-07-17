class AirportModel {
  int? id;
  int? countryId;
  int? stateId;
  int? cityId;
  String? airportName;
  String? airportCode;

  AirportModel(
      {this.id,
        this.countryId,
        this.stateId,
        this.cityId,
        this.airportName,
        this.airportCode});

  AirportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['countryId'];
    stateId = json['stateId'];
    cityId = json['cityId'];
    airportName = json['airportName'];
    airportCode = json['airportCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countryId'] = this.countryId;
    data['stateId'] = this.stateId;
    data['cityId'] = this.cityId;
    data['airportName'] = this.airportName;
    data['airportCode'] = this.airportCode;
    return data;
  }
}
