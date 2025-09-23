class Opinions {
  int? id;
  String? titel;
  String? description;
  double? rating;
  User? user;
  DateTime? createdAt;

  Opinions({
    this.id,
    this.titel,
    this.description,
    this.rating,
    this.user,
    this.createdAt,
  });

  Opinions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titel = json['titel'];
    description = json['description'];
    rating = json['rating']?.toDouble();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    createdAt =
        json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titel'] = titel;
    data['description'] = description;
    data['rating'] = rating;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['createdAt'] = createdAt?.toIso8601String();
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
