import 'package:excelapp2025/core/api/routes/api_routes.dart';
import 'package:excelapp2025/core/api/services/api_service.dart';
import 'package:excelapp2025/core/api/services/auth_service.dart';
import 'package:excelapp2025/features/discover/data/models/event_model.dart';

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
  late List<EventModel> registeredEvents;

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
    //TODO: Handle missing fields appropriately
    return ProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Error",
      email: json['email'] ?? "Unavailable",
      role: json['role'] ?? "User",
      picture: json['picture'] ?? "https://www.gravatar.com/avatar/",
      institutionId: json['institutionId'] ?? 0,
      institutionName: json['institutionName'] ?? 'Unknown Institution',
      gender: json['gender'] ?? 'Not Specified',
      mobileNumber: json['mobileNumber'] ?? 'Not Provided',
      categoryId: json['categoryId'] ?? 0,
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
