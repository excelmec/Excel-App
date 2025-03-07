class ViewUser {
  late int id;
  late String name;
  late String email;

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

  ViewUser({
    required this.id,
    required this.name,
    required this.email,
    required this.picture,
    required this.qrCodeUrl,
    required this.institutionName,
    required this.gender,
    required this.mobileNumber,
    required this.category,
    required this.referrerAmbassadorId,
    required this.isPaid,
  });

  ViewUser.fromJson(json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "Not added";
    email = json['email'] ?? "Not added";
    picture = json['picture'] ?? "Not added";
    qrCodeUrl = json['qrCodeUrl'] ?? "Not added";
    institutionId = json['institutionId'] ?? 0;
    institutionName = json['institutionName'] ?? "Not mentioned";
    gender = json['gender'] ?? "---";
    mobileNumber = json['mobileNumber'] ?? "Not mentioned";
    category = json['category'] ?? "NA";
    //   ambassador = jsonEncode(json['ambassador']) ?? jsonEncode({
    //   "id": 0,
    //   "userId": 0,
    //   "user": "string",
    //   "referredUsers": [
    //     "string"
    //   ],
    //   "freeMembership": 0,
    //   "paidMembership": 0
    // });

    referrerAmbassadorId = json['referrerAmbassadorId'] ?? 0;
    // referrer = jsonEncode(json['referrer']) ?? "NA";

    isPaid = (json['isPaid'] == true || json['isPaid'] == 1) ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['picture'] = this.picture;
    data['qrCodeUrl'] = this.qrCodeUrl;
    data['institutionName'] = this.institutionName;
    data['gender'] = this.gender;
    data['mobileNumber'] = this.mobileNumber;
    data['referrerAmbassadorId'] = this.referrerAmbassadorId;
    data['isPaid'] = this.isPaid;
    return data;
  }
}
