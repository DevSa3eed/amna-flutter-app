class Banners {
  int? id;
  String? titel;
  String? description;
  String? image;

  Banners({this.id, this.titel, this.description, this.image});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titel = json['titel'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titel'] = titel;
    data['description'] = description;
    data['image'] = image;
    return data;
  }
}
