class AuthUser {
  String? id;
  bool? isAdmin;
  String? message;
  bool? isAuthenticated;
  String? username;
  String? fullname;
  String? email;
  String? image;
  String? token;
  String? expiresOn;
  String? refreshTokenExpiration;

  AuthUser(
      {this.id,
      this.isAdmin,
      this.message,
      this.isAuthenticated,
      this.username,
      this.fullname,
      this.email,
      this.image,
      this.token,
      this.expiresOn,
      this.refreshTokenExpiration});

  AuthUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isAdmin = json['isAdmin'];
    message = json['message'];
    isAuthenticated = json['isAuthenticated'];
    username = json['username'];
    fullname = json['fullname'];
    email = json['email'];
    image = json['image'];
    token = json['token'];
    expiresOn = json['expiresOn'];
    refreshTokenExpiration = json['refreshTokenExpiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isAdmin'] = isAdmin;
    data['message'] = message;
    data['isAuthenticated'] = isAuthenticated;
    data['username'] = username;
    data['fullname'] = fullname;
    data['email'] = email;
    data['image'] = image;
    data['token'] = token;
    data['expiresOn'] = expiresOn;
    data['refreshTokenExpiration'] = refreshTokenExpiration;
    return data;
  }
}
