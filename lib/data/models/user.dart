class User {
  String? id;
  String email;
  String name;
  String idNumber;
  String phone;
  String password;

  User({
     this.id,
    required this.email,
    required this.name,
    required this.idNumber,
    required this.phone,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      idNumber: json["idNumber"],
      phone: json["phone"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": id,
      "email": email,
      "name": name,
      "idNumber": idNumber,
      "phone": phone,
      "password": password,
    };
  }
//
}
