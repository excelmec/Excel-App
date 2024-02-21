class News {
late  int id;
late  String title;
late  String content;
late  String link;
late  String date;
late  String imageurl;

  News({
 required   this.id,
 required   this.title,
 required   this.content,
 required   this.link,
 required   this.date,
 required   this.imageurl,
  });

  News.fromJson(json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    link = json['link'];
    date = json['date'];
    imageurl = json['imageurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['link'] = this.link;
    data['date'] = this.date;
    data['imageurl'] = this.imageurl;
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
