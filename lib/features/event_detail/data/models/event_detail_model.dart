class EventDetailModel {
  final int id;
  final String name;
  final String icon;
  final int categoryId;
  final String category;
  final int eventTypeId;
  final String eventType;
  final String about;
  final String format;
  final String rules;
  final String venue;
  final int? day;
  final DateTime datetime;
  final int? entryFee;
  final int? prizeMoney;
  final int? eventHead1Id;
  final EventHead? eventHead1;
  final int? eventHead2Id;
  final EventHead? eventHead2;
  final bool isTeam;
  final int? teamSize;
  final int eventStatusId;
  final String eventStatus;
  final int numberOfRounds;
  final int currentRound;
  final bool needRegistration;
  final bool? registrationOpen;
  final DateTime? registrationEndDate;
  final String? button;
  final String? registrationLink;
  final List<Round> rounds;
  final dynamic registration;

  EventDetailModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.categoryId,
    required this.category,
    required this.eventTypeId,
    required this.eventType,
    required this.about,
    required this.format,
    required this.rules,
    required this.venue,
    required this.day,
    required this.datetime,
    required this.entryFee,
    required this.prizeMoney,
    required this.eventHead1Id,
    required this.eventHead1,
    required this.eventHead2Id,
    required this.eventHead2,
    required this.isTeam,
    required this.teamSize,
    required this.eventStatusId,
    required this.eventStatus,
    required this.numberOfRounds,
    required this.currentRound,
    required this.needRegistration,
    required this.registrationOpen,
    required this.registrationEndDate,
    required this.button,
    required this.registrationLink,
    required this.rounds,
    required this.registration,
  });

  factory EventDetailModel.fromJson(Map<String, dynamic> json) {
    return EventDetailModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      categoryId: json['categoryId'] as int? ?? 0,
      category: json['category'] as String? ?? '',
      eventTypeId: json['eventTypeId'] as int? ?? 0,
      eventType: json['eventType'] as String? ?? '',
      about: json['about'] as String? ?? '',
      format: json['format'] as String? ?? '',
      rules: json['rules'] as String? ?? '',
      venue: json['venue'] as String? ?? '',
      day: json['day'] as int?,
      datetime: json['datetime'] != null
          ? DateTime.parse(json['datetime'] as String)
          : DateTime.now(),
      entryFee: json['entryFee'] as int?,
      prizeMoney: json['prizeMoney'] as int?,
      eventHead1Id: json['eventHead1Id'] as int?,
      eventHead1: json['eventHead1'] != null && json['eventHead1'] is Map
          ? EventHead.fromJson(json['eventHead1'] as Map<String, dynamic>)
          : null,
      eventHead2Id: json['eventHead2Id'] as int?,
      eventHead2: json['eventHead2'] != null && json['eventHead2'] is Map
          ? EventHead.fromJson(json['eventHead2'] as Map<String, dynamic>)
          : null,
      isTeam: json['isTeam'] as bool? ?? false,
      teamSize: json['teamSize'] as int?,
      eventStatusId: json['eventStatusId'] as int? ?? 0,
      eventStatus: json['eventStatus'] as String? ?? '',
      numberOfRounds: json['numberOfRounds'] as int? ?? 0,
      currentRound: json['currentRound'] as int? ?? 0,
      needRegistration: json['needRegistration'] as bool? ?? false,
      registrationOpen: json['registrationOpen'] as bool?,
      registrationEndDate: json['registrationEndDate'] != null
          ? DateTime.parse(json['registrationEndDate'] as String)
          : null,
      button: json['button'] as String?,
      registrationLink: json['registrationLink'] as String?,
      rounds: json['rounds'] != null && json['rounds'] is List
          ? (json['rounds'] as List)
                .map((e) => Round.fromJson(e as Map<String, dynamic>))
                .toList()
          : [],
      registration: json['registration'],
    );
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
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }
}

class Round {
  final int id;
  final String? round;
  final int? day;
  final DateTime? datetime;

  Round({
    required this.id,
    required this.round,
    required this.day,
    required this.datetime,
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'] as int? ?? 0,
      round: json['round'] as String?,
      day: json['day'] as int?,
      datetime: json['datetime'] != null
          ? DateTime.parse(json['datetime'] as String)
          : null,
    );
  }
}
