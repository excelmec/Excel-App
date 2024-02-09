class Event {
  late  int id;
 late String name;
 late String icon;
 late String desc;
 late String category;
 late String date;
 late String eventType;
 late bool isCompetition;

  Event(
      {
        required this.id,
     required this.name,
     required this.icon,
     required this.desc,
    required  this.category,
     required this.date,
      required this.isCompetition});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['eventType'] = this.desc;
    data['category'] = this.category;
    data['datetime'] = this.date;
    data['eventType'] = this.eventType;
    return data;
  }

  static fromJson(event) {}
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
