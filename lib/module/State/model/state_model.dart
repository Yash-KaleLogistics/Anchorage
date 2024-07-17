class StateModel {
  int? id;
  int? countryId;
  String? stateName;
  String? stateCode;

  StateModel({this.id, this.countryId, this.stateName, this.stateCode});

  StateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['countryId'];
    stateName = json['stateName'];
    stateCode = json['stateCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countryId'] = this.countryId;
    data['stateName'] = this.stateName;
    data['stateCode'] = this.stateCode;
    return data;
  }
}
