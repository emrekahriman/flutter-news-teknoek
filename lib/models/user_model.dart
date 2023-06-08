class UserModel {
/*
{
  "_id": "638e571825fb1ced11844bf6",
  "fullName": "Emre Kahriman",
  "email": "admin@gmail.com",
} 
*/

  String? id;
  String? fullName;
  String? email;

  UserModel({
    this.id,
    this.fullName,
    this.email,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    fullName = json['fullName']?.toString();
    email = json['email']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['_id'] = id;
    data['fullName'] = fullName;
    data['email'] = email;
    return data;
  }
}
