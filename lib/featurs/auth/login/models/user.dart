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
    id = json['id']?.toString();
    isAdmin = _parseBool(json['isAdmin']);
    message = json['message']?.toString();
    isAuthenticated = _parseBool(json['isAuthenticated']);
    username = json['username']?.toString();
    fullname = json['fullname']?.toString();
    email = json['email']?.toString();
    image = json['image']?.toString();
    token = json['token']?.toString();
    expiresOn = json['expiresOn']?.toString();
    refreshTokenExpiration = json['refreshTokenExpiration']?.toString();
  }

  // Helper method to safely parse boolean values
  bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
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
