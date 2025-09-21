class MeetingRequest {
  int? id;
  String? titel;
  String? description;
  bool? isApproved;
  bool? payment;
  double? price;
  User? user;

  MeetingRequest(
      {this.id,
      this.titel,
      this.description,
      this.isApproved,
      this.payment,
      this.price,
      this.user});

  MeetingRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titel = json['titel'];
    description = json['description'];
    isApproved = json['isApproved'];
    payment = json['payment'];
    price = json['price'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titel'] = titel;
    data['description'] = description;
    data['isApproved'] = isApproved;
    data['payment'] = payment;
    data['price'] = price;
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
  String? phoneNumber;

  User({this.usersId, this.imageCover, this.fullName, this.phoneNumber});

  User.fromJson(Map<String, dynamic> json) {
    usersId = json['usersId'];
    imageCover = json['imageCover'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['usersId'] = usersId;
    data['imageCover'] = imageCover;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
