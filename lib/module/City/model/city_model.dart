class CityModel {
  int? id;
  int? stateId;
  String? cityName;
  String? cityCode;
  int? countryId;

  CityModel(
      {this.id, this.stateId, this.cityName, this.cityCode, this.countryId});

  CityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateId = json['stateId'];
    cityName = json['cityName'];
    cityCode = json['cityCode'];
    countryId = json['countryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stateId'] = this.stateId;
    data['cityName'] = this.cityName;
    data['cityCode'] = this.cityCode;
    data['countryId'] = this.countryId;
    return data;
  }
}
