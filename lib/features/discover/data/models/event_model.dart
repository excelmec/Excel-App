class EventModel {
  final int id;
  final String name;
  final String icon;
  final String eventType;
  final String category;
  final String venue;
  final bool? needRegistration;   // nullable
  final int? day;                 // nullable
  final DateTime datetime;
  final int? prizeMoney;          // nullable
  final String about;
  final int eventHead1Id;
  final EventHead eventHead1;
  final int eventHead2Id;
  final EventHead eventHead2;

  EventModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.eventType,
    required this.category,
    required this.venue,
    required this.needRegistration,
    required this.day,
    required this.datetime,
    required this.prizeMoney,
    required this.about,
    required this.eventHead1Id,
    required this.eventHead1,
    required this.eventHead2Id,
    required this.eventHead2,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      eventType: json['eventType'],
      category: json['category'],
      venue: json['venue'],
      needRegistration: json['needRegistration'] as bool?,
      day: json['day'] as int?,
      datetime: DateTime.parse(json['datetime']),
      prizeMoney: json['prizeMoney'] as int?,
      about: json['about'],
      eventHead1Id: json['eventHead1Id'],
      eventHead1: EventHead.fromJson(json['eventHead1']),
      eventHead2Id: json['eventHead2Id'],
      eventHead2: EventHead.fromJson(json['eventHead2']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'eventType': eventType,
      'category': category,
      'venue': venue,
      'needRegistration': needRegistration,
      'day': day,
      'datetime': datetime.toIso8601String(),
      'prizeMoney': prizeMoney,
      'about': about,
      'eventHead1Id': eventHead1Id,
      'eventHead1': eventHead1.toJson(),
      'eventHead2Id': eventHead2Id,
      'eventHead2': eventHead2.toJson(),
    };
  }
}

class EventHead {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;

  EventHead({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory EventHead.fromJson(Map<String, dynamic> json) {
    return EventHead(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
