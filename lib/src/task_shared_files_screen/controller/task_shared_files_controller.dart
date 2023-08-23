import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:tm/src/projectdetail_screen/controller/projectdetail_controller.dart';

import '../../../services/colors_services.dart';
import '../../../services/getstorage_services.dart';
import '../../../services/notification_services.dart';
import '../model/task_shared_files_model.dart';

class TaskSharedFilesController extends GetxController {
  RxString taskID = ''.obs;
  RxString project_id = ''.obs;

  RxString fileName = ''.obs;
  RxString filePath = ''.obs;
  RxString fileType = ''.obs;
  UploadTask? uploadTask;
  List<String> formats = [
    'png',
    'jpg',
    'svg',
    'jpeg',
    'gif',
    'docx',
    'csv',
    'pdf',
    'xls',
    'xlsx',
    'ppt',
    'pptx',
    'txt'
  ];

  RxList<TaskFiles> filesList = <TaskFiles>[].obs;

  @override
  void onInit() async {
    taskID.value = await Get.arguments['taskID'];
    project_id.value = await Get.arguments['project_id'];
    getFiles();
    super.onInit();
  }

  getFiles() async {
    try {
      List data = [];
      var res = await FirebaseFirestore.instance
          .collection('tasksharedfiles')
          .where('projectid', isEqualTo: project_id.value)
          .where('task_id', isEqualTo: taskID.value)
          .get();
      var files = res.docs;
      for (var i = 0; i < files.length; i++) {
        var obj = {
          "id": files[i].id,
          "name": files[i]['name'],
          "url": files[i]['url'],
          "datecreated": files[i]['datecreated'].toDate().toString(),
          "type": files[i]['type'],
        };
        data.add(obj);
      }
      filesList.assignAll(await taskfilesFromJson(jsonEncode(data)));
    } catch (e) {}
  }

  // mo pick ug image sa gallery
  pickFilesThenUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: formats,
      type: FileType.custom,
    );
    if (result != null) {
      filePath.value = result.files.single.path!;
      fileName.value = result.files.single.name;
      fileType.value = result.files.single.extension!;
      uploadFile();
    } else {
      // User canceled the picker
    }
  }

// mo upload ug files sa shared resources sa group

  uploadFile() async {
    try {
      String fileLink = '';
      var userDocumentReference = await FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<StorageServices>().storage.read('id'));

      if (fileName != '') {
        Uint8List uint8list =
            Uint8List.fromList(File(filePath.value).readAsBytesSync());
        final ref = await FirebaseStorage.instance
            .ref()
            .child("files/${fileName.value}");
        uploadTask = ref.putData(uint8list);
        final snapshot = await uploadTask!.whenComplete(() {});
        fileLink = await snapshot.ref.getDownloadURL();
      }
      String type = '';

      if (fileType.value == 'png' ||
          fileType.value == 'jpg' ||
          fileType.value == 'svg' ||
          fileType.value == 'jpeg' ||
          fileType.value == 'gif') {
        type = 'image';
      } else {
        type = 'document';
      }
      await FirebaseFirestore.instance.collection('tasksharedfiles').add({
        "datecreated": DateTime.now(),
        "name": fileName.value,
        "projectid": project_id.value,
        "task_id": taskID.value,
        "type": type,
        "uploadedby": userDocumentReference,
        "url": fileLink
      });
      getFiles();
      Get.snackbar("Message", "File Uploaded",
          backgroundColor: ColorServices.dirtywhite);
      for (var i = 0;
          i < Get.find<ProjectDetailController>().membersList.length;
          i++) {
        if (Get.find<ProjectDetailController>().membersList[i].id !=
                Get.find<StorageServices>().storage.read('id') &&
            Get.find<ProjectDetailController>().membersList[i].fcmToken != "") {
          Get.find<NotificationServices>().sendNotification(
              userToken:
                  Get.find<ProjectDetailController>().membersList[i].fcmToken,
              bodymessage:
                  "${Get.find<StorageServices>().storage.read('firstname')} shared a file to a task",
              subtitle: "",
              title: "Shared Files to Task");
        } else {
          print("online");
        }
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }

  // mo download ug files using url or link.
  downloadFile(
      {required String link,
      required int index,
      required BuildContext context,
      required String filename}) async {
    filesList[index].isDownloading.value = true;

    FileDownloader.downloadFile(
        url: link,
        name: filename,
        onProgress: (fileName, progress) {
          double percent = progress / 100;
          filesList[index].progress.value = percent;
        },
        onDownloadCompleted: (String path) {
          filesList[index].isDownloading.value = false;
          Get.snackbar("Message", "File Successfully downloaded",
              backgroundColor: ColorServices.dirtywhite);
        },
        onDownloadError: (String error) {
          filesList[index].isDownloading.value = false;
          print("ERROR: $error");
        });
  }
}
