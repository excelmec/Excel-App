class Highlights {
  late int id;
  late String name;
  late String image;

  Highlights({required this.id, required this.name, required this.image});

  Highlights.fromJson(json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}
