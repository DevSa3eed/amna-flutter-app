class Opinions {
  int? id;
  String? titel;
  String? description;
  User? user;

  Opinions({this.id, this.titel, this.description, this.user});

  Opinions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titel = json['titel'];
    description = json['description'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titel'] = titel;
    data['description'] = description;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? usersId;
  String? imageCover;
  String? fullName;

  User({this.usersId, this.imageCover, this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    usersId = json['usersId'];
    imageCover = json['imageCover'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usersId'] = usersId;
    data['imageCover'] = imageCover;
    data['fullName'] = fullName;
    return data;
  }
}
