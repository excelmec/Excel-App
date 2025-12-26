class EventModel {
  final int id;
  final String name;
  final String icon;
  final String eventType;
  final String category;
  final String venue;
  final bool? needRegistration; // nullable
  final int? day; // nullable
  final DateTime datetime;
  final int? prizeMoney; // nullable
  final String about;
  final int? eventHead1Id;
  final EventHead? eventHead1;
  final bool isTeam;
  final int? eventHead2Id;
  final EventHead? eventHead2;

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
    required this.isTeam,
    required this.eventHead2Id,
    required this.eventHead2,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as int,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
      eventType: json['eventType'] as String,
      category: json['category'] as String,
      venue: json['venue'] as String,
      needRegistration: json['needRegistration'] as bool?,
      day: json['day'] as int?,
      datetime: json['datetime'] != null
          ? DateTime.parse(json['datetime'] as String)
          : DateTime.now(),
      prizeMoney: json['prizeMoney'] as int?,
      about: json['about'] as String? ?? '',
      eventHead1Id: json['eventHead1Id'] as int?,
      eventHead1: json['eventHead1'] != null
          ? EventHead.fromJson(json['eventHead1'] as Map<String, dynamic>)
          : null,
      isTeam: json['isTeam'] as bool? ?? false,
      eventHead2Id: json['eventHead2Id'] as int?,
      eventHead2: json['eventHead2'] != null
          ? EventHead.fromJson(json['eventHead2'] as Map<String, dynamic>)
          : null,
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
      'eventHead1': eventHead1?.toJson(),
      'isTeam': isTeam,
      'eventHead2Id': eventHead2Id,
      'eventHead2': eventHead2?.toJson(),
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
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'phoneNumber': phoneNumber};
  }
}
