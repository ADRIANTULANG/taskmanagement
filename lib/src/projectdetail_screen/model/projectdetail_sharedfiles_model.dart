// To parse this JSON data, do
//
//     final files = filesFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

List<Files> filesFromJson(String str) =>
    List<Files>.from(json.decode(str).map((x) => Files.fromJson(x)));

String filesToJson(List<Files> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Files {
  String id;
  String name;
  String url;
  DateTime datecreated;
  String type;
  RxBool isDownloading;
  RxDouble progress;

  Files({
    required this.id,
    required this.name,
    required this.url,
    required this.datecreated,
    required this.type,
    required this.isDownloading,
    required this.progress,
  });

  factory Files.fromJson(Map<String, dynamic> json) => Files(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        datecreated: DateTime.parse(json["datecreated"]),
        type: json["type"],
        progress: 0.0.obs,
        isDownloading: false.obs,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "datecreated": datecreated.toIso8601String(),
        "type": type,
        "isDownloading": isDownloading,
        "progress": progress,
      };
}
