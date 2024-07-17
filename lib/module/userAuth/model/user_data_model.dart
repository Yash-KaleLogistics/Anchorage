class UserDataModel {
  String? token;
  User? user;

  UserDataModel({this.token, this.user});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? password;
  String? mobileNumber;
  String? city;
  String? country;
  String? profileImage;
  String? userType;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
        this.name,
        this.email,
        this.password,
        this.mobileNumber,
        this.city,
        this.country,
        this.profileImage,
        this.userType,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobileNumber = json['mobileNumber'];
    city = json['city'];
    country = json['country'];
    profileImage = json['profileImage'];
    userType = json['userType'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobileNumber'] = this.mobileNumber;
    data['city'] = this.city;
    data['country'] = this.country;
    data['profileImage'] = this.profileImage;
    data['userType'] = this.userType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
