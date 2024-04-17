class UserResponse {
  String? email;
  String? uid;
  String? name;
  String? age;

  UserResponse(
      {required this.email,
      required this.uid,
      required this.age,
      required this.name});
}

class MessageModel {
  String? uid;
  String? message;
  String? path;

  MessageModel({required this.message, required this.uid, this.path});
}
