class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String picture;
  final int institutionId;
  final String institutionName;
  final String gender;
  final String mobileNumber;
  final int categoryId;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.picture,
    required this.institutionId,
    required this.institutionName,
    required this.gender,
    required this.mobileNumber,
    required this.categoryId,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      picture: json['picture'],
      institutionId: json['institution_id'],
      institutionName: json['institution'],
      gender: json['gender'],
      mobileNumber: json['mobile_number'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'picture': picture,
      'institution_id': institutionId,
      'institution_name': institutionName,
      'gender': gender,
      'mobile_number': mobileNumber,
      'category_id': categoryId,
    };
  }
}
