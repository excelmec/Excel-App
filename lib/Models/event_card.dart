class Event {
  late int id;
  late String name;
  late String icon;
  late String category;
  late String date;
  late String eventType;
  late String about;
  late bool isCompetition;

  Event({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    required this.date,
    required this.eventType,
    required this.about,
    required this.isCompetition,
  });

  Event.fromJson(json) {
    id = json['id'] ?? "NA";
    name = json['name'] ?? "NA";
    icon = json['icon'] ?? "NA";
    eventType = json['eventType'] ?? "NA";
    category = json['category'] ??'NA';
    about = json['about'] ?? 'Excel 2023';
    date = json['datetime'] ?? "NA";
    isCompetition = json['needRegistration'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['category'] = this.category;
    data['datetime'] = this.date;
    data['eventType'] = this.eventType;
    data['about'] = this.about;
    data['needRegistration'] = this.isCompetition;

    return data;
  }
}

// class DateTimeConversion {
//   static String dateTimeToString(String dateTime) {
//     DateTime dateObject = DateTime.parse(dateTime);
//     String result = DateFormat('dd MMM yyyy').format(dateObject) +
//         ' | ' +
//         DateFormat.jm().format(dateObject);
//     return result;
//   }
// }


// class Event {
//   late int id;
//   late String name;
//   late String icon;
//   late String desc;
//   late String category;
//   late String date;
//   late String eventType;
//   late bool isCompetition;

//   Event({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.desc,
//     required this.category,
//     required this.date,
//     required this.eventType,
//     required this.isCompetition,
//   });

//  factory Event.fromJson(Map<String, dynamic> json) {
//   return Event(
//     id: json['id'] ?? 0, // Providing a default value if 'id' is null
//     name: json['name'] ?? '', // Providing a default value if 'name' is null
//     icon: json['icon'] ?? '', // Providing a default value if 'icon' is null
//     desc: json['desc'] ?? '', // Providing a default value if 'desc' is null
//     category: json['category'] ?? '', // Providing a default value if 'category' is null
//     date: json['datetime'] ?? '', // Providing a default value if 'datetime' is null
//     eventType: json['eventType'] ?? '', // Providing a default value if 'eventType' is null
//     isCompetition: json['isCompetition'] ?? false, // Providing a default value if 'isCompetition' is null
//   );
// }


//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {
//       'id': id,
//       'name': name,
//       'icon': icon,
//       'desc': desc,
//       'category': category,
//       'datetime': date,
//       'eventType': eventType,
//       'isCompetition': isCompetition,
//     };
//     return data;
//   }
// }
