import 'dart:convert';

List<Chats> chatsFromJson(String str) =>
    List<Chats>.from(json.decode(str).map((x) => Chats.fromJson(x)));

String chatsToJson(List<Chats> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chats {
  String id;
  Senderdetails senderdetails;
  String senderid;
  String chat;
  bool isText;
  List<String> seenby;
  DateTime datecreated;

  Chats({
    required this.id,
    required this.senderdetails,
    required this.senderid,
    required this.chat,
    required this.isText,
    required this.seenby,
    required this.datecreated,
  });

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
        id: json["id"],
        senderdetails: Senderdetails.fromJson(json["senderdetails"]),
        senderid: json["senderid"],
        chat: json["chat"],
        isText: json["isText"],
        seenby: List<String>.from(json["seenby"].map((x) => x)),
        datecreated: DateTime.parse(json["datecreated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "senderdetails": senderdetails.toJson(),
        "senderid": senderid,
        "chat": chat,
        "isText": isText,
        "seenby": List<dynamic>.from(seenby.map((x) => x)),
        "datecreated": datecreated.toIso8601String(),
      };
}

class Senderdetails {
  String image;
  String firstname;
  String password;
  String fcmToken;
  String email;
  String lastname;
  String contactno;
  bool isonline;
  String id;

  Senderdetails({
    required this.image,
    required this.firstname,
    required this.password,
    required this.fcmToken,
    required this.email,
    required this.lastname,
    required this.contactno,
    required this.isonline,
    required this.id,
  });

  factory Senderdetails.fromJson(Map<String, dynamic> json) => Senderdetails(
        image: json["image"],
        firstname: json["firstname"],
        password: json["password"],
        fcmToken: json["fcmToken"],
        email: json["email"],
        lastname: json["lastname"],
        contactno: json["contactno"],
        isonline: json["isonline"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "firstname": firstname,
        "password": password,
        "fcmToken": fcmToken,
        "email": email,
        "lastname": lastname,
        "contactno": contactno,
        "isonline": isonline,
        "id": id,
      };
}
