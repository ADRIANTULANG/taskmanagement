import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tm/services/getstorage_services.dart';

import '../model/home_project_model.dart';
import '../model/home_user_model.dart';

class HomeController extends GetxController {
  RxList<Users> userList = <Users>[].obs;
  RxList<ProjectModel> projectList = <ProjectModel>[].obs;

  @override
  void onInit() {
    getUsers();
    getProject();
    super.onInit();
  }

  getProject() async {
    List data = [];
    // var res =
    var userDocumentReference = await FirebaseFirestore.instance
        .collection('users')
        .doc(Get.find<StorageServices>().storage.read('id'));
    var res = await FirebaseFirestore.instance
        .collection('members')
        .where("user", isEqualTo: userDocumentReference)
        .get();
    var project = res.docs;
    for (var i = 0; i < project.length; i++) {
      var project_ref = await project[i]['project_ref'].get();
      Map map = {
        "id": project[i]['project_id'],
        "name": project_ref.get('name'),
        "ownerid": project[i]['ownerid'],
        "image": project_ref.get('image'),
        "datecreated": project_ref.get('datecreated').toDate().toString(),
      };
      data.add(map);
    }
    projectList.assignAll(await projectModelFromJson(await jsonEncode(data)));
    projectList.sort((b, a) => a.datecreated.compareTo(b.datecreated));
    print(projectList.length);
  }

  getUsers() async {
    List data = [];
    var res = await FirebaseFirestore.instance.collection('users').get();
    var userlist = res.docs;
    for (var i = 0; i < userlist.length; i++) {
      Map map = {
        "id": userlist[i].id,
        "contactno": userlist[i]['contactno'],
        "email": userlist[i]['email'],
        "fcmToken": userlist[i]['fcmToken'],
        "firstname": userlist[i]['firstname'],
        "lastname": userlist[i]['lastname'],
        "image": userlist[i]['image'] == ""
            ? "https://firebasestorage.googleapis.com/v0/b/taskmanagement-45a52.appspot.com/o/avatar-icon-human-a-person-s-badge-social-media-profile-symbol-the-symbol-of-a-person-vector.jpg?alt=media&token=afbc6a11-a050-42a6-8f7b-07f236de02cb"
            : userlist[i]['image'],
      };
      data.add(map);
    }

    userList.assignAll(await usersFromJson(await jsonEncode(data)));
    userList.removeWhere((element) =>
        element.id == Get.find<StorageServices>().storage.read('id'));
  }
}
