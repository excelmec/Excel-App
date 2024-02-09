import 'dart:convert';

class User {
 late int id;
 late String name;
 late String email;
 late String role;
 late String picture;
 late String qrCodeUrl;
 late int institutionId;
 late String institutionName;
 late String gender;
 late String mobileNumber;
 late int categoryId;
 late String category;
 late String ambassador;
 late int referrerAmbassadorId;
 late String referrer;
 late bool isPaid;

  User({
  required  this.id,
  required  this.name,
  required  this.email,
  required  this.role,
  required  this.picture,
  required  this.qrCodeUrl,
  required  this.institutionId,
  required  this.institutionName,
  required  this.gender,
  required  this.mobileNumber,
  required  this.category,
  required  this.ambassador,
  required  this.referrerAmbassadorId,
  required  this.referrer,
  required  this.isPaid,
  });

  User.fromJson(json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    picture = json['picture'];
    qrCodeUrl = json['qrCodeUrl'];
    institutionId =
        json.containsKey('institutionId') ? json['institutionId'] : 0;
    institutionName =
        json.containsKey('institutionName') ? json['institutionName'] : null;
    gender = json['gender'];
    mobileNumber = json['mobileNumber'];
    categoryId = json['categoryId'];
    category = json['category'];
    ambassador = jsonEncode(json['ambassador']);
    referrerAmbassadorId = json['referrerAmbassadorId'];
    referrer = jsonEncode(json['referrer']);
    isPaid = (json['isPaid'] == true || json['isPaid'] == 1) ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['picture'] = this.picture;
    data['qrCodeUrl'] = this.qrCodeUrl;
    data['institutionId'] = this.institutionId;
    data['institutionName'] = this.institutionName;
    data['gender'] = this.gender;
    data['mobileNumber'] = this.mobileNumber;
    data['categoryId'] = this.categoryId;
    data['ambassador'] = jsonDecode(this.ambassador);
    data['referrerAmbassadorId'] = this.referrerAmbassadorId;
    data['referrer'] = jsonDecode(this.referrer);
    data['isPaid'] = this.isPaid;
    return data;
  }
}

class Institution {
  late int id;
  late String name;

  Institution({required this.id, required this.name});

  Institution.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
