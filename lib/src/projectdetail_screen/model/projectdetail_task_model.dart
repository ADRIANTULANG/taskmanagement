// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

List<TaskModel> taskModelFromJson(String str) =>
    List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

String taskModelToJson(List<TaskModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskModel {
  UserDetails userDetails;
  List<String> comment;
  DateTime created;
  List<String> images;
  String status;
  String task;
  String id;
  DateTime deadline;

  TaskModel({
    required this.id,
    required this.userDetails,
    required this.comment,
    required this.created,
    required this.images,
    required this.status,
    required this.task,
    required this.deadline,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        userDetails: UserDetails.fromJson(json["userDetails"]),
        comment: List<String>.from(json["comment"].map((x) => x)),
        created: DateTime.parse(json["created"]),
        deadline: DateTime.parse(json["deadline"]),
        images: List<String>.from(json["images"].map((x) => x)),
        status: json["status"],
        task: json["task"],
      );

  Map<String, dynamic> toJson() => {
        "userDetails": userDetails.toJson(),
        "comment": List<dynamic>.from(comment.map((x) => x)),
        "created": created.toIso8601String(),
        "deadline": deadline.toIso8601String(),
        "images": List<dynamic>.from(images.map((x) => x)),
        "status": status,
        "task": task,
        "id": id,
      };
}

class UserDetails {
  String image;
  String password;
  String firstname;
  String fcmToken;
  String email;
  String contactno;
  String lastname;

  UserDetails({
    required this.image,
    required this.password,
    required this.firstname,
    required this.fcmToken,
    required this.email,
    required this.contactno,
    required this.lastname,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        image: json["image"],
        password: json["password"],
        firstname: json["firstname"],
        fcmToken: json["fcmToken"],
        email: json["email"],
        contactno: json["contactno"],
        lastname: json["lastname"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "password": password,
        "firstname": firstname,
        "fcmToken": fcmToken,
        "email": email,
        "contactno": contactno,
        "lastname": lastname,
      };
}
