import '/data/utils/enum.dart';

class User {
  int? id;
  String? name;
  String email;
  String? phone;
  int? age;
  String password;
  String? city;
  UserRole? userRole;

  User(
      {this.id,
      this.name,
      required this.email,
       this.phone,
       this.age,
         this.userRole,
      required this.password,
      this.city});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      age: json["age"],
      city: json["city"],
      password: json["password"],
      userRole: () {
      if (json["roles"] ==UserRole.admin.name) {
        return UserRole.admin;
      }
      return UserRole.user;
    }(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "age": age,
      "password": password,
      "city": city,
      "roles": userRole?.name
    };
  }
//

}
