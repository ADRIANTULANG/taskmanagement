// To parse this JSON data, do
//
//     final Members = MembersFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<Members> membersFromJson(String str) =>
    List<Members>.from(json.decode(str).map((x) => Members.fromJson(x)));

String membersToJson(List<Members> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Members {
  String id;
  String contactno;
  String email;
  String fcmToken;
  String firstname;
  String lastname;
  String image;
  RxBool isSelected;
  bool isonline;

  Members({
    required this.id,
    required this.contactno,
    required this.email,
    required this.fcmToken,
    required this.firstname,
    required this.lastname,
    required this.image,
    required this.isSelected,
    required this.isonline,
  });

  factory Members.fromJson(Map<String, dynamic> json) => Members(
        id: json["id"],
        contactno: json["contactno"],
        email: json["email"],
        isonline: json["isonline"],
        isSelected: false.obs,
        fcmToken: json["fcmToken"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contactno": contactno,
        "isSelected": isSelected,
        "email": email,
        "isonline": isonline,
        "fcmToken": fcmToken,
        "firstname": firstname,
        "lastname": lastname,
        "image": image,
      };
}
