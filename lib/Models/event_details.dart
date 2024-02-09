class EventDetails {
  late int id;
  late String name;
  late String icon;
  late int categoryId;
  late String category;
  late int eventTypeId;
  late String eventType;
  late String about;
  late String format;
  late String rules;
  late String venue;
  late int day;
  late String datetime;
  late int entryFee;
  late int prizeMoney;
  late int eventHead1Id;
  late String eventHead1;
  late int eventHead2Id;
  late String eventHead2;
 late bool isTeam;
  late int teamSize;
  late int eventStatusId;
  late String eventStatus;
  late int numberOfRounds;
  late int currentRound;
  late bool needRegistration;
  late bool registrationOpen;
  late String registrationEndDate;
  late String button;
  late String registrationLink;
  late String rounds;
  late String registration;
  EventDetails({
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

  EventDetails.fromJson(data) {
    id = data['id'];
    name = data['name'];
    icon = data['icon'];
    categoryId = data['categoryId'];
    category = data['category'];
    eventTypeId = data['eventTypeId'];
    eventType = data['eventType'];
    about = data['about'];
    format = data['format'];
    rules = data['rules'];
    venue = data['venue'];
    day = data['day'];
    datetime = data['datetime'];
    entryFee = data['entryFee'];
    prizeMoney = data['prizeMoney'];
    eventHead1Id = data['eventHead1Id'];
    eventHead1 = data['eventHead1'];
    eventHead2Id = data['eventHead2Id'];
    eventHead2 = data['eventHead2'];
    isTeam = (data['isTeam'] == true || data['isTeam'] == 1) ? true : false;
    teamSize = data['teamSize'] ?? 1;
    eventStatusId = data['eventStatusId'];
    eventStatus = data['eventStatus'];
    numberOfRounds = data['numberOfRounds'];
    currentRound = data['currentRound'];
    needRegistration = data['needRegistration'];
    registrationOpen =
        (data['registrationOpen'] == true || data['registrationOpen'] == 1)
            ? true
            : false;
    registrationEndDate = data['registrationEndDate'];
    button = data['button'];
    registrationLink = data['registrationLink'];
    rounds = data['rounds'];
    registration = data['registration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['categoryId'] = this.categoryId;
    data['category'] = this.category;
    data['eventTypeId'] = this.eventTypeId;
    data['eventType'] = this.eventType;
    data['about'] = this.about;
    data['format'] = this.format;
    data['rules'] = this.rules;
    data['venue'] = this.venue;
    data['day'] = this.day;
    data['datetime'] = this.datetime;
    // data['entryFee]'] = this.entryFee;
    data['prizeMoney'] = this.prizeMoney;
    data['eventHead1Id'] = this.eventHead1Id;
    data['eventHead1'] = this.eventHead1;
    data['eventHead2Id'] = this.eventHead2Id;
    data['eventHead2'] = this.eventHead2;
    data['isTeam'] = this.isTeam;
    data['teamSize'] = this.teamSize;
    data['eventStatusId'] = this.eventStatusId;
    data['eventStatus'] = this.eventStatus;
    data['numberOfRounds'] = this.numberOfRounds;
    data['currentRound'] = this.currentRound;
    data['needRegistration'] = this.needRegistration;
    data['registrationOpen'] = this.registrationOpen;
    data['registrationEndDate'] = this.registrationEndDate;
    data['button'] = this.button;
    data['registrationLink'] = this.registrationLink;
    data['rounds'] = this.rounds;
    return data;
  }
}
