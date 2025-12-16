import 'package:intl/intl.dart';

class CalendarEventModel {
  final int id;
  final String name;
  final String icon;
  final DateTime datetime;
  final String venue;

  CalendarEventModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.datetime,
    required this.venue,
  });

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    return CalendarEventModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
      datetime: DateTime.parse(json['datetime'] as String),
      venue: json['venue'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'datetime': datetime.toIso8601String(),
      'venue': venue,
    };
  }

  String get time => DateFormat('h:mm a').format(datetime).toLowerCase();
}
