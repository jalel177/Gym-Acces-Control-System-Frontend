class Usermodel {
  final String? email;
  final String? password;
  final String? userid;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? address;

  // Unified constructor with required fields + optional fields
  Usermodel({
     this.email,
    this.password,
    this.userid,
    this.firstname,
    this.lastname,
    this.username,
    this.address,
  });
    String get displayName {
    if (username != null) return username!;
    if (firstname != null || lastname != null) {
      return [firstname, lastname].where((n) => n != null).join(' ');
    }
    return email?.split('@').first ?? 'User';
  }


  // Add these convenience constructors if needed

  // Keep existing fromJson/toJson unchanged
  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
    userid: json["id"],
    firstname: json["firstname"]?.toString(),
    lastname: json["lastname"]?.toString(),
    username: json["username"],
    email: json["email"]?.toString(),
    address: json["address"]?.toString(),
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "id": userid,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "email": email,
    "address": address,
    "password": password,
  };
}