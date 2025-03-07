import 'package:intl/intl.dart';

class ScheduleModel {
  late int id;
  late String name;
  late String icon;
  late String eventType;
  late String category;
  late bool needRegistration;
  late String round;
  late int roundId;
  late int day;
  late String datetime;

  ScheduleModel(
      {required this.id,
      required this.name,
      required this.icon,
      required this.eventType,
      required this.category,
      required this.needRegistration,
      required this.round,
      required this.roundId,
      required this.day,
      required this.datetime});

  ScheduleModel.fromJson(json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    eventType = json['eventType'];
    category = json['category'];
    needRegistration = json['needRegistration'] ?? false;
    round = json['round'] ?? "";
    roundId = json['roundId'];
    day = json['day'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['eventType'] = this.eventType;
    data['category'] = this.category;
    data['needRegistration'] = this.needRegistration;
    data['round'] = this.round;
    data['roundId'] = this.roundId;
    data['day'] = this.day;
    data['datetime'] = this.datetime;
    return data;
  }
}

class ScheduleDateTimeConversion {
  static String dateTimeToString(String dateTime) {
    DateTime dateObject = DateTime.parse(dateTime);
    String result = DateFormat.jm().format(dateObject);
    return result;
  }
}
