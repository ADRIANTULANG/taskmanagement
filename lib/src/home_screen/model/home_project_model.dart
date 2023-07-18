// To parse this JSON data, do
//
//     final projectModel = projectModelFromJson(jsonString);

import 'dart:convert';

List<ProjectModel> projectModelFromJson(String str) => List<ProjectModel>.from(
    json.decode(str).map((x) => ProjectModel.fromJson(x)));

String projectModelToJson(List<ProjectModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProjectModel {
  String id;
  String name;
  String ownerid;
  String image;
  DateTime datecreated;

  ProjectModel({
    required this.id,
    required this.name,
    required this.ownerid,
    required this.image,
    required this.datecreated,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
        id: json["id"],
        name: json["name"],
        ownerid: json["ownerid"],
        image: json["image"],
        datecreated: DateTime.parse(json["datecreated"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "ownerid": ownerid,
        "image": image,
        "datecreated": datecreated.toIso8601String(),
      };
}
