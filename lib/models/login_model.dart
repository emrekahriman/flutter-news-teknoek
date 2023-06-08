class LoginModel {
/*
{
  "status": 200,
  "message": "Login successful.",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpzxczXVCJ9.eyJfaWQiOiI2MzhlNTcmIxY2VkMTE4NDRiZjYiLCJmdWxsTmFtZSI6IkVtcmUgS2FocmltYW4iLCJlbWFpbCI6ImFkbWluQGdtYWlsLmNvbSIsImlhdCI6MTY3MDMyODI0MywiZXhwIjoxNjcwNDE0NjQzfQ.WhqaMzQFsNqnk3Zo9sI33OCx8LSSrrMKjDQSdQKVe60"
} 
*/

  int? status;
  String? message;
  String? token;

  LoginModel({
    this.status,
    this.message,
    this.token,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    token = json['token']?.toString() ?? '';
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token ?? '';
    return data;
  }
}
