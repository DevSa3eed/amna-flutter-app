class TeamMember {
  int? id;
  String? titel;
  String? position;
  String? image;

  TeamMember({this.id, this.titel, this.position, this.image});

  TeamMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titel = json['titel'];
    position = json['position'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titel'] = titel;
    data['position'] = position;
    data['image'] = image;
    return data;
  }
}
