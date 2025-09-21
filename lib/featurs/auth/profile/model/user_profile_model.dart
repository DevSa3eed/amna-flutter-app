class UserProfile {
  String? id;
  String? fullName;
  String? phoneNumber;
  String? userName;
  String? email;
  String? dateTime;
  bool? isAdmin;
  String? imageCover;

  UserProfile(
      {this.id,
      this.fullName,
      this.phoneNumber,
      this.userName,
      this.email,
      this.dateTime,
      this.isAdmin,
      this.imageCover});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    userName = json['userName'];
    email = json['email'];
    dateTime = json['dateTime'];
    isAdmin = json['isAdmin'];
    imageCover = json['imageCover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullName;
    data['phoneNumber'] = phoneNumber;
    data['userName'] = userName;
    data['email'] = email;
    data['dateTime'] = dateTime;
    data['isAdmin'] = isAdmin;
    data['imageCover'] = imageCover;
    return data;
  }
}
