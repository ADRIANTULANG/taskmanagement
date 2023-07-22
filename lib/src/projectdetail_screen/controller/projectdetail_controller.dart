import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tm/services/colors_services.dart';
import 'package:tm/services/getstorage_services.dart';
import 'package:tm/src/home_screen/controller/home_controller.dart';

import '../../../services/notification_services.dart';
import '../../home_screen/model/home_user_model.dart';
import '../model/projectdetail_members_model.dart';
import '../model/projectdetail_sharedfiles_model.dart';
import '../model/projectdetail_task_model.dart';

class ProjectDetailController extends GetxController {
  RxString project_id = ''.obs;
  RxString project_name = ''.obs;
  RxString project_image = ''.obs;
  RxString ownerid = ''.obs;

  RxString date_created = ''.obs;

  RxBool isLoading = true.obs;
  RxBool isCreatingTask = false.obs;
  RxString deadline = ''.obs;
  DateTime deadlineDateTime = DateTime.now();
  RxList<Members> membersList = <Members>[].obs;
  RxList<Members> membersList_masterList = <Members>[].obs;

  TextEditingController task = TextEditingController();
  TextEditingController search = TextEditingController();
  Timer? debounce;
  final ImagePicker picker = ImagePicker();
  RxList<TaskModel> taskList = <TaskModel>[].obs;
  UploadTask? uploadTask;

  RxList<Users> allUsersNotMember = <Users>[].obs;
  RxList<Files> sharedFiles = <Files>[].obs;

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

  RxString fileName = ''.obs;
  RxString filePath = ''.obs;
  RxString fileType = ''.obs;
  @override
  void onInit() async {
    project_id.value = await Get.arguments['project_id'];
    project_name.value = await Get.arguments['project_name'];
    project_image.value = await Get.arguments['project_image'];
    date_created.value = await Get.arguments['date_created'];
    ownerid.value = await Get.arguments['ownerid'];
    await getMembers();
    getTask();
    getNotMember();
    getFiles();
    super.onInit();
  }

  pickImage({required String documentID}) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String path = image.path;
      Uint8List uint8list = Uint8List.fromList(File(path).readAsBytesSync());
      final ref =
          await FirebaseStorage.instance.ref().child("files/${image.name}");
      uploadTask = ref.putData(uint8list);
      final snapshot = await uploadTask!.whenComplete(() {});
      String fileLink = await snapshot.ref.getDownloadURL();
      var taskDocumentReference =
          await FirebaseFirestore.instance.collection('task').doc(documentID);
      taskDocumentReference.update({
        'images': FieldValue.arrayUnion([fileLink])
      });
      getTask();
      Get.snackbar("Message", "Image uploaded",
          backgroundColor: ColorServices.dirtywhite);
    }
  }

  commentToTask({required String documentID, required String comment}) async {
    try {
      var taskDocumentReference =
          await FirebaseFirestore.instance.collection('task').doc(documentID);
      taskDocumentReference.update({
        'comments': FieldValue.arrayUnion([
          comment + "||" + Get.find<StorageServices>().storage.read('email')
        ])
      });
      Get.back();
      getTask();
      for (var i = 0; i < membersList.length; i++) {
        if (membersList[i].id !=
                Get.find<StorageServices>().storage.read('id') &&
            membersList[i].fcmToken != "") {
          Get.find<NotificationServices>().sendNotification(
              userToken: membersList[i].fcmToken,
              bodymessage:
                  "${Get.find<StorageServices>().storage.read('firstname')} commented on a task from a group ${project_name.value}",
              subtitle: "",
              title: "Comment on a task");
        } else {
          print("online");
        }
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  getFiles() async {
    try {
      List data = [];
      var res = await FirebaseFirestore.instance
          .collection('sharedfiles')
          .where('projectid', isEqualTo: project_id.value)
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
      sharedFiles.assignAll(await filesFromJson(jsonEncode(data)));
    } catch (e) {}
  }

  getTask() async {
    try {
      List data = [];
      var res = await FirebaseFirestore.instance
          .collection('task')
          .where('project_id', isEqualTo: project_id.value)
          .get();
      var task = res.docs;
      for (var i = 0; i < task.length; i++) {
        var user = await task[i]['assigned_to'].get();
        var userData = user.data();
        Map map = {
          'id': task[i].id,
          "userDetails": userData,
          "comment": task[i]['comments'],
          "created": task[i]['created'].toDate().toString(),
          "images": task[i]['images'],
          "status": task[i]['status'],
          "task": task[i]['task'],
          "deadline": task[i]['deadline'].toDate().toString(),
        };
        data.add(map);
      }
      taskList.assignAll(await taskModelFromJson(await jsonEncode(data)));
    } catch (e) {
      print(e);
    }
  }

  getNotMember() async {
    allUsersNotMember.assignAll(Get.find<HomeController>().userList);
    allUsersNotMember.removeWhere((element) {
      bool result = false;
      for (var i = 0; i < membersList.length; i++) {
        if (element.id == membersList[i].id) {
          result = true;
        } else {}
      }
      return result;
    });
  }

  getMembers() async {
    List data = [];
    var res = await FirebaseFirestore.instance
        .collection('members')
        .where("project_id", isEqualTo: project_id.value)
        .get();
    var members = res.docs;
    for (var i = 0; i < members.length; i++) {
      var user = await members[i]['user'].get();
      Map map = {
        "id": user.id,
        "isonline": user.get('isonline'),
        "contactno": user.get('contactno'),
        "email": user.get('email'),
        "fcmToken": user.get('fcmToken') ?? "",
        "firstname": user.get('firstname'),
        "lastname": user.get('lastname'),
        "image": user.get('image') == ""
            ? "https://firebasestorage.googleapis.com/v0/b/taskmanagement-45a52.appspot.com/o/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg?alt=media&token=afbc6a11-a050-42a6-8f7b-07f236de02cb"
            : user.get('image'),
      };
      data.add(map);
    }
    membersList.assignAll(await membersFromJson(jsonEncode(data)));
    membersList_masterList.assignAll(await membersFromJson(jsonEncode(data)));
    isLoading(false);
  }

  searchMembers({required String keyword}) async {
    membersList.clear();
    if (keyword != '') {
      for (var i = 0; i < membersList_masterList.length; i++) {
        if (membersList_masterList[i]
            .email
            .toLowerCase()
            .toString()
            .contains(keyword)) {
          membersList.add(membersList_masterList[i]);
        }
      }
    } else {
      membersList.assignAll(membersList_masterList);
    }
  }

  createTask() async {
    isCreatingTask(true);
    String memberid = '';
    for (var i = 0; i < membersList.length; i++) {
      if (membersList[i].isSelected.value == true) {
        memberid = membersList[i].id;
      }
    }

    try {
      if (memberid != '') {
        var memberDocumentRef =
            await FirebaseFirestore.instance.collection('users').doc(memberid);
        await FirebaseFirestore.instance.collection('task').add({
          "project_id": project_id.value,
          "task": task.text,
          "assigned_to": memberDocumentRef,
          "comments": [],
          'created': DateTime.now(),
          'deadline': deadlineDateTime,
          'images': [],
          'status': 'Ongoing',
        });
        getTask();
        Get.back();
        Get.snackbar("Message", "Task created",
            backgroundColor: ColorServices.dirtywhite);
      } else {
        Get.snackbar("Message", "Please choose assignee",
            backgroundColor: ColorServices.dirtywhite);
      }
    } catch (e) {}
    isCreatingTask(false);
  }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    deadline.value = DateFormat('yMMMd').format(args.value);
    deadlineDateTime = args.value;
    Get.back();
  }

  updateTask({required String documentID, required String status}) async {
    try {
      await FirebaseFirestore.instance
          .collection('task')
          .doc(documentID)
          .update({
        "status": status,
      });
      getTask();
      Get.snackbar("Message", "Task updated",
          backgroundColor: ColorServices.dirtywhite);
      for (var i = 0; i < membersList.length; i++) {
        if (membersList[i].id !=
                Get.find<StorageServices>().storage.read('id') &&
            membersList[i].fcmToken != "") {
          Get.find<NotificationServices>().sendNotification(
              userToken: membersList[i].fcmToken,
              bodymessage:
                  "${Get.find<StorageServices>().storage.read('firstname')} updated a task from a group ${project_name.value}",
              subtitle: "",
              title: "Task Update");
        } else {
          print("online");
        }
      }
    } catch (e) {}
  }

  addMembers() async {
    try {
      var projectDocumentReference = await FirebaseFirestore.instance
          .collection('projects')
          .doc(project_id.value);

      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (var i = 0; i < allUsersNotMember.length; i++) {
        if (allUsersNotMember[i].isSelected.value == true) {
          var userDocumentReference = await FirebaseFirestore.instance
              .collection('users')
              .doc(allUsersNotMember[i].id);
          batch.set(
              await FirebaseFirestore.instance.collection('members').doc(), {
            "datecreated": DateTime.now(),
            "ownerid": ownerid.value,
            "project_id": project_id.value,
            "project_ref": projectDocumentReference,
            "user": userDocumentReference,
          });
        }
      }
      await batch.commit();
      Get.back();
      Get.snackbar("Message", "New members added",
          backgroundColor: ColorServices.dirtywhite);
      await getMembers();
      getNotMember();
    } catch (e) {}
  }

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
      await FirebaseFirestore.instance.collection('sharedfiles').add({
        "datecreated": DateTime.now(),
        "name": fileName.value,
        "projectid": project_id.value,
        "type": type,
        "uploadedby": userDocumentReference,
        "url": fileLink
      });
      getFiles();
      Get.snackbar("Message", "File Uploaded",
          backgroundColor: ColorServices.dirtywhite);
      for (var i = 0; i < membersList.length; i++) {
        if (membersList[i].id !=
                Get.find<StorageServices>().storage.read('id') &&
            membersList[i].fcmToken != "") {
          Get.find<NotificationServices>().sendNotification(
              userToken: membersList[i].fcmToken,
              bodymessage:
                  "${Get.find<StorageServices>().storage.read('firstname')} shared a file from a group ${project_name.value}",
              subtitle: "",
              title: "Shared Files");
        } else {
          print("online");
        }
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }

  downloadFile(
      {required String link,
      required int index,
      required BuildContext context,
      required String filename}) async {
    sharedFiles[index].isDownloading.value = true;

    FileDownloader.downloadFile(
        url: link,
        name: filename,
        onProgress: (fileName, progress) {
          double percent = progress / 100;
          sharedFiles[index].progress.value = percent;
        },
        onDownloadCompleted: (String path) {
          sharedFiles[index].isDownloading.value = false;
          Get.snackbar("Message", "File Successfully downloaded",
              backgroundColor: ColorServices.dirtywhite);
        },
        onDownloadError: (String error) {
          sharedFiles[index].isDownloading.value = false;
          print("ERROR: $error");
        });
  }
}
