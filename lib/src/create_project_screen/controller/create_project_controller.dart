import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tm/src/home_screen/controller/home_controller.dart';
import '../../../services/getstorage_services.dart';

class CreateProjectController extends GetxController {
  TextEditingController name = TextEditingController();

  final ImagePicker picker = ImagePicker();
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
  RxBool isCreatingProject = false.obs;
  RxString fileName = ''.obs;
  RxString filePath = ''.obs;
  RxString fileType = ''.obs;
  UploadTask? uploadTask;
  @override
  void onInit() {
    super.onInit();
  }

  //  kani na function is image picker ni sya so if ma trigger ni mo gawas dayun ang mga images na naa sa imoa phone then maka select dayun ka ddtu
  pickProjectImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      filePath.value = image.path;
      fileName.value = image.name;
      fileType.value = image.path.split('/').last.split('.')[1];
    }
  }

// create project na function, mag create ni syag new project then naa na pd dre ang upload sa project image,
// add sa members sa new project by the way ang storage sa mga image na na upload is naa sa firebase ra gyapon
  createProject() async {
    isCreatingProject(true);
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

      var project =
          await FirebaseFirestore.instance.collection('projects').add({
        "name": name.text,
        "image": fileLink,
        "datecreated": DateTime.now(),
        "owner_ref": Get.find<StorageServices>().storage.read('id'),
        "owner_id": userDocumentReference
      });
      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.set(await FirebaseFirestore.instance.collection('members').doc(), {
        "datecreated": DateTime.now(),
        "user": userDocumentReference,
        "project_id": project.id,
        "project_ref": project,
        "ownerid": Get.find<StorageServices>().storage.read('id')
      });
      for (var i = 0; i < Get.find<HomeController>().userList.length; i++) {
        if (Get.find<HomeController>().userList[i].isSelected.value == true) {
          var memberDocumentReference = await FirebaseFirestore.instance
              .collection('users')
              .doc(Get.find<HomeController>().userList[i].id);
          batch.set(
              await FirebaseFirestore.instance.collection('members').doc(), {
            "datecreated": DateTime.now(),
            "user": memberDocumentReference,
            "project_id": project.id,
            "project_ref": project,
            "ownerid": Get.find<StorageServices>().storage.read('id')
          });
        }
      }
      await batch.commit();
      Get.back();
      Get.find<HomeController>().getProject();
      isCreatingProject(false);
    } catch (e) {
      print("ERROR: $e");
    }
    isCreatingProject(false);
  }
}
